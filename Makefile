.PHONY: lint

lint:
	luacheck lua/lsp-debug-tools

stylua:
	stylua lua/lsp-debug-tools
