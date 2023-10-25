" Configuration Docs: https://github.com/nvim-telescope/telescope.nvim/blob/master/doc/telescope.txt

" Find files using Telescope command-line sugar.
nnoremap <C-p> <cmd>lua require('telescope.builtin').git_files({layout_strategy='vertical'})<CR>
nnoremap <C-f> <cmd>lua require('telescope.builtin').find_files({layout_strategy='vertical'})<CR>
nnoremap <M-up> <cmd>lua require('telescope.builtin').buffers({layout_strategy='vertical'})<CR>

"nnoremap <leader>pf <cmd>lua require('telescope.builtin').find_files({layout_strategy='vertical'})<CR>
nnoremap <leader>ps <cmd>lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For > ")})<CR>
nnoremap <leader>vh <cmd>lua require('telescope.builtin').help_tags()<CR>
nnoremap <leader>pw <cmd>lua require('telescope.builtin').grep_string { search = vim.fn.expand("<cword>") }<CR>

nnoremap <leader>fm <cmd>lua require('telescope.builtin').marks({layout_strategy='vertical'})<CR>
nnoremap <leader>fr <cmd>lua require('telescope.builtin').lsp_references({fname_width=100, layout_strategy='vertical'})<CR>
nnoremap <leader>fs <cmd>lua require('telescope.builtin').lsp_document_symbols({layout_strategy='vertical'})<CR>
nnoremap <leader>fu <cmd>lua require('telescope.builtin').lsp_incoming_calls({layout_strategy='vertical'})<CR>
nnoremap <leader>fo <cmd>lua require('telescope.builtin').lsp_outgoing_calls({layout_strategy='vertical'})<CR>
nnoremap <leader>fi <cmd>lua require('telescope.builtin').lsp_implementations({layout_strategy='vertical'})<CR>
nnoremap <leader>fx <cmd>lua require('telescope.builtin').diagnostics({layout_strategy='vertical', bufnr=0})<CR>

" Live Grep is replaced with Live Grep Args. 
" Usage: 
" > "search_string" -t xml (to search in XML files)
" > "search_string" -g folder/** (to search in some folder) 
" TODO: find a faster way - this is so verbose
"
"nnoremap <C-h> <cmd>lua require('telescope.builtin').live_grep({layout_strategy='vertical'})<CR>
nnoremap <C-h> <cmd>lua require('telescope').extensions.live_grep_args.live_grep_args({layout_strategy='vertical'})<CR>

