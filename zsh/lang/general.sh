alias apti='sudo apt-get install'
alias b='x-www-browser --new-window'
alias cat="bat"
alias editconfig='nvim ~/code/dotfiles'
alias externalkbd='setxkbmap -layout us -variant intl'
alias g="git"
alias ls="ls -G --color"
alias notekbd='setxkbmap -model abnt2 -layout br'
alias rehash='source ~/.zshrc'
alias t="tmux"
tnewsession() { tmux new-session -s $1 }
download() { http get $1 --download }
xmldownload() { http get $1 --follow | xmlstarlet fo >> $2 }
ta() { [ -z "$1"] && tmux attach || tmux attach -t $1 }
notify() {
  local url="https://api.pushover.net/1/messages"
  local user="u9sh4ah5kdmwd5utk5vsszqgwpth1p"
  local token="ajhkz4dqk5a3gnkckqi33cjmo7pwu6"

  http post $url user=$user token=$token message=$*
}
