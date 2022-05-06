source /opt/homebrew/share/antigen/antigen.zsh

antigen use oh-my-zsh

antigen bundle adb
antigen bundle brew
antigen bundle fzf
antigen bundle zoxide

antigen bundle zsh-users/zsh-autosuggestions
antigen bundle Aloxaf/fzf-tab

antigen bundle zdharma-continuum/fast-syntax-highlighting

# Extend PATH.
path=(~/bin $path)

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 -a --color=always $realpath'
zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' fzf-preview 'echo ${(P)word}'

# Export environment variables.
export GPG_TTY=$TTY

# z4h bindkey _ranger              Ctrl+Space
# z4h bindkey _atuin_search_widget Ctrl+R
bindkey -s '^ ' 'redo^M'

# Autoload functions.
autoload -Uz zmv

# Define named directories: ~w <=> Windows home directory on WSL.
# [[ -z $z4h_win_home ]] || hash -d w=$z4h_win_home

# Define aliases.
alias tree='tree -a -I .git'

# Add flags to existing aliases.
alias ls="${aliases[ls]:-ls} -A"

# Set shell options: http://zsh.sourceforge.net/Doc/Release/Options.html.
setopt glob_dots     # no special treatment for file names with a leading dot
# setopt no_auto_menu  # require an extra TAB press to open the completion menu
setopt autocd

export XDG_CONFIG_HOME="$HOME/.config"
export EDITOR="nvim"
export VISUAL=$EDITOR
export MANPAGER='$EDITOR +Man!'
export MANWIDTH=999
export BAT_PAGER="/usr/bin/less"
export BROWSER="open"
export ATUIN_NOBIND="true"
export REDO_HISTORY_PATH="$HISTFILE"
export REDO_ALIAS_PATH="$HOME/.config/redo/aliases"

export ZVM_VI_SURROUND_BINDKEY="s-prefix"

eval "$(starship init zsh)"
eval "$(atuin init zsh)"
eval "$(rbenv init - zsh)"
eval "$(gh completion -s zsh)"
source "$(redo alias-file)"

export PATH="$HOME/go/bin/:$PATH"

export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$PATH:$ANDROID_HOME/emulator"
export PATH="$PATH:$ANDROID_HOME/tools"
export PATH="$PATH:$ANDROID_HOME/tools/bin"
export PATH="$PATH:$ANDROID_HOME/platform-tools"
export PATH="$PATH:$HOME/.yarn/bin"
export PATH="$PATH:$HOME/.config/yarn/global/node_modules/.bin"
export JAVA_HOME="/Applications/Android Studio.app/Contents/jre/Contents/Home"

# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && . ~/.config/tabtab/zsh/__tabtab.zsh || true

antigen bundle jeffreytse/zsh-vi-mode
antigen apply

# Define functions and completions.
function md() { [[ $# == 1 ]] && mkdir -p -- "$1" && cd -- "$1" }
compdef _directories md

source ~/.zsh_aliases
