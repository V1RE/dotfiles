; extends

; https://mise.jdx.dev/mise-cookbook/neovim.html
; #MISE, #[MISE], and # [MISE] metadata is TOML.
((comment) @injection.content
  (#lua-match? @injection.content "^#MISE ")
  (#offset! @injection.content 0 6 0 1)
  (#set! injection.language "toml"))

((comment) @injection.content
  (#lua-match? @injection.content "^#%[MISE%] ")
  (#offset! @injection.content 0 8 0 1)
  (#set! injection.language "toml"))

((comment) @injection.content
  (#lua-match? @injection.content "^# %[MISE%] ")
  (#offset! @injection.content 0 9 0 1)
  (#set! injection.language "toml"))

; #USAGE, #[USAGE], and # [USAGE] specifications are KDL.
; Include trailing newlines and combine comments for multiline blocks on Neovim 0.11.
((comment) @injection.content
  (#lua-match? @injection.content "^#USAGE ")
  (#offset! @injection.content 0 7 0 1)
  (#set! injection.combined)
  (#set! injection.language "kdl"))

((comment) @injection.content
  (#lua-match? @injection.content "^#%[USAGE%] ")
  (#offset! @injection.content 0 9 0 1)
  (#set! injection.combined)
  (#set! injection.language "kdl"))

((comment) @injection.content
  (#lua-match? @injection.content "^# %[USAGE%] ")
  (#offset! @injection.content 0 10 0 1)
  (#set! injection.combined)
  (#set! injection.language "kdl"))
