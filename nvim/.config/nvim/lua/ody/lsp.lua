-- This is returned in the end so that callers can invoke methods of this file. (public API)
local M = {}

local log = require("ody.log")


-- vim.keymap.set("n", "<leader>go", require("lspsaga.diagnostic").show_line_diagnostics, opts)
-- vim.keymap.set("n", "gj", require("lspsaga.diagnostic").goto_prev, opts)
-- vim.keymap.set("n", "gk", require("lspsaga.diagnostic").goto_next, opts)

--local lsp_flags = {
---- This is the default in Nvim 0.7+
--debounce_text_changes = 150,
--}

--To learn what capabilities are available you can run the following command in
--a buffer with a started [LSP](https://neovim.io/doc/user/lsp.html#LSP) client:

--:lua =vim.lsp.get_active_clients()[1].server_capabilities
--:lua require("ody.log").info(vim.lsp.get_active_clients()[1].server_capabilities)
--:lua require("ody.log").info(vim.lsp.buf)
--
-- array of mappings to setup; {<capability_name>, <mode>, <lhs>, <rhs>}
local key_mappings = {
    -- note: the <Cmd> is used because it is the only way I know to pass arguments to the function like the {async=true}
    { "documentFormattingProvider",      "n", "<leader>f",  "<Cmd>lua vim.lsp.buf.format({async=true})<CR>" },
    { "documentRangeFormattingProvider", "v", "<leader>f",  vim.lsp.buf.range_formatting },
    --{"referencesProvider", "n", "<C-M-h>", vim.lsp.buf.references},
    { "hoverProvider",                   "n", "K",          vim.lsp.buf.hover },
    --{"implementationProvider", "n", "<C-j>",  vim.lsp.buf.implementation},
    { "signatureHelpProvider",           "i", "<c-space>",  vim.lsp.buf.signature_help },
    { "workspaceSymbolProvider",         "n", "gW",         vim.lsp.buf.workspace_symbol },
    { "definitionProvider",              "n", "<F3>",       vim.lsp.buf.definition },
    { "renameProvider",                  "n", "<leader>rn", vim.lsp.buf.rename },

    --{"typeDefinitionProvider", "n", "<F3>", vim.lsp.buf.type_definition}, -- similar to the above.

    --{"codeActionProvider", "n", "<leader>r", vim.lsp.buf.code_action { only = 'refactor' }<CR>"},
    --{"codeActionProvider", "v", "<a-CR>", "<Esc><Cmd>lua vim.lsp.buf.range_code_action()<CR>"},
    --{"codeActionProvider", "v", "<leader>r", "<Esc><Cmd>lua vim.lsp.buf.range_code_action { only = 'refactor'}<CR>"},
}

-- Use an on_attach function to only map a specific set of keys, according to client given.
-- This should be used AFTER the language server attaches to the current buffer
--
-- See `:help vim.lsp.*` for documentation on any of the below functions
--
local function on_attach(client, bufnr, attach_opts)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    log.info('Client ' .. client.name .. ' capabilities = ' .. vim.json.encode(client.server_capabilities))

    local opts = { silent = true, buffer = bufnr }
    --TODO - there is a bug here:
    --for _, mappings in pairs(key_mappings) do
        --local capability, mode, lhs, rhs = unpack(mappings)
        --if client.server_capabilities[capability] then
            --log.info('Configuring capability for client ' .. client.name .. ': ' .. capability)
            --vim.keymap.set(mode, lhs, rhs, opts)
        --end
    --end

    if vim.lsp.codelens and client.server_capabilities['codeLensProvider'] then
        log.info('Configuring capability for client ' .. client.name .. ': codeLensProvider')
        vim.keymap.set('n', '<leader>cl', vim.lsp.codelens.run, opts)
        --api.nvim_buf_set_keymap(bufnr, "n", "<leader>cr", "<Cmd>lua vim.lsp.codelens.refresh()<CR>", opts)
    end

    if client.server_capabilities['codeActionProvider'] then
        log.info('Configuring capability for client ' .. client.name .. ': codeActionProvider')
        vim.keymap.set("n", "<M-enter>", vim.lsp.buf.code_action, opts)
        vim.keymap.set("v", "<M-enter>", "<Cmd>lua vim.lsp.buf.code_action()<CR>", opts)
        -- the lspsaga does not appear to work well.
        --local saga = require("ody.lspsaga")
        --vim.keymap.set("v", "<M-enter>", saga.code_action)
        --vim.keymap.set("n", "<M-enter>", saga.code_action)
    end

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    --local bufopts = { noremap=true, silent=true, buffer=bufnr }
    --vim.keymap.set('n', '<leader>m', vim.lsp.buf.declaration, bufopts)
    --vim.keymap.set('n', '<F3>', vim.lsp.buf.definition, bufopts)
    --vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    --vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    --vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    --vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    --vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    --vim.keymap.set('n', '<space>wl', function()
    --print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    --end, bufopts)
    --vim.keymap.set('n', '<leader>m', vim.lsp.buf.type_definition, bufopts)
    --vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    --vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
    --vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    --vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
end


-- LSP mappings
--local bufopts = { noremap=true, silent=true }
---- vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)  -- this is not supported by metals
--vim.keymap.set('n', '<F3>', vim.lsp.buf.definition, bufopts)
--vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
--vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
--vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
--vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
--vim.keymap.set('n', '<leader>rn', require("lspsaga.rename").lsp_rename, bufopts)
--vim.keymap.set('n', '<leader>f', vim.lsp.buf.formatting, bufopts) -- OK

---- code action
--local action = require("lspsaga.codeaction")
--vim.keymap.set("n", "<M-enter>", action.code_action, { silent = true })
--vim.keymap.set("v", "<M-enter>", function()
--vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-U>", true, false, true))
--action.range_code_action()
--end, bufopts)

--map("n", "<leader>ws", '<cmd>lua require"metals".hover_worksheet()<CR>')

--vim.keymap.set('n', '<leader>aa', vim.diagnostic.setqflist, bufopts) -- all workspace diagnostics
--map("n", "<leader>e", [[<cmd>lua vim.diagnostic.setqflist({severity = "E"})<CR>]]) -- all workspace errors
--map("n", "<leader>w", [[<cmd>lua vim.diagnostic.setqflist({severity = "W"})<CR>]]) -- all workspace warnings

--vim.keymap.set('n', 'gds', vim.lsp.buf.document_symbol, bufopts)
--vim.keymap.set('n', 'gws', vim.lsp.buf.workspace_symbol, bufopts)
--vim.keymap.set('n', '<leader>cl', vim.lsp.codelens.run, bufopts)

--vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
--vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
--vim.keymap.set('n', '<leader>wl', function()
--print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
--end, bufopts)

--map("n", "<leader>l", '<cmd>lua require"metals".toggle_logs("sp")<CR>')
--map("n", "<leader>o", '<cmd>lua require"metals".organize_imports()<CR>')


--local function on_attach(client, bufnr, attach_opts)
--require('lsp_compl').attach(client, bufnr, attach_opts)
--api.nvim_buf_set_var(bufnr, "lsp_client_id", client.id)
--api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
--api.nvim_buf_set_option(bufnr, "bufhidden", "hide")

--if client.resolved_capabilities.goto_definition then
--api.nvim_buf_set_option(bufnr, 'tagfunc', "v:lua.vim.lsp.tagfunc")
--end
--local opts = { silent = true; }
--for _, mappings in pairs(key_mappings) do
--local capability, mode, lhs, rhs = unpack(mappings)
--if client.resolved_capabilities[capability] then
--api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
--end
--end
--api.nvim_buf_set_keymap(bufnr, "n", "crr", "<Cmd>lua vim.lsp.buf.rename(vim.fn.input('New Name: '))<CR>", opts)
--api.nvim_buf_set_keymap(bufnr, "i", "<c-n>", "<Cmd>lua require('lsp_compl').trigger_completion()<CR>", opts)
--vim.cmd('augroup lsp_aucmds')
--vim.cmd(string.format('au! * <buffer=%d>', bufnr))
--if client.resolved_capabilities['document_highlight'] then
--vim.cmd(string.format('au CursorHold  <buffer=%d> lua vim.lsp.buf.document_highlight()', bufnr))
--vim.cmd(string.format('au CursorHoldI <buffer=%d> lua vim.lsp.buf.document_highlight()', bufnr))
--vim.cmd(string.format('au CursorMoved <buffer=%d> lua vim.lsp.buf.clear_references()', bufnr))
--end
--if vim.lsp.codelens and client.resolved_capabilities['code_lens'] then
--api.nvim_buf_set_keymap(bufnr, "n", "<leader>cr", "<Cmd>lua vim.lsp.codelens.refresh()<CR>", opts)
--api.nvim_buf_set_keymap(bufnr, "n", "<leader>ce", "<Cmd>lua vim.lsp.codelens.run()<CR>", opts)
--end
--vim.cmd('augroup end')
--end
--
M.on_attach = on_attach

local servers = { 'tsserver', 'pyright', 'dockerls', 'lemminx', 'jsonls', 'eslint', 'html', 'perlls',
    'robotframework_ls', 'sqlls', 'lua_ls' }

-- makes sure the language servers configured later with lspconfig are
-- actually available, and install them automatically if they're not
-- !! THIS MUST BE CALLED BEFORE ANY LANGUAGE SERVER CONFIGURATION
require("mason").setup()
require("mason-lspconfig").setup {
    -- automatically install language servers setup below for lspconfig - uncomment to use
    --ensure_installed = servers
    automatic_installation = false
}

local lspConfig = require('lspconfig')

-- a quick way to setup multiple servers. don't use this if you want to provide specific settings
for _, server in ipairs(servers) do
    lspConfig[server].setup {}
end


-- https://neovim.io/doc/user/lsp.html
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)


-- https://github.com/neovim/nvim-lspconfig
-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        on_attach(client, args.buf, {})
    end,
})

return M
