" Configuration Docs: https://github.com/nvim-telescope/telescope.nvim/blob/master/doc/telescope.txt

" Find files using Telescope command-line sugar.
nnoremap <C-p> <cmd>lua require('telescope.builtin').git_files({layout_strategy='vertical'})<CR>
nnoremap <C-h> <cmd>lua require('telescope.builtin').live_grep({layout_strategy='vertical'})<CR>
nnoremap <C-f> <cmd>lua require('telescope.builtin').find_files({layout_strategy='vertical'})<CR>
nnoremap <M-up> <cmd>lua require('telescope.builtin').buffers({layout_strategy='vertical'})<CR>

"nnoremap <leader>pf <cmd>lua require('telescope.builtin').find_files({layout_strategy='vertical'})<CR>
nnoremap <leader>ps <cmd>lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For > ")})<CR>
nnoremap <leader>vh <cmd>lua require('telescope.builtin').help_tags()<CR>
nnoremap <leader>pw <cmd>lua require('telescope.builtin').grep_string { search = vim.fn.expand("<cword>") }<CR>

nnoremap <leader>fm <cmd>lua require('telescope.builtin').marks({layout_strategy='vertical'})<CR>
nnoremap <C-M-h> <cmd>lua require('telescope.builtin').lsp_references({fname_width=100, layout_strategy='vertical'})<CR>
nnoremap <leader>fs <cmd>lua require('telescope.builtin').lsp_document_symbols({layout_strategy='vertical'})<CR>
nnoremap <leader>fc <cmd>lua require('telescope.builtin').lsp_incoming_calls({layout_strategy='vertical'})<CR>
nnoremap <leader>fo <cmd>lua require('telescope.builtin').lsp_outgoing_calls({layout_strategy='vertical'})<CR>
nnoremap <M-F3> <cmd>lua require('telescope.builtin').lsp_implementations({layout_strategy='vertical'})<CR>
nnoremap <leader>fx <cmd>lua require('telescope.builtin').diagnostics({layout_strategy='vertical', bufnr=0})<CR>
