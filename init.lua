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
      'jcdickinson/codeium.nvim', -- using this plugin for compatibility with cmp
      event = "BufReadPost",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "hrsh7th/nvim-cmp" },
      config = function()
        require("codeium").setup({})
      end
    },
    {
      -- add codeium source to cmp
      "hrsh7th/nvim-cmp",
      -- override the options table that is used in the `require("cmp").setup()` call
      opts = function(_, opts)
        -- opts parameter is the default options table
        -- the function is lazy loaded so cmp is able to be required
        local cmp = require "cmp"
        -- modify the sources part of the options table
        opts.sources = cmp.config.sources {
          { name = "nvim_lsp", priority = 1000 },
          { name = "luasnip",  priority = 750 },
          { name = "buffer",   priority = 500 },
          { name = "path",     priority = 250 },
          { name = "codeium",  priority = 800, max_item_count = 3 }, -- add new source
        }
        opts.experimental = {
          ghost_text = true
        }
        -- return the new table to be used
        return opts
      end,
    },
    {
      "loctvl842/monokai-pro.nvim",
      name = "monokai-pro",
      config = function()
        require("monokai-pro").setup({ filter = "spectrum" })
      end,
    },
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
