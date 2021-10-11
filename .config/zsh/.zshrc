#Prompt
autoload -U colors && colors	
PS1="%F{red}[%n@%f%F{blue}%M %~]%f %F{grey}λ%f "
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
#Vi
bindkey -v
export KEYTIMEOUT=1

#History
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE=~/.config/zsh/.zhist
setopt INC_APPEND_HISTORY_TIME

#Opts 
setopt autocd
#Exports
export VISUAL=nvim;
export EDITOR=nvim;
#Aliases
alias nc='nvim ~/.config/nvim/init.vim'
alias dwme='nvim ~/wm/dwm/config.h'
alias dwmcd='cd ~/wm/dwm/'
alias dwmb='cd ~/wm/dwm/ && sudo make install && make clean && cd -'
alias zshe='nvim ~/.zshrc'
alias s='sudo systemctl'
alias zc='nvim ~/.zshrc'
alias kx='killall xinit'
alias sx='startx'
alias ls="exa"
alias md="mkdir"
#Only use if you want exa, as an ls replacement.
#alias ls='exa -1'
alias lss='exa -la | grep'
zstyle ":completion:*:commands" rehash 1
