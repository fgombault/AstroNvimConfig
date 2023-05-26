-- see: https://github.com/hunger/AstroVim/blob/my_config/lua/user/init.lua
local config = {
  colorscheme = 'monokai-pro',
  options = {
    opt = {
      clipboard = 'unnamedplus', -- use the system clipboard
      -- colorcolumn = "80,100",
    },
  },
  plugins = {
    {
      'Exafunction/codeium.vim',
      event = "BufReadPost",
      config = function()
        vim.keymap.set('i', '<Tab>', function() return vim.fn['codeium#Accept']() end, { expr = true })
        vim.keymap.set('i', '<S-Tab>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true })
      end
    },
    {
      -- override nvim-cmp plugin keybindings to avoid conflict with codeium
      "hrsh7th/nvim-cmp",
      opts = function(_, opts)
        opts.mapping["<Tab>"] = nil
        opts.mapping["<S-Tab>"] = nil
        return opts
      end,
    },
    {
      "loctvl842/monokai-pro.nvim",
      name = "monokai-pro",
      config = function()
        require("monokai-pro").setup({ transparent_background = true, filter = "spectrum" })
      end,
    },
    { 'tpope/vim-sleuth',            event = "BufReadPost" }, -- detect indentation style
    { 'roxma/vim-paste-easy',        event = "BufReadPost" }, -- paste without indent
    { 'mechatroner/rainbow_csv',     ft = { 'csv' } },
    { 'dag/vim-fish',                ft = { 'fish' } },
    { 'alaviss/nim.nvim',            ft = { 'nim' } },        -- TODO: maybe remove if LSP
    { 'AndrewRadev/inline_edit.vim', event = "BufReadPost" }, -- InlineEdit command
    {
      "folke/todo-comments.nvim",                             -- highlight todos and move through them
      event = "BufReadPost",
      dependencies = { "nvim-lua/plenary.nvim" },
      opts = {},
    },
    -- other plugins to consider
    -- emmet-vim, for expanding abbreviations (essential for web dev?)
    -- fast travel (trailblazer? litee-bookmarks?)
  },
}
-- cmd+S can save, this needs a terminal (kitty) config to send ctrl-s
-- https://stackoverflow.com/questions/33060569/mapping-command-s-to-w-in-vim
-- vim.api.nvim_set_keymap("i", "<C-s>", "<Esc>:w<CR>i", {noremap = true})
-- vim.api.nvim_set_keymap("n", "<C-s>", ":w<CR>", {noremap = true})
return config
