-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- For plugins:
-- http://www.lazyvim.org/configuration/plugins#%EF%B8%8F-adding--disabling-plugin-keymaps
-- Add any additional keymaps here
--
vim.keymap.del("n", "<leader>cf")
vim.keymap.set({"n", "x"}, "<leader>lf", function()
    LazyVim.format({
        force = true
    })
end, {
    desc = "Format"
})

vim.keymap.del("n", "<leader>l")
vim.keymap.set("n", "<leader>z", "<cmd>Lazy<cr>", {
    desc = "Lazy"
})

vim.keymap.set("n", "<M-w>k", "<C-w><Up>")
vim.keymap.set("n", "<M-w>h", "<C-w><Left>")
vim.keymap.set("n", "<M-w>j", "<C-w><Down>")
vim.keymap.set("n", "<M-w>l", "<C-w><Right>")
vim.keymap.set("n", "J", "<cmd>:res +5<CR>")
vim.keymap.set("n", "K", "<cmd>:res -5<CR>")
vim.keymap.set("n", "L", "<cmd>:vertical resize +5<CR>")
vim.keymap.set("n", "H", "<cmd>:vertical resize -5<CR>")
-- vim.keymap.set("n", "_", "<C-w>K")
-- vim.keymap.set("n", "+", "<C-w>J")
