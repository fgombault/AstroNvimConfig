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

vim.cmd([[set wrap]])

-- diff colors and presentation
vim.cmd([[hi DiffChange guibg=#8A4F00 guifg=#DDDDDD]])
vim.cmd([[hi DiffText guibg=#FF0000 guifg=FFFF00]])
vim.cmd([[hi DiffDelete guifg=#606050]])
vim.opt.diffopt = { "algorithm:minimal", "filler", "vertical",  "iwhite", "linematch:60", "context:99999" }
vim.opt.fillchars = "diff:╳"

-- requires toilet command
map("n", "<leader>z", "<cmd>s/^ *//<cr>" ..
  "<cmd>s/$/ /<cr>" ..
  "o<esc><up>" ..
  "<cmd>.!toilet -f pagga -w 77<cr>" ..
  "<down><down><down>",
  { desc = "Comment banner" })

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

