local map = vim.keymap.set
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
      opts = { char = '.' },
    },
    {
      'beauwilliams/focus.nvim', -- window management and resizing
      event = "BufReadPost",
      opts = { hybridnumber = true },
      config = function()
        require('focus').setup({ hybridnumber = true })
        map("n", "g,", ":FocusSplitCycle<CR>", { desc = "Cycle Focus" })
      end,
    },
    {
      'levouh/tint.nvim', -- unfocused windows are darker
      event = "BufReadPost",
      config = function()
        require('tint').setup({
          tint = -65,
          highlight_ignore_patterns = { "WinSeparator", "Status.*" },
          window_ignore_function = function(winid)
            local bufid = vim.api.nvim_win_get_buf(winid)
            local buftype = vim.api.nvim_buf_get_option(bufid, "buftype")
            local floating = vim.api.nvim_win_get_config(winid).relative ~= ""
            local badtypes = { "terminal" }
            local function is_bad(t)
              for _, type in ipairs(badtypes) do
                if string.lower(type) == t then return true end
              end
            end
            -- Do not tint floating windows and blacklisted types
            return floating or is_bad(buftype)
          end
        })
        -- fix neotree/tint issue not giving colors back to the text buffer
        map('n', '<leader>e', function()
            vim.cmd([[Neotree toggle]])
            local t = require("tint")
            t.toggle()
            t.toggle()
          end,
          { desc = "Toggle Explorer" })
      end
    },
    {
      'echasnovski/mini.jump2d', -- Jump around with ',' key
      version = false,
      event = "BufReadPost",
      dependencies = { 'echasnovski/mini.nvim' },
      opts = {
        labels = "abcdefghiklmnopqrstuvwxy",
        mappings = {
          start_jumping = ',',
        },
      },
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
      "romainl/vim-cool", -- prevent stale search highlighting
      event = "User AstroFile",
    }
    -- other plugins to consider
    -- emmet-vim, for expanding abbreviations (essential for web dev?)
  },

  polish = function()
    -- cmd+S can save, this needs a terminal (kitty) config to send ctrl-s
    -- note: normal mode shortcut already exists in vanilla astronvim
    map("i", "<C-s>", "<Esc>:w!<CR>i", { desc = "Save in insert mode" })

    -- fix some colors
    vim.cmd([[hi WinSeparator ctermbg=NONE guibg=NONE guifg=#AA0000]])
    vim.cmd([[hi CursorLine guibg=#401A11]])
    require("notify").setup({ background_colour = "#000000" })

    map('n', '<leader>gg', function()
        require("astronvim.utils").toggle_term_cmd "lazygit"
      end,
      { desc = "Toggle Lazygit" })
  end
}

return config

-- TODO: investigate snippet options
-- https://www.youtube.com/playlist?list=PL0EgBggsoPCnZ3a6c0pZuQRMgS_Z8-Fnr
