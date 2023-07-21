.PHONY: lint stylua

lint:
	luacheck lua/lsp-debug-tools

stylua:
	stylua --color always .
