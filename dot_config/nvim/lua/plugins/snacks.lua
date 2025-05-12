return {
  {
    "patrick-5546/snacks.nvim",
    keys = {
      -- mimic vs code quick open
      { "<C-p>", LazyVim.pick("files"), desc = "Find Files (Root Dir)" },
    },
    opts = {
      dashboard = {
        preset = {
          -- generated using https://patorjk.com/software/taag/#p=display&v=0&f=ANSI%20Shadow&t=VIMTRICK
          header = [[
██╗   ██╗██╗███╗   ███╗████████╗██████╗ ██╗ ██████╗██╗  ██╗
██║   ██║██║████╗ ████║╚══██╔══╝██╔══██╗██║██╔════╝██║ ██╔╝
██║   ██║██║██╔████╔██║   ██║   ██████╔╝██║██║     █████╔╝ 
╚██╗ ██╔╝██║██║╚██╔╝██║   ██║   ██╔══██╗██║██║     ██╔═██╗ 
 ╚████╔╝ ██║██║ ╚═╝ ██║   ██║   ██║  ██║██║╚██████╗██║  ██╗
  ╚═══╝  ╚═╝╚═╝     ╚═╝   ╚═╝   ╚═╝  ╚═╝╚═╝ ╚═════╝╚═╝  ╚═╝
          ]],
        },
      },
      picker = {
        sources = {
          files = { hidden = true },
          grep = { hidden = true },
          explorer = {
            hidden = true,
            layout = {
              preset = "sidebar",
              preview = false,
              layout = {
                position = "right",
              },
            },
          },
        },
      },
    },
  },
}
