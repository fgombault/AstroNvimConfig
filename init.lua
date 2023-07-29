local map = vim.keymap.set
local config = {
  colorscheme = 'dracula',
  options = {
    opt = {
      clipboard = 'unnamedplus', -- use the system clipboard
      colorcolumn = "80,100",
      showtabline = 0,           -- tab line is clutter for my usage
    },
  },
  icons = function()
    local myicons = require("astronvim.icons.nerd_font")
    myicons['FileModified'] = "💾"
    return myicons
  end,
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
      "rebelot/heirline.nvim",
      opts = function(_, opts)
        local status = require("astronvim.utils.status")
        opts.statusline = {
          hl = { fg = "fg", bg = "bg" },
          status.component.mode { mode_text =
          { padding = { left = 1, right = 1 } } }, -- add the mode text
          status.component.git_branch(),
          status.component.file_info(),            -- filename & modified status
          status.component.git_diff(),
          status.component.diagnostics(),
          status.component.fill(),
          status.component.cmd_info(),
          status.component.fill(),
          status.component.lsp(),
          status.component.treesitter(),
          status.component.nav { scrollbar = false },
          -- removed right-side mode color block
        }
        return opts
      end,
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
      'tpope/vim-sleuth',      -- detect indentation style
      event = "User Astrofile" -- for plugins related to "real files"
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
      event = "BufEnter",
      opts = { char = '.' },
    },
    {
      'beauwilliams/focus.nvim', -- window management and resizing
      event = "BufEnter",
      opts = { hybridnumber = true },
      config = function()
        require('focus').setup({ hybridnumber = true })
        map("n", "g,", ":FocusSplitCycle<CR>", { desc = "Cycle Focus" })
      end,
    },
    {
      'ojroques/nvim-bufdel', -- no buffer deletion puzzles
      event = "BufReadPost",
      config = function()
        require('bufdel').setup()
        map("n", "<leader>Q", ":BufDel<CR>", { desc = "Delete Buffer" })
        map("n", "<leader>q", ":BufDel<CR>:q<CR>",
          { desc = "Delete Buffer and window" })
      end,
    },
    {
      'levouh/tint.nvim', -- unfocused windows are darker
      event = "BufReadPost",
      config = function()
        require('tint').setup({
          tint = -65,
          highlight_ignore_patterns = { "WinSeparator", "Status.*" },
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
      config = function()
        local jump = require("mini.jump2d")
        local sp1 = jump.gen_pattern_spotter('[%w\'"]+', 'start')
        local sp2 = jump.gen_pattern_spotter('[{,}]$', 'start')
        local opts = {
          spotter = jump.gen_union_spotter(sp1, sp2),
          labels = "abcdefghiklmnopqrsuvwxy",
          mappings = {
            start_jumping = ',',
          },
          view = {
            n_steps_ahead = 1,
          },
        }
        jump.setup(opts)
        vim.cmd([[hi MiniJump2dSpot guifg=#FFFFEE guibg=#DD2222]])
        vim.cmd([[hi MiniJump2dSpotAhead guifg=#FFFFEE guibg=#B52222]])
      end,
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
      event = "BufReadPost",
    },
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

    vim.cmd([[set wrap]])

    map("n", "<leader>b", "<cmd>s/^ *//<cr>" ..
      "<cmd>s/$/ /<cr>" ..
      "<cmd>.!toilet -f pagga<cr>" ..
      "<cmd>lua require('Comment.api').toggle.count(3)<cr>",
      { desc = "Comment banner" })

    map('n', '<leader>gg', function()
        require("astronvim.utils").toggle_term_cmd "lazygit"
      end,
      { desc = "Toggle Lazygit" })

    require("luasnip.loaders.from_vscode").lazy_load(
      { paths = { "./lua/user/vscode_snippets" } })
    require("luasnip").filetype_extend("just", { "sh" })
  end
}

return config
