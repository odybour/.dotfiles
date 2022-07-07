" Find files using Telescope command-line sugar.

nnoremap <leader>pf <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>ps <cmd>lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For > ")})<CR>
nnoremap <leader>pb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>vh <cmd>lua require('telescope.builtin').help_tags()<cr>
nnoremap <leader>pw <cmd>lua require('telescope.builtin').grep_string { search = vim.fn.expand("<cword>") }<CR>
nnoremap <C-p> <cmd>lua require('telescope.builtin').git_files()<CR>

