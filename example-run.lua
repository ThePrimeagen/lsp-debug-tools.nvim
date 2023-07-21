require("plenary.reload").reload_module("lsp-debug-tools")
require("plenary.reload").reload_module("lsp-debug-tools.window")
require("plenary.reload").reload_module("lsp-debug-tools.preview")
require("plenary.reload").reload_module("lsp-debug-tools.lsp-line")

local debug_tools = require("lsp-debug-tools")
local log_line = require("lsp-debug-tools.lsp-line").parse_log_line

debug_tools.start({
    window = {
        rows = 10,
    },
    filter = function(x)
        local line = log_line(x)
        print(
            line.type,
            line.server_name,
            line.type == "ServerEvent" and line.server_name == "testing-lsp"
        )
        return line.type == "ServerEvent"
            and line.server_name == '"testing-lsp"'
    end,
})
