; extends

; https://mise.jdx.dev/mise-cookbook/neovim.html
; Multiline run command with an /usr/bin/env <language> shebang.
(pair
  (bare_key) @key (#eq? @key "run")
  (string) @injection.content @injection.language
  (#is-mise?)
  (#match? @injection.language "^['\"]{3}\n*#!(/\\w+)+/env\\s+\\w+")
  (#gsub! @injection.language "^.*#!/.*/env%s+([^%s]+).*" "%1")
  (#offset! @injection.content 0 3 0 -3))

; Multiline run command with a direct interpreter shebang.
(pair
  (bare_key) @key (#eq? @key "run")
  (string) @injection.content @injection.language
  (#is-mise?)
  (#match? @injection.language "^['\"]{3}\n*#!(/\\w+)+\\s*\n")
  (#gsub! @injection.language "^.*#!/.*/([^/%s]+).*" "%1")
  (#offset! @injection.content 0 3 0 -3))

; Multiline commands without a shebang default to Bash highlighting.
(pair
  (bare_key) @key (#eq? @key "run")
  (string) @injection.content
  (#is-mise?)
  (#match? @injection.content "^['\"]{3}\n*.*")
  (#not-match? @injection.content "^['\"]{3}\n*#!")
  (#offset! @injection.content 0 3 0 -3)
  (#set! injection.language "bash"))

; Single-line run commands.
(pair
  (bare_key) @key (#eq? @key "run")
  (string) @injection.content
  (#is-mise?)
  (#not-match? @injection.content "^['\"]{3}")
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "bash"))
