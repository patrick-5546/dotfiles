-- Checks that Neovim is ready to use the first time it starts after the
-- dotfiles install: lazy.nvim installs the plugins, Mason installs the tools
-- and language servers, nvim-treesitter builds the parsers, and the Python
-- language servers start. The test scripts run it on a new Python file:
--   nvim --headless check.py -S check-nvim.lua
-- It reports what it checked and the problems it finds on stderr, and exits
-- with status 1 if there are any.

local report = {} ---@type string[]
local function say(message)
  report[#report + 1] = message
end

local problems = {} ---@type string[]
local function problem(message)
  problems[#problems + 1] = message
end

-- Waits until done() returns true, for at most the given number of minutes
local function wait(minutes, done)
  return vim.wait(minutes * 60 * 1000, done, 1000)
end

-- Opening the file already started Mason's installs, so record their errors
-- before they can fail. An error here would stop the check from running, so
-- it's reported instead
local install_errors = {} ---@type table<string, string>
local watching, watch_error = pcall(function()
  require("mason-registry"):on("package:install:failed", function(pkg, err)
    install_errors[pkg.name] = type(err) == "string" and err or vim.inspect(err)
  end)
end)
if not watching then
  problem("Can't watch Mason's installs: " .. watch_error)
end

local function check_plugins()
  local count, installed = 0, 0
  for _, plugin in pairs(require("lazy.core.config").plugins) do
    if plugin._.cond ~= false then
      count = count + 1
      if not plugin._.installed then
        problem("lazy.nvim didn't install " .. plugin.name)
      elseif require("lazy.core.plugin").has_errors(plugin) then
        problem("lazy.nvim couldn't install or build " .. plugin.name)
      else
        installed = installed + 1
      end
    end
  end
  say(("lazy.nvim installed %d of %d plugins"):format(installed, count))
end

local function check_mason()
  local registry = require("mason-registry")
  -- mason-lspconfig only installs the language servers when Neovim has a UI, so
  -- do what it does in a terminal
  require("mason-lspconfig.features.ensure_installed")()
  -- LazyVim's tools, and the language servers it has mason-lspconfig install
  local names = vim.deepcopy(LazyVim.opts("mason.nvim").ensure_installed or {})
  local server_packages = require("mason-lspconfig.mappings").get_mason_map().lspconfig_to_package
  for _, server in ipairs(require("mason-lspconfig.settings").current.ensure_installed) do
    names[#names + 1] = server_packages[server] or server
  end

  local packages = {} ---@type table<string, Package>
  for _, name in ipairs(names) do
    if registry.has_package(name) then
      packages[name] = registry.get_package(name)
    else
      problem("Mason's registry doesn't have " .. name)
    end
  end
  wait(10, function()
    return vim.iter(packages):all(function(_, pkg)
      return pkg:is_installed() or not pkg:is_installing()
    end)
  end)

  local installed = {} ---@type string[]
  for _, pkg in pairs(packages) do
    if pkg:is_installed() then
      installed[#installed + 1] = pkg.name
    else
      local reason = install_errors[pkg.name] or (pkg:is_installing() and "timed out" or "didn't start")
      problem(("Mason didn't install %s: %s"):format(pkg.name, reason))
    end
  end
  table.sort(installed)
  say("Mason installed " .. table.concat(installed, ", "))
end

local function check_parsers()
  local TS = require("nvim-treesitter")
  -- The parsers LazyVim installs. Their dependencies only have queries
  local langs = require("nvim-treesitter.config").norm_languages(
    LazyVim.opts("nvim-treesitter").ensure_installed,
    { unsupported = true, dependencies = true }
  )
  local function missing()
    local installed = TS.get_installed("parsers")
    return vim.tbl_filter(function(lang)
      return not vim.list_contains(installed, lang)
    end, langs)
  end
  wait(10, function()
    return #missing() == 0
  end)

  local missed = missing()
  for _, lang in ipairs(missed) do
    problem(("nvim-treesitter didn't install the %s parser"):format(lang))
  end
  for _, lang in ipairs(langs) do
    if not vim.list_contains(missed, lang) then
      local ok, loaded, err = pcall(vim.treesitter.language.add, lang)
      if not (ok and loaded) then
        problem(("Neovim can't load the %s parser: %s"):format(lang, ok and err or loaded))
      end
    end
  end
  say(("nvim-treesitter installed %d of %d parsers"):format(#langs - #missed, #langs))
end

local function check_language_servers(buf)
  local names = { vim.g.lazyvim_python_lsp or "pyright", vim.g.lazyvim_python_ruff or "ruff" }
  local function started(name)
    return vim.iter(vim.lsp.get_clients({ bufnr = buf, name = name })):any(function(client)
      return client.initialized
    end)
  end
  wait(2, function()
    return vim.iter(names):all(started)
  end)

  for _, name in ipairs(names) do
    if started(name) then
      say(("The %s language server started"):format(name))
    else
      problem(("The %s language server didn't start for %s"):format(name, vim.api.nvim_buf_get_name(buf)))
    end
  end
end

local function check()
  local buf = vim.api.nvim_get_current_buf()
  check_plugins()
  check_mason()
  check_parsers()
  check_language_servers(buf)
end

-- Runs once startup finishes, like a session where you open a file
vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = vim.schedule_wrap(function()
    local ok, err = xpcall(check, debug.traceback)
    if not ok then
      problem("The check failed: " .. err)
    end
    if #problems == 0 then
      say("Neovim is ready to use")
    end
    vim.list_extend(report, problems)

    -- On stderr, since the test scripts only show lazy.nvim's install log on
    -- stdout if the check fails. Neovim's messages, which are also on stderr,
    -- don't end with a newline, so the report starts with one
    io.stderr:write("\n", table.concat(report, "\n"), "\n")
    vim.cmd(#problems == 0 and "qall!" or "cquit")
  end),
})
