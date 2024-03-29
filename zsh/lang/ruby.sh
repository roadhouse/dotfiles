PATH=$HOME/.gems/bin:./bin_stubs:$HOME/.rvm/bin:$PATH

alias s="rails s"
alias c="rails c"
alias bi='bundle install --binstubs=./bin_stubs --without=production'
alias gmi='gem install'
alias sp='RAILS_ENV=test bundle exec rspec -fp'
alias be='bundle exec'

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

