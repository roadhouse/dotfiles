alias t="tmux"
alias ls="ls -G --color"
alias g="git"
alias editconfig='nvim ~/.zshrc'
alias rehash='source ~/.zshrc'
alias apti='sudo apt-get install'
alias externalkbd='setxkbmap -layout us -variant intl'
alias notekbd='setxkbmap -model abnt2 -layout br'
tnewsession() { tmux new-session -s $1 }
download() { http get $1 --download }
xmldownload() { http get $1 --follow -b | xmlstarlet fo >> $2 }
notify() {
  local url="https://api.pushover.net/1/messages"
  local user="u9sh4ah5kdmwd5utk5vsszqgwpth1p"
  local token="ajhkz4dqk5a3gnkckqi33cjmo7pwu6"

  http post $url user=$user token=$token message=$*
}
ta() {
  if [ -z "$1"]; then
    tmux attach
  else
    tmux attach -t $1
  fi
}
