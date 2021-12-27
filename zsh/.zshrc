# Personal Zsh configuration file. It is strongly recommended to keep all
# shell customization and configuration (including exported environment
# variables such as PATH) in this file or in files source by it.
#
# Documentation: https://github.com/romkatv/zsh4humans/blob/v5/README.md.

# Periodic auto-update on Zsh startup: 'ask' or 'no'.
# You can manually run `z4h update` to update everything.
zstyle ':z4h:' auto-update      'ask'
# Ask whether to auto-update this often; has no effect if auto-update is 'no'.
zstyle ':z4h:' auto-update-days '7'

# Automaticaly wrap TTY with a transparent tmux ('integrated'), or start a
# full-fledged tmux ('system'), or disable features that require tmux ('no').
zstyle ':z4h:' start-tmux       'no'
# Move prompt to the bottom when zsh starts up so that it's always in the
# same position. Has no effect if start-tmux is 'no'.
zstyle ':z4h:' prompt-at-bottom 'no'

# Keyboard type: 'mac' or 'pc'.
zstyle ':z4h:bindkey' keyboard  'mac'

# Right-arrow key accepts one character ('partial-accept') from
# command autosuggestions or the whole thing ('accept')?
zstyle ':z4h:autosuggestions' forward-char 'accept'

# Recursively traverse directories when TAB-completing files.
zstyle ':z4h:fzf-complete' recurse-dirs 'yes'

# Enable ('yes') or disable ('no') automatic teleportation of z4h over
# ssh when connecting to these hosts.
zstyle ':z4h:ssh:example-hostname1'   enable 'yes'
zstyle ':z4h:ssh:*.example-hostname2' enable 'no'
# The default value if none of the overrides above match the hostname.
zstyle ':z4h:ssh:*'                   enable 'no'

# Send these files over to the remote host when connecting over ssh to the
# enabled hosts.
zstyle ':z4h:ssh:*' send-extra-files '~/.nanorc' '~/.env.zsh'

# Clone additional Git repositories from GitHub.
#
# This doesn't do anything apart from cloning the repository and keeping it
# up-to-date. Cloned files can be used after `z4h init`. This is just an
# example. If you don't plan to use Oh My Zsh, delete this line.
z4h install ohmyzsh/ohmyzsh || return

# Install or update core components (fzf, zsh-autosuggestions, etc.) and
# initialize Zsh. After this point console I/O is unavailable until Zsh
# is fully initialized. Everything that requires user interaction or can
# perform network I/O must be done above. Everything else is best done below.
z4h init || return

# Extend PATH.
path=(~/bin $path)

# Export environment variables.
export GPG_TTY=$TTY

# Source additional local files if they exist.
z4h source ~/.env.zsh

# Use additional Git repositories pulled in with `z4h install`.
#
# This is just an example that you should delete. It does nothing useful.
z4h source $Z4H/ohmyzsh/ohmyzsh/lib/diagnostics.zsh
z4h source $Z4H/ohmyzsh/ohmyzsh/plugins/emoji-clock/emoji-clock.plugin.zsh
# z4h source $Z4H/ohmyzsh/ohmyzsh/plugins/asdf/asdf.plugin.zsh
fpath+=($Z4H/ohmyzsh/ohmyzsh/plugins/supervisor)

function _ranger() { 
  local temp_file="$(mktemp -t "ranger_cd.XXXXXXXXXX")"
  tmux display-popup -E ranger --choosedir="$temp_file" -- "${@:-$PWD}"
  if chosen_dir="$(cat -- "$temp_file")" && [ -n "$chosen_dir" ] && [ "$chosen_dir" != "$PWD" ]; then
      cd -- "$chosen_dir"
  fi
  rm -f -- "$temp_file"
  zle accept-and-hold
}
zle -N _ranger

# Define key bindings.
z4h bindkey undo Ctrl+/  # undo the last command line change
z4h bindkey redo Alt+/   # redo the last undone command line change

z4h bindkey z4h-cd-back          Shift+Left   # cd into the previous directory
z4h bindkey z4h-cd-forward       Shift+Right  # cd into the next directory
z4h bindkey z4h-cd-up            Shift+Up     # cd into the parent directory
z4h bindkey z4h-cd-down          Shift+Down   # cd into a child directory
z4h bindkey _ranger              Ctrl+Space
z4h bindkey _atuin_search_widget Ctrl+R


# Autoload functions.
autoload -Uz zmv

# Define functions and completions.
function md() { [[ $# == 1 ]] && mkdir -p -- "$1" && cd -- "$1" }
compdef _directories md

# Define named directories: ~w <=> Windows home directory on WSL.
[[ -z $z4h_win_home ]] || hash -d w=$z4h_win_home

# Define aliases.
alias tree='tree -a -I .git'

# Add flags to existing aliases.
alias ls="${aliases[ls]:-ls} -A"

# Set shell options: http://zsh.sourceforge.net/Doc/Release/Options.html.
setopt glob_dots     # no special treatment for file names with a leading dot
setopt no_auto_menu  # require an extra TAB press to open the completion menu

export XDG_CONFIG_HOME="$HOME/.config"
export EDITOR="lvim"
export VISUAL=$EDITOR
export PAGER="$EDITOR -c 'set ft=man' -"
export MANPAGER=$PAGER
export BAT_PAGER="/usr/bin/less"
export BROWSER="open"
export PATH="$(composer config -g home)/vendor/bin:$PATH"
export ATUIN_NOBIND="true"

source ~/.zsh_aliases

if [ -e /Users/nielsmentink/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/nielsmentink/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

eval "$(fnm env)"
eval "$(zoxide init zsh)"
eval "$(atuin init zsh)"

source /Users/nielsmentink/.config/broot/launcher/bash/br
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"


# Bun completions
[ -s "/Users/nielsmentink/.bun/_bun" ] && source "/Users/nielsmentink/.bun/_bun"

# Bun
export BUN_INSTALL="/Users/nielsmentink/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
