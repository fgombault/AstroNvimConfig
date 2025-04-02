-- if true then return end -- COMMENT THIS LINE TO ACTIVATE THIS FILE

-- This will run last in the setup process and is a good place to configure
-- things like custom filetypes. This just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- Set up custom filetypes
-- vim.filetype.add {
--   extension = {
--     foo = "fooscript",
--   },
--   filename = {
--     ["Foofile"] = "fooscript",
--   },
--   pattern = {
--     ["~/%.config/foo/.*"] = "fooscript",
--   },
-- }


local map = vim.keymap.set
-- cmd+S can save, this needs a terminal (kitty) config to send ctrl-s
-- note: normal mode shortcut already exists in vanilla astronvim
map("i", "<C-s>", "<Esc>:w!<CR>i", { desc = "Save in insert mode" })

-- fix some colors
vim.cmd([[colorscheme dracula]])
vim.cmd([[hi WinSeparator ctermbg=NONE guibg=NONE guifg=#AA0000]])
vim.cmd([[hi CursorLine guibg=#401A11]])
-- require("notify").setup({ background_colour = "#000000" }) -- WARN: The notify background has to be migrated to snack, maybe

vim.cmd([[set wrap]])

map("n", "<leader>b", "<cmd>s/^ *//<cr>" ..
  "<cmd>s/$/ /<cr>" ..
  "o<esc><up>" ..
  "<cmd>.!toilet -f pagga -w 77<cr>" ..
  "<cmd>lua require('Comment.api').toggle.linewise(3)<cr>" ..
  "<down><down><down>",
  { desc = "Comment banner" })

map('n', '<leader>gg', function()
    require("astrocore").toggle_term_cmd "lazygit"
  end,
  { desc = "Toggle Lazygit" })

vim.filetype.add(
  {
    extension = {
      f = "glsl",
      v = "glsl"
    },
  }
)

map('n', '<leader>tt',
  "<cmd>TermExec size=10 direction=horizontal cmd='just tdd'<cr>",
  { desc = "TDD" })

require("luasnip.loaders.from_vscode").lazy_load(
  { paths = { "./lua/vscode_snippets" } })
require("luasnip").filetype_extend("just", { "sh" })

