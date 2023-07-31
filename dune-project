(lang dune 3.9)

(name lsp_debug_tools)

(generate_opam_files true)

(source
 (github username/reponame))

(authors "ThePrimeagen")

(maintainers "ThePrimeagen")

(license MIT)

(documentation https://url/to/documentation)

(package
 (name lsp_debug_tools)
 (synopsis "An attempt at building something with ocaml that i will find useful.")
 (description "take any output file and tail it and parse out the lsp information.")
 (depends ocaml dune)
 (tags
  (topics lsp lsp-tools tools debug)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
