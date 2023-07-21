require("plenary.reload").reload_module "lsp-debug-tools"
require("plenary.reload").reload_module "lsp-debug-tools.window"
require("plenary.reload").reload_module "lsp-debug-tools.preview"
require("plenary.reload").reload_module "lsp-debug-tools.lsp-line"

local window = require("lsp-debug-tools.window")
local debug_tools = require("lsp-debug-tools")
local Preview = require("lsp-debug-tools.preview")
local lsp_line = require("lsp-debug-tools.lsp-line").parse

debug_tools.start({
    window = {
        rows = 10,
    },
    filter = function(x)
        local line = lsp_line(x)
        print(line.type, line.server_name, line.type == "ServerEvent" and line.server_name == "testing-lsp")
        return line.type == "ServerEvent" and line.server_name == "\"testing-lsp\""
    end
})
