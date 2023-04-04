-- Command Reference
-- https://user-images.githubusercontent.com/17254073/195207023-7b709e35-7f10-416b-aafb-5bb61268c7d3.png
--
require("nvim-tree").setup({
    sort_by = "case_sensitive",
    renderer = {
        group_empty = true,
    },
    filters = {
        dotfiles = false,
    },
    on_attach = function()
        local api = require('nvim-tree.api')
        local function opts(desc)
            return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end
        vim.keymap.set('n', '<LeftRelease>', api.node.open.edit, opts("Open"))
    end
})
