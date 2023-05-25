-- see: https://github.com/hunger/AstroVim/blob/my_config/lua/user/init.lua
local config = {
  colorscheme = 'koehler',
  options = {
    opt = {
      clipboard = 'unnamedplus', -- use the system clipboard
      -- colorcolumn = "80,100",
    },
  },
  plugins = {
    { 'Exafunction/codeium.vim',     event = "BufReadPost" }, -- FIX: tab conflict with cmp
    -- https://github.com/hrsh7th/nvim-cmp/blob/b16e5bcf1d8fd466c289eab2472d064bcd7bab5d/doc/cmp.txt#L830-L852
    -- https://github.com/Exafunction/codeium.vim#-installation-options
    -- cmp-ai would be best? https://github.com/tzachar/cmp-ai/blob/main/lua/cmp_ai/backends/bard.lua
    { 'tpope/vim-sleuth',            event = "BufReadPost" }, -- detect indentation style
    { 'roxma/vim-paste-easy',        event = "BufReadPost" }, -- paste without indent
    { 'mechatroner/rainbow_csv',     ft = { 'csv' } },
    { 'dag/vim-fish',                ft = { 'fish' } },
    { 'alaviss/nim.nvim',            ft = { 'nim' } },        -- TODO: maybe remove if LSP
    { 'AndrewRadev/inline_edit.vim', event = "BufReadPost" }, -- InlineEdit command
    -- other plugins to consider
    -- emmet-vim, for expanding abbreviations (essential for web dev?)
    -- fast travel (trailblazer? litee-bookmarks?)
    -- https://github.com/folke/todo-comments.nvim and friends
  },
}
-- cmd+S can save, this needs a terminal (kitty) config to send ctrl-s
-- https://stackoverflow.com/questions/33060569/mapping-command-s-to-w-in-vim
-- vim.api.nvim_set_keymap("i", "<C-s>", "<Esc>:w<CR>i", {noremap = true})
-- vim.api.nvim_set_keymap("n", "<C-s>", ":w<CR>", {noremap = true})
return config
