
local dap = require("dap")

-- Mappings.
-- See :help dap.txt, :help dap-mapping and :help dap-api.
--
local opts = { noremap=true, silent=true }
--vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
--vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)

vim.keymap.set('n', '<leader>dr', function() dap.repl.toggle() end)
vim.keymap.set('n', '<F8>', function() dap.continue() end)
vim.keymap.set('n', '<F6>', function() dap.step_over() end)
vim.keymap.set('n', '<F5>', function() dap.step_into() end)
vim.keymap.set('n', '<leader>b', function() dap.toggle_breakpoint() end)
vim.keymap.set('n', '<leader>dl>', function() dap.run_last() end)
vim.keymap.set('n', '<leader>dc', function() dap.terminate() end)

vim.keymap.set("n", "<leader>dK", [[<cmd>lua require"dap.ui.widgets".hover()<CR>]])
vim.keymap.set("n", "<leader>dhh", [[<cmd>lua require"dap.ui.variables".hover()<CR>]])
vim.keymap.set("n", "<leader>dhv", [[<cmd>lua require"dap.ui.variables".visual_hover()<CR>]])

-- This is similar to the one on top. I am leaving it here for reference.
--vim.keymap.set("n", "<F8>", [[<cmd>lua require"dap".continue()<CR>]])
--
local dapui = require("dapui")
dap.listeners.after['event_initialized']['dapui_config'] = function()
  dapui.open()
end

--dap.listeners.before['event_terminated']['dapui_config'] = function()
  --dapui.close()
--end
--dap.listeners.before['event_exited']['dapui_config'] = function()
  --dapui.close()
--end
dapui.setup({})
