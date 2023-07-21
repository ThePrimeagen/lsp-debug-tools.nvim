.PHONY: lint stylua check

prepush: check lint stylua

check:
	./check

lint:
	luacheck lua/lsp-debug-tools

stylua:
	stylua --color always .
