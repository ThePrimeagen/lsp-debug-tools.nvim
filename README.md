## lsp debug utils

Simple tailing
```
dune exec lsp_debug_tools -- ~/.local/state/nvim/lsp.log
```

Tailing with a filter

```
dune exec lsp_debug_tools -- ~/.local/state/nvim/lsp.log --name "jsperf-lsp"
```

## Vim LSP Starting
- Must have an lsp to debug using some form of logging
  - if the logs are JSON, then it will be prettified



