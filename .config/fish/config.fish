alias n="nvim"
alias e="emacsclient"

if status is-interactive
  set -gx EDITOR 'emacsclient -t'
  set -gx VISUAL 'emacsclient -t'
end

if not set -q GOPATH
    set -gx GOPATH $HOME/go
end
set -U fish_user_paths $HOME/bin $GOPATH/bin $HOME/.fzf/bin /usr/local/bin

source ~/.asdf/asdf.fish
eval (direnv hook fish)
