alias apti='sudo apt-get install'
alias b='x-www-browser --new-window'
alias cat="bat"
alias editconfig='nvim ~/code/dotfiles'
alias externalkbd='setxkbmap -layout us -variant intl'
alias g="git"
alias ls="ls -G --color"
alias n='nvim'
alias notekbd='setxkbmap -model abnt2 -layout br'
alias rehash='source ~/.zshrc'
alias t="tmux"

tns() {
  selected=$(find ~/code/ -mindepth 1 -maxdepth 1 -type d | fzf)
  selected_name=$(basename "$selected")
  tmux new-session -s $selected_name -c $selected
}

ta() { [ -z "$1"] && tmux attach || tmux attach -t $1 }

notify() {
  local url="https://api.pushover.net/1/messages"
  local user="u9sh4ah5kdmwd5utk5vsszqgwpth1p"
  local token="ajhkz4dqk5a3gnkckqi33cjmo7pwu6"

  http post $url user=$user token=$token message=$*
}

urlngrok() {
  curl --silent --show-error http://127.0.0.1:4040/api/tunnels | jq -r '.tunnels[0].public_url'
}

expose-http-server() {
  tmux new-session -d -s MySession -n Shell1 -d "/usr/bin/env sh -c \"go run ~/code/dotfiles/zsh/server.go -port 8081\"; /usr/bin/env sh -i"
  tmux split-window -t MySession:1 "/usr/bin/env sh -c \"ngrok http 8081\"; /usr/bin/env sh -i"
  sleep 1
  urlngrok | pbcopy
  urlngrok
}
