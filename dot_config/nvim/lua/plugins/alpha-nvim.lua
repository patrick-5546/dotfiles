return {
  {
    -- https://github.com/goolord/alpha-nvim
    "goolord/alpha-nvim",
    opts = function()
      local dashboard = require("alpha.themes.dashboard")

      -- generated using https://patorjk.com/software/taag/#p=display&v=0&f=ANSI%20Shadow&t=NVIMTRICK
      local logo = [[
      ███╗   ██╗██╗   ██╗██╗███╗   ███╗████████╗██████╗ ██╗ ██████╗██╗  ██╗
      ████╗  ██║██║   ██║██║████╗ ████║╚══██╔══╝██╔══██╗██║██╔════╝██║ ██╔╝
      ██╔██╗ ██║██║   ██║██║██╔████╔██║   ██║   ██████╔╝██║██║     █████╔╝ 
      ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║   ██║   ██╔══██╗██║██║     ██╔═██╗ 
      ██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║   ██║   ██║  ██║██║╚██████╗██║  ██╗
      ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝   ╚═╝   ╚═╝  ╚═╝╚═╝ ╚═════╝╚═╝  ╚═╝
      ]]

      dashboard.section.header.val = vim.split(logo, "\n")
    end,
  },
}
