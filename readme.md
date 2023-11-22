## nerd-font installation

Get the nerd font hack from here: https://www.nerdfonts.com/font-downloads

wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/Hack.zip -O ~/Downloads

unzip ~/Downloads/Hack.zip -d ~/.local/share/fonts/hack/
fc-cache -vf
fc-match Hack -a | grep -i hack

logout

edit konsole profile settings and select hack nomo NF font (kati tetoio) - oxi to koino hack font.

### Neovim

#### Autocommands

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

- Auto-format

in format.lua, there is this autocmd:

vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("LspFormat." .. bufnr, {}),
  buffer = bufnr,
  callback = function()
if M.autoformat then
M.format()
end
end,
})
