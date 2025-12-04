local map = vim.keymap.set
return {
  {
    'Exafunction/codeium.vim',
    event = "BufReadPost",
    config = function()
      map('i', '<S-Right>', function()
          return vim.fn['codeium#Accept']()
        end,
        { expr = true })
      map('i', '<c-Right>', function()
          return vim.fn['codeium#CycleCompletions'](1)
        end,
        { expr = true })
      vim.g.codeium_tab_fallback = '' -- don't insert a tab
      vim.g.codeium_idle_delay = 1000 -- avoid frantic suggestions
      vim.cmd([[let g:codeium_filetypes = {
  \ "nim": v:true,
  \ "fish": v:false,
  \ }]])
    end
  },
  {
    "rebelot/heirline.nvim",
    opts = function(_, opts)
      local status = require("astroui.status")
      local opencode = {
        static = {
          text = "",
          abbrev = "",
          fghl = "gray",
        },
         update = {
           "User",
           pattern = "OpencodeEvent:*",
           callback = function(self, args)
             local event = args.data.event
             require("opencode.status").update(event)
             self.text = require("opencode").statusline()
             if self.text == "󰚩" then
               self.abbrev = "IDL"
               self.fghl = "cyan"
             elseif self.text == "󱜙" then
               self.abbrev = "RSP"
               self.fghl = "red"
             elseif self.text == "󱚟" then
               self.abbrev = "PRM"
               self.fghl = "yellow"
             elseif self.text == "󱚡" then
               self.abbrev = "ERR"
               self.fghl = "red"
              else
                self.abbrev = "UNK"
                self.fghl = "gray"
              end
              vim.cmd("redrawstatus")
            end,
         },
        {
          condition = function(self)
            return self.text ~= ""
          end,
          provider = function(self)
            return " " .. self.text .. " " .. self.abbrev .. " "
          end,
          hl = function(self)
            return { fg = self.fghl }
          end,
        },
      }
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
        opencode,
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
    'tenxsoydev/tabs-vs-spaces.nvim',      -- detect indentation style
    config = function()
      require('tabs-vs-spaces').setup()
    end,
    event = "User Astrofile"     -- for plugins related to "real files"
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
      require('focus').setup({ hybridnumber = true, autoresize = { enable = false } })
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
    opts = function(_, opts)
      local td = require("todo-comments")
      opts.highlight = {
        throttle = 2000,
        multiline = false,
        comments_only = true,
        pattern = { [[.*<(KEYWORDS)\s*:?]], },
      }
      return opts
    end,
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
  {
    "tikhomirov/vim-glsl", -- gl shader language
    event = "BufReadPost",
  },
  -- other plugins to consider
  -- emmet-vim, for expanding abbreviations (essential for web dev?)
}
