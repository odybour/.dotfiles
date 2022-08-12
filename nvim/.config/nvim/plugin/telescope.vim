" Find files using Telescope command-line sugar.
nnoremap <C-p> <cmd>lua require('telescope.builtin').git_files({layout_strategy='vertical'})<CR>
nnoremap <C-h> <cmd>lua require('telescope.builtin').live_grep({layout_strategy='vertical'})<CR>
nnoremap <C-f> <cmd>lua require('telescope.builtin').find_files({layout_strategy='vertical'})<CR>

"nnoremap <leader>pf <cmd>lua require('telescope.builtin').find_files({layout_strategy='vertical'})<cr>
nnoremap <leader>ps <cmd>lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For > ")})<CR>
nnoremap <leader>pb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>vh <cmd>lua require('telescope.builtin').help_tags()<cr>
nnoremap <leader>pw <cmd>lua require('telescope.builtin').grep_string { search = vim.fn.expand("<cword>") }<CR>

