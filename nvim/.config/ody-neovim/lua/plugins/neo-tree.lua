-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins
-- remember, the default plugins are in this repo
-- also, remember, it's :LazyExtras to install extra plugins
return { -- file explorer
{
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    keys = { -- remap show file keymap
    {"<leader>fe", false}, {
        "<C-n>",
        function()
            require("neo-tree.command").execute({
                toggle = true,
                dir = LazyVim.root()
            })
        end,
        desc = "Explorer NeoTree (Root Dir)"
    }}
}, {
    "okuuva/auto-save.nvim",
    version = '^1.0.0', -- see https://devhints.io/semver, alternatively use '*' to use the latest tagged release
    cmd = "ASToggle", -- optional for lazy loading on command
    event = {"InsertLeave", "TextChanged"}, -- optional for lazy loading on trigger events
    keys = {{
        "<leader>0",
        "<cmd>ASToggle<CR>",
        desc = "Toggle auto-save"
    }},
    opts = {
        -- your config goes here
        -- or just leave it empty :)
    }
}}
