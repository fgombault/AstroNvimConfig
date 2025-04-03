

return {
  {
  "olimorris/codecompanion.nvim",
  event = "BufReadPost",
  config = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    },
  opts = function(_, opts)
    opts.adapters = {
      openrouter = function()
        return require("codecompanion.adapters").extend("openai_compatible", {
          env = {
            url = "https://openrouter.ai/api",
            api_key = os.getenv("OPENROUTER_API_KEY"),
            chat_url = "/v1/chat/completions",
          },
          schema = {
            model = {
              default = "anthropic/claude-3.7-sonnet",
            },
          },
        })
      end
    }
    opts.display = {
      diff = {
        enabled = true,
        close_chat_at = 240, -- Close an open chat buffer if the total columns of your display are less than...
        layout = "vertical", -- vertical|horizontal split for default provider
        -- opts = { "internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120" },
        opts = { "algorithm:minimal", "filler", "vertical",  "iwhite", "linematch:60", "context:999999" },
        provider = "default", -- default|mini_diff
      },
    }
    opts.strategies = {
      chat = {
        -- Change the default chat adapter
        adapter = "openrouter",
        },
      inline = {
        adapter = "openrouter",
        },
      cmd = {
        adapter = "openrouter",
        },
      }
    opts.opts = {
      -- Set debug logging
      log_level = "DEBUG",
      }
    return opts
    end,
  },
}
