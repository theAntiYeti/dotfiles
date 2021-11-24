# Start Tmux
[ -z "TMUX" ] && { exec tmux new-session -A -s main && exit; }
tmux source-file $HOME/.config/tmux/tmux.conf

# Add to the path
source $HOME/.config/env/path

# Export zsh dot dir
export ZDOTDIR=$HOME/.config/zsh
export ZCOREDUMP=$HOME/.cache/zsh/zcompdump-$ZSH_VERSION
export ZSH_COMPDUMP=$HOME/.cache/zsh/.zcompdump-Trantor-$ZSH_VERSION

# This file directs ZSH to find files in .config as it hardcodes file location
source ~/.config/oh-my-zsh/oh-my-zsh-setup

# Export Variables; Also XDG settings
source ~/.config/env/vars

# Export aliases
source ~/.config/env/aliases

# Start Keychain
eval "$(keychain --eval trentor_ssh_key)"
