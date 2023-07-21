.PHONY: lint

lint:
	luacheck lua/lsp-debug-tools

stylua:
	stylua --color always .
