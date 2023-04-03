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

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

require("symbols-outline").setup {
  auto_close = true,
}
