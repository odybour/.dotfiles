local lga_actions = require("telescope-live-grep-args.actions")
require('telescope').setup {
    defaults = {
        -- Default configuration for telescope goes here:
        -- config_key = value,
        mappings = {
            i = {
                -- map actions.which_key to <C-h> (default: <C-/>)
                -- actions.which_key shows the mappings for your picker,
                -- e.g. git_{create, delete, ...}_branch for the git_branches picker
                ["<C-h>"] = "which_key"
            }
        },
        layout_config = {
            vertical = { width = 0.9 }
        },
        path_display = {
            --shorten = {
            --len = 3, exclude = { 1, -1 }
            --},
            truncate = true
        },
        dynamic_preview_title = true,
    },
    pickers = {
        -- Default configuration for builtin pickers goes here:
        -- picker_name = {
        --   picker_config_key = value,
        --   ...
        -- }
        -- Now the picker_config_key will be applied every time you call this
        -- builtin picker
    },
    extensions = {
        -- Your extension configuration goes here:
        -- extension_name = {
        --   extension_config_key = value,
        -- }
        -- please take a look at the readme of the extension you want to configure
        fzf = {
            fuzzy = true,                   -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,    -- override the file sorter
            case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
        },
        live_grep_args = {
            auto_quoting = true, -- enable/disable auto-quoting
            -- define mappings, e.g.
            mappings = {
                -- extend mappings
                i = {
                    ["<C-[>"] = lga_actions.quote_prompt(),
                    ["<leader> tr"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
                },
            }
        }
    }
}
require('telescope').load_extension('fzf')
require("telescope").load_extension("live_grep_args")
require("telescope").load_extension("dap")
