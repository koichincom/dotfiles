vim.loader.enable(true) -- Compile Lua to bytecode for faster startup

require("core.options")
require("core.lazy") -- After loading options
require("modules.colorscheme").init() -- After loading colorscheme plugins in lazy
require("modules.highlight.main").init() -- After loading colorscheme module

require("core.autocmds").init_general()
require("core.keymaps")
