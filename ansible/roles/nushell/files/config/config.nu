$env.config.buffer_editor = "nvim"
$env.config.edit_mode = "vi"
$env.config.show_banner = false

source ~/.local/share/atuin/init.nu

alias apti = sudo apt-get install
alias b = x-www-browser --new-window
alias cat = batcat
alias editconfig = nvim ~/code/dotfiles
alias g = git
alias n = nvim
alias pbcopy = xclip -selection clipboard
alias pbpaste = xclip -selection clipboard -o
alias t = tmux

def ta [session?: string] {
    if ($session == null) {
        tmux attach
    } else {
        tmux attach -t $session
    }
}

def html_unescape [] {
    $in | python3 -c "import sys, urllib.parse as u; print(u.unquote(sys.stdin.read().strip()))"
}

def tns [] {
    let selected = (ls ~/code | where type == dir | get name | input list --fuzzy "Select project:")
    if $selected != null {
        let selected_name = ($selected | path basename)
        ^tmux new-session -s $selected_name -c $selected
    }
}

def notify [...message: string] {
    {
        token: $env.PUSHOVER_TOKEN,
        user: $env.PUSHOVER_USER,
        message: ($message | str join " ")
    } | to json | http post https://api.pushover.net/1/messages
}

def urlngrok [] {
  try {
    http get http://127.0.0.1:4040/api/tunnels
    | get tunnels
    | index 0
    | get public_url
  } catch {
    echo "ngrok is not running"
  }
}

def downloadsite [url: string] {
    if ($url == null) {
        error make {msg: "Usage: downloadsite <url>"}
    }

    ^wget -r -np -k -p --timeout=5 --tries=3 --no-check-certificate $url
}

def expose-http-server [] {
    let session_name = "HTTPServer"
    let port = 8081

    let start_http_server = ["go", "run", "~/code/dotfiles/zsh/server.go", "-port", $port]
    let start_ngrok = ["ngrok", "http", $port]
    ^tmux new-session -d -s $session_name -n Ngrok-HTPPServer $"($start_ngrok | str join ' ')"
    ^tmux split-window -t $"($session_name):1" $"($start_http_server | str join ' ')"
    sleep 2sec

    let url = (urlngrok)
    $url | clip
    print $"host: ($url)"
    print $"usage: http post ($url)/upload file=@path-to-file"
}

def http-server [] {
    let url = (try { urlngrok } catch { null })

    if ($url == null) {
        expose-http-server
    } else {
        print $url
    }
}

def nerdfontinstall [] {
    let url = 'https://www.nerdfonts.com/font-downloads'

    let html = (http get $url)

    let font_options = (echo $html | ^htmlq --attribute href .font-preview | lines)
    let font_url = ($font_options | input list --fuzzy "Select font:")
    if $font_url == null {
        return
    }
    let file_name = ($font_url | path basename)
    let fonts_dir = ([$env.HOME, '.local', 'share', 'fonts'] | path join)

    if not ($fonts_dir | path exists) {
        mkdir $fonts_dir
    }
    print $"Downloading ($file_name)..."
    http get --raw $font_url | save -f $file_name
    print "Extracting fonts..."
    ^unzip -d $fonts_dir $file_name
    print "Updating font cache..."
    ^fc-cache -f -v
    print $"Installed ($file_name) successfully!"
}
