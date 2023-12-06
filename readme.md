## nerd-font installation

Get the nerd font hack from here: https://www.nerdfonts.com/font-downloads

wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/Hack.zip -O ~/Downloads

unzip ~/Downloads/Hack.zip -d ~/.local/share/fonts/hack/
fc-cache -vf
fc-match Hack -a | grep -i hack

logout

edit konsole profile settings and select hack nomo NF font (kati tetoio) - oxi to koino hack font.

# Neovim

## Structure

We configure lazy.nvim to manage all plugins under the lua/plugins folder.

lazy.nvim makes it very easy and flexible to configure plugins. For our configuration:

* For common plugins (e.g., plenary.nvim, nui.nvim, nvim-web-devicons, dressing.nvim, etc), we use the plugins/init.lua file.
* For plugins that do not need many configurations (e.g., dial.nvim, numb.nvim, neogit, diffview.nvim, etc), we use the plugins/init.lua file.
* Plugins that require more configurations will have their own configuration files, e.g. WhichKey, Telescope, and Tree-sitter.
* For similar plugins that require more configurations, e.g. LSP, and color schemes, they will have their own folders.
## Plugin Mgmt

In file config/lazy.lua:

  vim.keymap.set("n", "<leader>zz", "<cmd>:Lazy<cr>", { desc = "Manage Plugins" })


## Autocommands

### Intro
Lua functions that are executed as a response to an event.

List of events:

:h events

To check current autocommand settings for an event: (e.g. BufEnter)

:au BufEnter

examples

        local group = vim.api.nvim_create_augroup("Smash", { clear = true })

vim.api.nvim_create_autocmd("BufEnter", { command = "echo 'Hello'", group = group })
local mystr = "Hello"
vim.api.nvim_create_autocmd("BufEnter", {
callback = function()
print(mystr .. ", we are in an autocmd now.")
end,
group = group,
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
callback = function(ev)
print(string.format("event fired: s", vim.inspect(ev)))
end,
})

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

I changed M.autoformat to false in beginning of file so that it does not set up the autocommand to executing formatting on every buffer write.

### Treesitter

Treesitter provides many features, such as highlighting, indentation, folding, etc. They are called modules

* https://github.com/nvim-treesitter/nvim-treesitter#moduleshttps

execute this to get information:

:TSModuleInfo
#### Changes

Removed this line of code    (from file treesitter/init.lua )   

  context_commentstring = { enable = true, enable_autocmd = false },

since I was getting errors. This is no longer required in newer versions of treesitter.


#### Comments

Treesitter can be used to add comments to any file.
Actually for this purpose https://github.com/numToStr/Comment.nvim
is being used.

in `plugins/init.lua`
I changed the key mappings so the ctrl+/ is used to do line comments. 

Notes on keymappings:

The default key mapping for comment toggling was gcc. I got this by executing
:map 

It showed the comment.nvim plugin is used for this key mapping. Then I went to https://github.com/numToStr/Comment.nvim

and found out the settings to use to change the key mapping. just configure these in opts, and will be passed to the startup function of the module.
: 

### nvim-tree

migration guide (this is how I found out that all g:... variables are now provided as setup options - because in internet I was reading configuration that I could not find in docs..)

  https://github.com/nvim-tree/nvim-tree.lua/issues/674

and the docs:

  https://github.com/nvim-tree/nvim-tree.lua/blob/master/doc/nvim-tree-lua.txt

execute this for keymappings

: g?

nvim-tree mappings                exit: q
                   sort by description: s
 <2-LeftMouse>  Open                     
 <2-RightMouse> CD                       
 <C-]>          CD                       
 <C-E>          Open: In Place           
 <C-K>          Info                     
 <C-R>          Rename: Omit Filename    
 <C-T>          Open: New Tab            
 <C-V>          Open: Vertical Split     
 <C-X>          Open: Horizontal Split   
 <BS>           Close Directory          
 <CR>           Open                     
 <Tab>          Open Preview             
 -              Up                       
 .              Run Command              
 >              Next Sibling             
 <              Previous Sibling         
 B              Toggle Filter: No Buffer 
 C              Toggle Filter: Git Clean 
 D              Trash                    
 E              Expand All               
 F              Clean Filter             
 H              Toggle Filter: Dotfiles  
 I              Toggle Filter: Git Ignore
 J              Last Sibling             
 K              First Sibling            
 O              Open: No Window Picker   
 P              Parent Directory         
 R              Refresh                  
 S              Search                   
 U              Toggle Filter: Hidden    
 W              Collapse                 
 Y              Copy Relative Path       
 a              Create File Or Directory 
 bd             Delete Bookmarked        
 bmv            Move Bookmarked          
 bt             Trash Bookmarked         
 ]c             Next Git                 
 [c             Prev Git                 
 c              Copy                     
 d              Delete                   
 e              Rename: Basename         
 [e             Prev Diagnostic          
 ]e             Next Diagnostic          
 f              Filter                   
 g?             Help                     
 gy             Copy Absolute Path       
 m              Toggle Bookmark          
 o              Open                     
 p              Paste                    
 q              Close                    
 r              Rename                   
 s              Run System               
 u              Rename: Full Path        
 x              Cut                      
 y              Copy Name                

### ColorSchemes

Plugins configured in file `lua/plugins/colorscheme/init.lua`

You can enable the plugins by setting 
lazy = false (so that it is not lazy loaded - when referenced by a required, but at startup)
enabled = true (to enable this)

I decided to use 
https://github.com/sainnhe/gruvbox-material/blob/master/README.module

with mix (or original) color paletter as defined in the docs.

The docs:

https://github.com/sainnhe/gruvbox-material/blob/master/doc/gruvbox-material.txt

say you have to configure the palette using a global parameter. I added this in `config/options.lua`.

### Logging

