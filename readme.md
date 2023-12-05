## nerd-font installation

Get the nerd font hack from here: https://www.nerdfonts.com/font-downloads

wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/Hack.zip -O ~/Downloads

unzip ~/Downloads/Hack.zip -d ~/.local/share/fonts/hack/
fc-cache -vf
fc-match Hack -a | grep -i hack

logout

edit konsole profile settings and select hack nomo NF font (kati tetoio) - oxi to koino hack font.

# Neovim

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

### Logging
