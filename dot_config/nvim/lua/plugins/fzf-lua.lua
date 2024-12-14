-- https://github.com/LazyVim/LazyVim/discussions/338#discussioncomment-5109479
return {
  {
    -- https://github.com/ibhagwan/fzf-lua
    "ibhagwan/fzf-lua",
    keys = {
      -- mimic vs code quick open
      { "<C-p>", LazyVim.pick("files"), desc = "Find Files (Root Dir)" },
    },
  },
}
