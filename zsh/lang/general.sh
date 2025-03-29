alias apti='sudo apt-get install'
alias b='x-www-browser --new-window'
alias cat="batcat"
alias editconfig='nvim ~/code/dotfiles'
alias externalkbd='setxkbmap -layout us -variant intl'
alias g="git"
alias ls="ls -G --color"
alias n='nvim'
alias notekbd='setxkbmap -model abnt2 -layout br'
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
alias rehash='source ~/.zshrc'
alias t="tmux"

ta() {
  ([ -z "$1" ] && tmux attach) || tmux attach -t "$1" 
}

html_unescape() {
  python3 -c "import sys, urllib.parse as u; print(u.unquote(sys.stdin.read().strip()))"
}

tns() {
  selected=$(find ~/code/ -mindepth 1 -maxdepth 1 -type d | fzf)
  selected_name=$(basename "$selected")
  tmux new-session -s "$selected_name" -c "$selected"
}

notify() {
  url="https://api.pushover.net/1/messages";
  curl -F "token=$PUSHOVER_TOKEN" -F "user=$PUSHOVER_USER" -F "message=$*" $url
}

urlngrok() {
  curl --silent http://127.0.0.1:4040/api/tunnels | jq -r '.tunnels[0].public_url'
}

downloadsite() {
  [[ -z "$url" ]] && echo "Usage: $0 <url>" && return 1

  wget -r -np -k -p --timeout=5 --tries=3 --no-check-certificate "$1"
}

expose-http-server() {
  sessionName="HTTPServer"
  startHtppServer="/usr/bin/env sh -c \"go run ~/code/dotfiles/zsh/server.go -port 8081\"; /usr/bin/env sh -i"
  startNgrok="/usr/bin/env sh -c \"ngrok http 8081\"; /usr/bin/env sh -i"

  tmux new-session -d -s "$sessionName" -n Ngrok-HTPPServer "$startNgrok"
  tmux split-window -t "$sessionName":1 "$startHtppServer"
  sleep 2

  urlngrok=$(urlngrok)
  echo "$urlngrok" | pbcopy
  echo "host: $urlngrok"
  echo "usage: curl -X POST $urlngrok/upload -F 'file=@path-to-file'"
}

http-server() {
  urlngrok=$(urlngrok)

  [[ -z "$urlngrok" ]] && expose-http-server || echo "$urlngrok"
}

nerdfontinstall() {
  url='https://www.nerdfonts.com/font-downloads'
  font_url=$(curl -s "$url"|htmlq --attribute href .font-preview:first-child|fzf)
  file_name=$(basename "$font_url")

  curl -L -O "$font_url"
  unzip -d ~/.local/share/fonts "$file_name" 
  fc-cache -f -v
}
