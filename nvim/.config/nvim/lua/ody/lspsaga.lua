local saga = require("lspsaga")

saga.setup({
  ui = {
    -- This option only works in Neovim 0.9
    title = false,
    -- Border type can be single, double, rounded, solid, shadow.
    border = "single",
    winblend = 0,
    expand = "",
    collapse = "",
    code_action = "💡",
    incoming = " ",
    outgoing = " ",
    hover = ' ',
    kind = {},
  },
})
