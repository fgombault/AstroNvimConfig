-- see: https://github.com/hunger/AstroVim/blob/my_config/lua/user/init.lua
local config = {
  colorscheme = 'dracula',
  options = {
    opt = {
      clipboard = 'unnamedplus', -- use the system clipboard
      -- colorcolumn = "80,100",
    },
  },
  diagnostics = {
    update_in_insert = false, -- this helps see codeium suggestions clearly
  },
  plugins = {
    {
      'Exafunction/codeium.vim',
      event = "BufReadPost",
      config = function()
        vim.keymap.set('i', '<Right>', function() return vim.fn['codeium#Accept']() end, { expr = true })
        vim.keymap.set('i', '<S-Right>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true })
        vim.g.codeium_tab_fallback = '<Right>' -- our key is right, so move right (and don't insert a tab)
      end
    },
    {
      "Mofiqul/dracula.nvim", -- in case of issue, try https://github.com/catppuccin/nvim
      opts = {
        transparent_bg = true,
      },
    },
    { 'tpope/vim-sleuth',            event = "BufReadPost" }, -- detect indentation style
    { 'roxma/vim-paste-easy',        event = "BufReadPost" }, -- paste without indent
    { 'mechatroner/rainbow_csv',     ft = { 'csv' } },
    { 'dag/vim-fish',                ft = { 'fish' } },
    { 'alaviss/nim.nvim',            ft = { 'nim' } },        -- treesitter has no support for nim
    { 'AndrewRadev/inline_edit.vim', event = "BufReadPost" }, -- InlineEdit command
    {
      'echasnovski/mini.jump2d',                              -- Jump around with ',' key
      version = false,
      event = "BufReadPost",
      dependencies = { 'echasnovski/mini.nvim' },
      config = function()
        require('mini.jump2d').setup({
          labels = "abcdefghiklmnopqrstuvwxy",
          mappings = {
            start_jumping = ',',
          },
        })
      end
    },
    {
      "folke/todo-comments.nvim",                 -- highlight todos and move through them
      event = "BufReadPost",
      dependencies = { "nvim-lua/plenary.nvim" }, -- this also requires "brew install ripgrep"
      opts = {
        highlight = {
          throttle = 2000,
          multiline = false,
        }
      },
    },
    {
      "folke/trouble.nvim",
      event = "BufReadPost",
      cmd = { "TroubleToggle", "Trouble" },
      keys = {
        { "<leader>x",        desc = "Trouble" },
        { "<leader>i",        "<cmd>TodoTrouble<cr>",                         desc = "Document TODO comments" },
        { "<leader>x" .. "X", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
        { "<leader>x" .. "x", "<cmd>TroubleToggle document_diagnostics<cr>",  desc = "Document Diagnostics (Trouble)" },
        { "<leader>x" .. "l", "<cmd>TroubleToggle loclist<cr>",               desc = "Location List (Trouble)" },
        { "<leader>x" .. "q", "<cmd>TroubleToggle quickfix<cr>",              desc = "Quickfix List (Trouble)" },
      },
      opts = {
        use_diagnostic_signs = true,
        action_keys = {
          close = { "q", "<esc>" },
          cancel = "<c-e>",
        },
      },
    },
    -- other plugins to consider
    -- emmet-vim, for expanding abbreviations (essential for web dev?)
  },

  polish = function()
    local map = vim.api.nvim_set_keymap
    -- cmd+S can save, this needs a terminal (kitty) config to send ctrl-s
    -- note: normal mode shortcut already exists in vanilla astronvim
    map("i", "<C-s>", "<Esc>:w!<CR>i", { desc = "Save in insert mode" })
  end
}

return config

-- TODO: investigate snippet options
-- TODO: linter
-- TODO: signatures, https://github.com/ray-x/lsp_signature.nvim
-- TODO: hover ? https://github.com/lewis6991/hover.nvim
-- TODO: https://github.com/nvim-neotest/neotest
