return {
    cmd = { "ocamllsp" },
    filetypes = {
        "ocaml",
        "ocaml.interface",
        "ocaml.menhir",
        "ocaml.ocamllex",
        "dune",
        "reason",
    },
    root_markers = {
        { "dune-project", "dune-workspace" },
        { "*.opam",       "esy.json" },
        ".git",
    },
}

-- install opam
-- sudo pacman -S opam
-- opam init
-- eval $(opam env)

-- install other tools
--
--opam install \
  -- dune \
  -- utop \
  -- ocaml-lsp-server \
  -- ocamlformat \
  -- merlin

