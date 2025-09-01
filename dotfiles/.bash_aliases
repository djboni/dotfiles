alias gs='echo "Invalid command 'gs'" >&2'
alias gss='git status -s'
alias ga='git add'
alias gaa='git add --all; git status -s; :'
alias gk='gitk --all & :'
alias gll='git log --oneline --graph'
alias gla='gll $(git for-each-ref --format "%(refname)") $(git stash list --format="%h")'
alias gl='gll -12'
alias grl='gll $(git reflog | cut -f1 -d" " | sort -u | head -n100)'

if [ "$OS" = "Windows_NT" ] && [ "$TERM_PROGRAM" = "mintty" ]; then
    if command -v nvim >/dev/null 2>&1; then
        # NOTE: In this case the color scheme is weird (Windows, Git-Bash, running NeoVim)
        alias vi='winpty nvim'
        alias vim='winpty nvim'
        alias view='winpty nvim -R'
        alias nvim='winpty nvim'
    fi
else
    if command -v nvim >/dev/null 2>&1; then
        alias vi='nvim'
        alias vim='nvim'
        alias view='nvim -R'
    fi
fi
