
require("plenary.reload").reload_module "lsp-debug-tools"
require("plenary.reload").reload_module "lsp-debug-tools.window"

local window = require("lsp-debug-tools.window")
local debug_tools = require("lsp-debug-tools")

debug_tools.start({
    rows = 10,
    width_ratio = 0.5,
})
