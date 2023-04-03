require('ody.lsp')
--require('ody.metals')
require('ody.telescope')
-- FIXME - this does not work well.
--require('ody.lspsaga') 
require('ody.dap')
require('ody.cmp')
require('ody.bash')
require('ody.log')
require('ody.treesitter')

-- disable netrw at the very start of your init.lua (strongly advised) - required by nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- not sure is this is now used since I disabled netrw
vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

require("symbols-outline").setup {
  auto_close = true,
}

require('ody.nvim-tree')
