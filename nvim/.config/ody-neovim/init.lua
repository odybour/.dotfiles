if vim.g.vscode then
  -- VS Code only mappings
  vim.keymap.set("n", "gi", function()
    vim.fn.VSCodeNotify("editor.action.goToImplementation")
  end)
  vim.keymap.set("n", "gr", function()
    vim.fn.VSCodeNotify("editor.action.goToReferences")
  end)
  -- https://github.com/vscode-neovim/vscode-neovim/issues/298
  vim.opt.clipboard:append("unnamedplus")
else
  -- bootstrap lazy.nvim, LazyVim and your plugins
  require("config.lazy")
end
