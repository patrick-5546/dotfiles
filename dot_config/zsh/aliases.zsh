# general
alias ..='cd ..'
alias ...='cd ../..'
alias btop='bpytop'
alias c='chezmoi'
alias cls='clear'
alias du='dust'
alias e='exit'
alias grep='rg'
alias h='history'
alias l='ls -alh'
alias ll='ls -lh'
alias llt='ls -lhrt'
alias ls='ls --color=auto'
alias lt='ls -alhrt'
alias md='mkdir -p'
alias rd='rmdir'
alias vim='nvim'

# git - from https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git
alias g='git'
alias ga='git add'
alias gb='git branch'
alias gbD='git branch -D'
alias gcl='git clone --recurse-submodules'
alias gcmsg='git commit -m'
alias gd='git diff'
alias gdca='git diff --cached'
alias gmom='git merge origin/$(git_main_branch)'
alias gl='git pull'
alias gp='git push'
alias gpsup='git push --set-upstream origin $(git_current_branch)'
alias grb='git rebase'
alias grbc='git rebase --continue'
alias grbom='git rebase origin/$(git_main_branch)'
alias gra='git remote add'
alias grv='git remote -v'
alias grrm='git remote remove'
alias grh='git reset'
alias grhh='git reset --hard'
alias grs='git restore'
alias grst='git restore --staged'
alias grm='git rm'
alias grmc='git rm --cached'
alias gsta='git stash push'
alias gstp='git stash pop'
alias gst='git status'
alias gsu='git submodule update'
alias gsw='git switch'
alias gswc='git switch -c'
alias gswm='git switch $(git_main_branch)'
