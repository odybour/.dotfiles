# Nerd-Font Installation

To use the Nerd Font "Hack," follow these steps:

## Download Nerd Font Hack

Get the Nerd Font Hack from [here](https://www.nerdfonts.com/font-downloads).

    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/Hack.zip -O ~/Downloads

    unzip ~/Downloads/Hack.zip -d ~/.local/share/fonts/hack/
    fc-cache -vf
    fc-match Hack -a | grep -i hack

> Logout

Edit Konsole profile settings and select "hack nomo NF font" (κάτι τέτοιο) - not the common Hack font.

# Neovim Configuration

## Structure - Plugins

Configure `lazy.nvim` to manage all plugins under the `lua/plugins` folder.

`lazy.nvim` makes it very easy and flexible to configure plugins. For our configuration:

- For common plugins (e.g., plenary.nvim, nui.nvim, nvim-web-devicons, dressing.nvim, etc), we use the plugins/init.lua file.
- For plugins that do not need many configurations (e.g., dial.nvim, numb.nvim, neogit, diffview.nvim, etc), we use the plugins/init.lua file.
- Plugins that require more configurations will have their own configuration files, e.g. WhichKey, Telescope, and Tree-sitter.
- For similar plugins that require more configurations, e.g. LSP, and color schemes, they will have their own folders.

Every `*.lua` file in `lua/plugins/` is automatically sourced!
Actually it appears that everything is sourced, all `init.lua` files even if they are contained in separate folders. that's lazy :-)

There is a plugin management section here: <https://alpha2phi.medium.com/modern-neovim-init-lua-ab1220e3ecc1>

### Plugin Management

In file `config/lazy.lua`:

    vim.keymap.set("n", "<leader>zz", "<cmd>:Lazy<cr>", { desc = "Manage Plugins" })

## Autocommands

### Intro

Lua functions that are executed as a response to an event.

List of events:

    :h events

To check current autocommand settings for an event (e.g. BufEnter):

    :au BufEnter

Examples:

    local group = vim.api.nvim_create_augroup("Smash", { clear = true })

    vim.api.nvim_create_autocmd("BufEnter", { command = "echo 'Hello'", group = group })
    local mystr = "Hello"
    vim.api.nvim_create_autocmd("BufEnter", {
        callback = function()
            print

###

I have created autocommands for processing VimEnter event and 
1. opening nvim tree
2. add folding arrows (using ufo module)

### Auto-format

In `plugins/lsp/format.lua`, there is this autocmd:

    vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("LspFormat." .. bufnr, {}),
    buffer = bufnr,
    callback = function()
    if M.autoformat then
    M.format()
    end
    end,
    })

I changed M.autoformat to false in the beginning of the file so that it does not set up the autocommand to execute formatting on every buffer write.

### Treesitter

Treesitter provides many features, such as highlighting, indentation, folding, etc. They are called modules

- [https://github.com/nvim-treesitter/nvim-treesitter#modules](https://github.com/nvim-treesitter/nvim-treesitter#modules)

execute this to get information:

    :TSModuleInfo

#### Changes

Removed this line of code (from file treesitter/init.lua )

    context_commentstring = { enable = true, enable_autocmd = false },

since I was getting errors. This is no longer required in newer versions of treesitter.

#### Comments

Treesitter can be used to add comments to any file.
Actually, for this purpose [https://github.com/numToStr/Comment.nvim](https://github.com/numToStr/Comment.nvim)
is being used.

in `plugins/init.lua`
I changed the key mappings so ctrl+/ is used to do line comments.

Notes on keymappings:

The default key mapping for comment toggling was gcc. I got this by executing
:map

It showed the comment.nvim plugin is used for this key mapping. Then I went to [https://github.com/numToStr/Comment.nvim](https://github.com/numToStr/Comment.nvim)

and found out the settings to use to change the key mapping. just configure these in opts, and will be passed to the startup function of the module.

### nvim-tree

migration guide (this is how I found out that all g:... variables are now provided as setup options - because on the internet I was reading configuration that I could not find in docs..)

[https://github.com/nvim-tree/nvim-tree.lua/issues/674](https://github.com/nvim-tree/nvim-tree.lua/issues/674)

and the docs:

[https://github.com/nvim-tree/nvim-tree.lua/blob/master/doc/nvim-tree-lua.txt](https://github.com/nvim-tree/nvim-tree.lua/blob/master/doc/nvim-tree-lua.txt)

execute this for keymappings

    : g?

nvim-tree mappings exit: q
sort by description: s
<2-LeftMouse> Open  
 <2-RightMouse> CD  
 <C-]> CD  
 <C-E> Open: In Place  
 <C-K> Info  
 <C-R> Rename: Omit Filename  
 <C-T> Open: New Tab  
 <C-V> Open: Vertical Split  
 <C-X> Open: Horizontal Split  
 <BS> Close Directory  
 <CR> Open  
 <Tab> Open Preview

-              Up
  . Run Command
  >              Next Sibling
  >
  > < Previous Sibling  
  > B Toggle Filter: No Buffer
  > C Toggle Filter: Git Clean
  > D Trash  
  > E Expand All  
  > F Clean Filter  
  > H Toggle Filter: Dotfiles  
  > I Toggle Filter: Git Ignore
  > J Last Sibling  
  > K First Sibling  
  > O Open: No Window Picker  
  > P Parent Directory  
  > R Refresh  
  > S Search  
  > U Toggle Filter: Hidden  
  > W Collapse  
  > Y Copy Relative Path  
  > a Create File Or Directory
  > bd Delete Bookmarked  
  > bmv Move Bookmarked  
  > bt Trash Bookmarked  
  > ]c Next Git  
  > [c Prev Git  
  > c Copy  
  > d Delete  
  > e Rename: Basename  
  > [e Prev Diagnostic
  >
  > > ]e Next Diagnostic  
  > > f Filter  
  > > g? Help  
  > > gy Copy Absolute Path  
  > > m Toggle Bookmark  
  > > o Open  
  > > p Paste  
  > > q Close  
  > > r Rename  
  > > s Run System  
  > > u Rename: Full Path  
  > > x Cut  
  > > y Copy Name

### ColorSchemes

Plugins configured in file `lua/plugins/colorscheme/init.lua`

You can enable the plugins by setting
`lazy = false` (so that it is not lazy-loaded - when referenced by a required, but at startup)
`enabled = true` (to enable this)

I decided to use <https://github.com/sainnhe/gruvbox-material/blob/master/README.module>

### Logging

### LSP

In the configuration of lazy vim (`lazy.lua`), we import all plugin specs contained in folders `plugins` and `pde`. The `pde` folder contains many LSP configurations for different languages. They will be fetched by using the `config.pde` Lua table, contained in the `config/init.lua` file. Check this:

    if not require("config").pde.docker then
    	return {}
    end

    return {
    	{
    		-- load docker lsp settings
    		-- actually, this contains docker specific configurations for many plugins. somehow they are all merged together
    	}
    }

If you execute `:LspInfo`, you see the installed language servers. These come from servers defined in the `pde` plugin folder, as well as in `lsp.opts.servers` (`plugins/lsp/init.lua` file).

I added `bashls` in `lsp/init.lua`, `opt.servers` and it appears to work. Don't swear.

### init.lua

Used by neovim, as opposed to `init.vim`.

A folder containing an `init.lua` file can be required directly, without having to specify the name of the file.

    require('other_modules') -- loads other_modules/init.lua

### lazy.lua

The `require("lazy").setup` is where the magic happens. This starts up lazy nvim.

Now, the `setup()` function can be either:

    require("lazy").setup(plugins, opts)

or

    require("lazy").setup opts

We use the second version, where the plugin specs (see [lazy.nvim](https://github.com/folke/lazy.nvim#-plugin-spec)) are passed to lazy vim via the `config.spec` parameter, which is actually a Lua table.

The doc says that the default is:

    -- leave nil when passing the spec as the first argument to setup()
    spec = nil, ---@type LazySpec

But we instead use:

    spec = {
    	{ import = "plugins" },
    	{ import = "plugins.ui" },
    	{ import = "plugins.notes" },
    	{ import = "plugins.ai" },
    	{ import = "pde" },
    },

Check: [lazy.nvim Configuration](https://github.com/folke/lazy.nvim#%EF%B8%8F-configuration)

### Lua Tables

#### Example 1: Creating and Accessing Tables

    -- Creating a simple table
    local fruits = {"Apple", "Banana", "Orange"}

    -- Accessing elements in the table
    print(fruits[1]) -- Output: Apple
    print(fruits[2]) -- Output: Banana
    print(fruits[3]) -- Output: Orange

    -- Adding a new element
    fruits[4] = "Grapes"

    -- Iterating through the table
    for i, fruit in ipairs(fruits) do
    print(i, fruit)
    end

#### Example 2: Table with Mixed Types

    -- Creating a table with mixed types
    local person = {
    name = "John",
    age = 30,
    isStudent = true,
    grades = {90, 85, 92},
    }

    -- Accessing elements
    print(person.name) -- Output: John
    print(person.age) -- Output: 30
    print(person.isStudent) -- Output: true
    print(person.grades[1]) -- Output: 90

    -- Modifying a value
    person.age = 31

    -- Adding a new key-value pair
    person.gender = "Male"

#### Example 3: Table as a Dictionary

    -- Creating a table as a dictionary
    local car = {
    model = "Toyota",
    year = 2020,
    color = "Blue",
    }

    -- Accessing elements
    print(car.model) -- Output: Toyota
    print(car.year) -- Output: 2020
    print(car.color) -- Output: Blue

    -- Modifying a value
    car.year = 2022

    -- Removing a key-value pair
    car.color = nil

#### Example 4: Nested Tables

    -- Creating nested tables
    local matrix = {
    {1, 2, 3},
    {4, 5, 6},
    {7, 8, 9},
    }

    -- Accessing elements in a nested table
    print(matrix[2][3]) -- Output: 6

    -- Modifying a value
    matrix[1][1] = 0

These examples demonstrate some of the basic ways Lua tables can be used, including simple arrays, dictionaries, mixed-type tables, and nested tables. Lua tables are quite flexible and can be adapted to various data structures and use cases.

### Completion

This is achieved using the following two plugins:

* "hrsh7th/nvim-cmp",
* "L3MON4D3/LuaSnip",

These include a `config` function. According to the plugin spec this is executed when the plugin loads and if not specified, it defaults to `require("plugin_name").setup()`.

usually, each plugin has an 
* opts function (that retrieves a table with all options when evaluated.)
* a config function that gets the opts as input.

