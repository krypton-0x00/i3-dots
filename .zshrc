# ~/.zshrc
# Location of history file
HISTFILE=~/.zsh_history

# Number of commands to save in memory and file
HISTSIZE=10000
SAVEHIST=10000

# Options to control history behavior
setopt INC_APPEND_HISTORY        # Add commands to history immediately
setopt SHARE_HISTORY             # Share history between terminal sessions
setopt HIST_EXPIRE_DUPS_FIRST    # Remove duplicate entries when trimming
setopt HIST_IGNORE_DUPS          # Ignore duplicates
setopt HIST_IGNORE_ALL_DUPS      # Delete old duplicates
setopt HIST_FIND_NO_DUPS         # Don't show duplicates when searching
setopt HIST_REDUCE_BLANKS        # Remove unnecessary blanks
setopt HIST_VERIFY               # Don't run a history expansion right away
setopt APPEND_HISTORY            # Append to the history file (don't overwrite)

# Ctrl+Backspace to delete previous word
bindkey '^H' backward-kill-word

# Ctrl+Left/Right to jump words
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

# Enable plugins
source ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

alias tty-clock='tty-clock -c -C 3 -f "%I:%M %p"'

# Set oh-my-posh theme
# eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/orange-grey.omp.json)"
eval "$(starship init zsh)"


