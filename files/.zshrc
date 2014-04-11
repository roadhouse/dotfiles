ZSH=/Users/jeanuchoa/.oh-my-zsh
ZSH_THEME="zhann"
plugins=(git)
source $ZSH/oh-my-zsh.sh

alias ls="ls -G"
alias s="rails s"
alias c="rails c"
alias g="git"
alias td="tail -f log/development.log"
alias tt="tail -f log/test.log"
alias ensuremigrate="rake db:migrate && rake db:rollback && rake db:migrate && rake db:test:prepare"
alias recreate_all="rake db:drop:all && rake db:create:all && rake db:migrate && rake db:seed && rake db:test:prepare"
alias bi='bundle install --binstubs=~/.bin --without=production'
alias gmi='gem install'

bindkey -v
  
export CDPATH=.:~/code
export PATH=./bin:$HOME/bin:$PATH:$HOME/.rvm/bin 

export CLICOLOR="auto"
export EDITOR=vim
export GREP_OPTIONS="--color=auto"
export HISTCONTROL=ignoreboth
export HISTCONTROL=ignoredups
export HISTIGNORE="&:[bf]g:exit"
export TERM='xterm-256color'
# export GREP_COLOR="4;33"
