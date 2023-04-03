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
})

