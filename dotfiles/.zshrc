if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Zinit configuration
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -d "$ZINIT_HOME" ]]; then
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# Set emacs edit mode
bindkey -e

# Load plugins
zinit light zdharma-continuum/zinit-annex-as-monitor
zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light agkozak/zsh-z
zinit light romkatv/powerlevel10k
zinit light junegunn/fzf
zinit light loiccoyle/zsh-github-copilot

# Load OMZ snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found

# Completions
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza $realpath'

# History configuration
HISTSIZE=500000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt HIST_REDUCE_BLANKS

# Keybindings
bindkey '^[?' zsh_gh_copilot_explain  # bind Alt+shift+\ to explain
bindkey '^_' zsh_gh_copilot_suggest  # bind Alt+\ to suggest
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region
bindkey '^w' backward-kill-word
bindkey '^el' vi-forward-char
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# Environment variables
export EDITOR="/usr/bin/nvim"
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.local/share/pnpm:$PATH"
export PNPM_HOME="$HOME/.local/share/pnpm"
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin:/usr/local/go/bin"
export FZF_DEFAULT_OPTS="--height=40% --layout=reverse --color=bg:#272525,hl:#9cdcfe,hl+:#9cdcfe"
export PYENV_ROOT="$HOME/.pyenv"
export MIX_HOME="$HOME/.mix"
export MIX_ARCHIVES="$MIX_HOME/archives"

# Custom FZF commands
export FZF_DEFAULT_COMMAND="fd --type f --hidden --exclude .git --exclude node_modules --exclude '*/\.*/*' --exclude '/usr/*' --exclude '/etc/*' --exclude '/var/*'"
export FZF_CTRL_P_COMMAND="$FZF_DEFAULT_COMMAND"

# Load fzf for shell
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Custom fzf function for Ctrl+P
fzf-file-widget-custom() {
  local selected
  selected=$(eval "$FZF_CTRL_P_COMMAND" | fzf -m)
  if [ -n "$selected" ]; then
    LBUFFER="${LBUFFER}${selected}"
  fi
  zle redisplay
}
zle -N fzf-file-widget-custom
bindkey '^P' fzf-file-widget-custom

# Aliases
alias gu='gitupdate'
alias ..='cd ..' ...='cd ../..' .3='cd ../../..' .4='cd ../../../..' .5='cd ../../../../..'
alias l='eza -lh --icons=auto' ls='eza -1 --icons=auto' ll='eza -lha --icons=auto --sort=name --group-directories-first'
alias ld='eza -lhD --icons=auto' lt='lsd --tree --depth 1 --sizesort --reverse'
alias c='clear' e='exit' v='nvim' vim='nvim' grep='rg --color=auto'
alias gs='git status' gac='git add . && git commit -m' gpush='git push origin' lg='lazygit'
alias rebuild='sudo nixos-rebuild switch --flake ~/rudra/.#default'
alias recats='sudo nix flake lock --update-input nixCats && sudo nixos-rebuild switch --flake ~/rudra/.#default'
alias pbcopy='wl-copy' pbpaste='wl-paste'
alias ssn='sudo shutdown now' srn='sudo reboot now'
alias docker-clean='docker container prune -f && docker image prune -f && docker network prune -f && docker volume prune -f'
alias cr='cargo run' y='yazi' battery='upower -i /org/freedesktop/UPower/devices/battery_BAT1'
alias b='cd ..'
alias config="git --git-dir=/home/william/.cfg/ --work-tree=/home/william"
alias ~="cd ~"
alias edit="nvim ~/.zshrc"
alias update="source ~/.zshrc"
alias i="/usr/bin/nvim"

# Tool integrations
eval "$(zoxide init --cmd cd zsh)"
eval "$(fnm env --use-on-cd --shell zsh)"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="/usr/bin:$PATH"
export QT_STYLE_OVERRIDE=Darkly

# Functions
function gitupdate() {
  local message="${*:-Update}"
  git add . && git commit -m "$message" && git push
}

function wificonnect() {
  nmcli device wifi connect "$1" password "$2"
}

function my_htop() {
  [ $# -eq 0 ] && htop || htop --filter "$@"
}

function configupdate {
  config commit -m "$1" && config push
}

# Powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
