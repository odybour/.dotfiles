require('dap.ext.vscode').load_launchjs()
local dap = require("dap")

-- Mappings.
-- See :help dap.txt, :help dap-mapping and :help dap-api.
--
local opts = { noremap = true, silent = true }
--vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
--vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)

vim.keymap.set('n', '<leader>dr', function() dap.repl.toggle() end)
vim.keymap.set('n', '<F8>', function() dap.continue() end)
vim.keymap.set('n', '<F6>', function() dap.step_over() end)
vim.keymap.set('n', '<F5>', function() dap.step_into() end)
vim.keymap.set('n', '<leader>b', function() dap.toggle_breakpoint() end)
vim.keymap.set('n', '<leader>v', function() dap.clear_breakpoints() end)
vim.keymap.set('n', '<leader>dl>', function() dap.run_last() end)
vim.keymap.set('n', '<leader>dc', function() dap.terminate() end)

vim.keymap.set("n", "<leader>dK", [[<cmd>lua require"dap.ui.widgets".hover()<CR>]])
vim.keymap.set("n", "<leader>dhh", [[<cmd>lua require"dap.ui.variables".hover()<CR>]])
vim.keymap.set("n", "<leader>dhv", [[<cmd>lua require"dap.ui.variables".visual_hover()<CR>]])


--local utils = require('utils')

--utils.map('n', '<leader>dct', '<cmd>lua require"dap".continue()<CR>')
--utils.map('n', '<leader>dsv', '<cmd>lua require"dap".step_over()<CR>')
--utils.map('n', '<leader>dsi', '<cmd>lua require"dap".step_into()<CR>')
--utils.map('n', '<leader>dso', '<cmd>lua require"dap".step_out()<CR>')
--utils.map('n', '<leader>dtb', '<cmd>lua require"dap".toggle_breakpoint()<CR>')

--utils.map('n', '<leader>dsc', '<cmd>lua require"dap.ui.variables".scopes()<CR>')
--utils.map('n', '<leader>dhh', '<cmd>lua require"dap.ui.variables".hover()<CR>')
--utils.map('v', '<leader>dhv', '<cmd>lua require"dap.ui.variables".visual_hover()<CR>')

--utils.map('n', '<leader>duh', '<cmd>lua require"dap.ui.widgets".hover()<CR>')
--utils.map('n', '<leader>duf', "<cmd>lua local widgets=require'dap.ui.widgets';widgets.centered_float(widgets.scopes)<CR>")

--utils.map('n', '<leader>dsbr', '<cmd>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>')
--utils.map('n', '<leader>dsbm', '<cmd>lua require"dap".set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<CR>')
--utils.map('n', '<leader>dro', '<cmd>lua require"dap".repl.open()<CR>')
--utils.map('n', '<leader>drl', '<cmd>lua require"dap".repl.run_last()<CR>')


--nnoremap <leader>fs <cmd>lua require('telescope.builtin').lsp_document_symbols({layout_strategy='vertical'})<CR>
-- telescope-dap
vim.keymap.set('n', '<leader>dcc', '<cmd>lua require"telescope".extensions.dap.commands{}<CR>')
vim.keymap.set('n', '<leader>dco', '<cmd>lua require"telescope".extensions.dap.configurations{}<CR>')
vim.keymap.set('n', '<leader>dlb', '<cmd>lua require"telescope".extensions.dap.list_breakpoints({fname_width=100, layout_strategy="vertical"})<CR>')
vim.keymap.set('n', '<leader>dv', '<cmd>lua require"telescope".extensions.dap.variables{}<CR>')
vim.keymap.set('n', '<leader>dff', '<cmd>lua require"telescope".extensions.dap.frames{}<CR>')


--vnoremap <M-k> <Cmd>lua require("dapui").eval()<CR>

-- This is similar to the one on top. I am leaving it here for reference.
--vim.keymap.set("n", "<F8>", [[<cmd>lua require"dap".continue()<CR>]])
--
local dapui = require("dapui")
dapui.setup({
    layouts = {
        {
            elements = {
                -- Elements can be strings or table with id and size keys.
                { id = "breakpoints", size = 0.20 },
                { id = "stacks",      size = 0.30 },
                { id = "watches",     size = 0.20 },
                { id = "scopes",      size = 0.30 },
            },
            size = 30, -- 40 columns
            position = "left",
        },
        {
            elements = {
                "console",
                "repl"
            },
            size = 0.25, -- 25% of total lines
            position = "bottom",
        },
    }
})
vim.keymap.set('n', '<M-k>', function() dapui.eval() end)
vim.keymap.set('n', '<leader>oi', function() dapui.close() end)
vim.keymap.set('n', '<leader>d', function() dapui.toggle() end)

dap.listeners.after['event_initialized']['dapui_config'] = function()
    --dap.repl.open()
    dapui.open()
end
dap.listeners.before['event_terminated']['dapui_config'] = function()
    dapui.close()
    --require("metals").restart_build()
end
dap.listeners.before['event_exited']['dapui_config'] = function()
    dapui.close()
    --require("metals").restart_build()
end

--function attach_to_debug()
--dap.configurations.java = {
--{
--type = 'java',
--request = 'attach',
--name = 'Attach to process',
--hostName = 'localhost',
--port = '5005',
--}
--}
--end
--vim.keymap.set('n', '<leader>da', attach_to_debug)
--dap.configurations.java = {
--{
--type = 'java';
--request = 'attach';
--name = "Debug (Attach) - Remote";
--hostName = "127.0.0.1";
--port = 30001;
--},
--}
