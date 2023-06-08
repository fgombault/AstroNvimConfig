-- see: https://github.com/hunger/AstroVim/blob/my_config/lua/user/init.lua
local config = {
  colorscheme = 'dracula',
  options = {
    opt = {
      clipboard = 'unnamedplus', -- use the system clipboard
      colorcolumn = "80,100",
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
        vim.keymap.set('i', '<S-Right>', function()
            return vim.fn['codeium#Accept']()
          end,
          { expr = true })
        vim.keymap.set('i', '<c-Right>', function()
            return vim.fn['codeium#CycleCompletions'](1)
          end,
          { expr = true })
        vim.g.codeium_tab_fallback = '' -- don't insert a tab
        vim.g.codeium_idle_delay = 1000 -- avoid frantic suggestions
      end
    },
    {
      "Mofiqul/dracula.nvim", -- in case of issue, try catppuccin
      config = function()
        local dracula = require("dracula")
        local c = dracula.colors()
        c['bg'] = '#1A1A1A' -- the same as my terminal background
        dracula.setup({
          colors = c
        })
      end,
    },
    {
      'tpope/vim-sleuth', -- detect indentation style
      event = "BufReadPost"
    },
    {
      'roxma/vim-paste-easy', -- paste without indent
      event = "BufReadPost"
    },
    {
      'mechatroner/rainbow_csv',
      ft = { 'csv' }
    },
    {
      'dag/vim-fish', -- highlighting for fish
      ft = { 'fish' }
    },
    {
      'alaviss/nim.nvim', -- highlighting for nim
      ft = { 'nim' }
    },

    {
      'NoahTheDuke/vim-just', -- highlighting for just
      ft = { 'just' }
    },
    {
      'AndrewRadev/inline_edit.vim', -- InlineEdit command
      event = "BufReadPost"
    },
    {
      'lukas-reineke/virt-column.nvim', -- discreet color column
      event = "BufReadPost",
      config = function()
        require('virt-column').setup({ char = '.' })
      end
    },
    {
      'beauwilliams/focus.nvim',
      event = "BufReadPost",
      config = function()
        require("focus").setup({ hybridnumber = true })
      end
    },
    {
      'sunjon/shade.nvim', -- FIXME: levouh/tint can ignore the explorer
      event = "BufReadPost",
      config = function()
        require('shade').setup({
          overlay_opacity = 65,
        })
      end
    },
    {
      'echasnovski/mini.jump2d', -- Jump around with ',' key
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
      "folke/todo-comments.nvim",                 -- highlight todos & jump
      event = "BufReadPost",
      dependencies = { "nvim-lua/plenary.nvim" }, -- + "brew install ripgrep"
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
        { "<leader>x", desc = "Trouble" },
        {
          "<leader>i",
          "<cmd>TodoTrouble<cr>",
          desc = "Document TODO comments"
        },
        {
          "<leader>x" .. "X",
          "<cmd>TroubleToggle workspace_diagnostics<cr>",
          desc = "Workspace Diagnostics (Trouble)"
        },
        {
          "<leader>x" .. "x",
          "<cmd>TroubleToggle document_diagnostics<cr>",
          desc = "Document Diagnostics (Trouble)"
        },
        {
          "<leader>x" .. "l",
          "<cmd>TroubleToggle loclist<cr>",
          desc = "Location List (Trouble)"
        },
        {
          "<leader>x" .. "q",
          "<cmd>TroubleToggle quickfix<cr>",
          desc = "Quickfix List (Trouble)"
        },
      },
      opts = {
        use_diagnostic_signs = true,
        action_keys = {
          close = { "q", "<esc>" },
          cancel = "<c-e>",
        },
      },
    },
    {
      "romainl/vim-cool", -- prevent stale search highlightig
      event = "User AstroFile",
    }
    -- other plugins to consider
    -- emmet-vim, for expanding abbreviations (essential for web dev?)
  },

  polish = function()
    local map = vim.api.nvim_set_keymap
    -- cmd+S can save, this needs a terminal (kitty) config to send ctrl-s
    -- note: normal mode shortcut already exists in vanilla astronvim
    map("i", "<C-s>", "<Esc>:w!<CR>i", { desc = "Save in insert mode" })

    -- fix some colors
    vim.cmd([[hi WinSeparator ctermbg=NONE guibg=NONE guifg=#AA0000]])
    require("notify").setup({ background_colour = "#000000" })

    vim.keymap.set('n', '<leader>gg', function()
        require("astronvim.utils").toggle_term_cmd "lazygit"
      end,
      { desc = "Toggle Lazygit" })
  end
}

return config

-- TODO: investigate snippet options
-- https://www.youtube.com/playlist?list=PL0EgBggsoPCnZ3a6c0pZuQRMgS_Z8-Fnr
-- TODO: linter
-- TODO: signatures, https://github.com/ray-x/lsp_signature.nvim
-- TODO: hover ? https://github.com/lewis6991/hover.nvim
-- TODO: https://github.com/nvim-neotest/neotest
