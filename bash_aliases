#!/bin/bash

### This file contains all my custom aliases, that I carefully handcrafted for me.
### To be sourced via ~/.bashrc
# OS
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias lg='ll | grep'
alias bat="batcat --paging=never"
alias man="batman"
alias ssh="ssh.exe"
alias ..='echo "cd .."; cd ..'
alias chomd='chmod'
alias gerp='grep'
alias suod='sudo'
alias update='sudo sh ~/bin/update.sh'
alias medl='meld'

# Git
# because `master` is sometimes `main` (or others), these must be functions.
gmb() { # git main branch
	local main
	main=$(git symbolic-ref --short refs/remotes/origin/HEAD)
	main=${main#origin/}
	[[ -n $main ]] || return 1
	echo "$main"
}

# show the diff from inside a branch to the main branch
gbd() { # git branch diff
	local mb=$(gmb) || return 1
	git diff "$mb..HEAD"
}

# checkout the main branch and update it
gcm() { # git checkout $main
	local mb=$(gmb) || return 1
	git checkout "$mb" && git pull
}

# merge the main branch into our branch
gmm() { # git merge $main
	local mb=$(gmb) || return 1
	git merge "$mb"
}
alias grm='git rebase master'
alias gR='~/bin/rebaseOnRelease.sh'
alias gp='git pull'
alias gc='git commit'
alias gs='git status'
alias gsu='git status -uno'
alias grst='git reset'
alias gfiles='git diff-tree --no-commit-id --name-only $commit -r'
alias gclean='bash ~/bin/keepGitCLean.sh'
alias gpop='git stash pop'
alias gta='git stash push -m'
alias gl='git stash list'
alias gw='git switch'
alias ga='git add -u'
alias gf='bash ~/bin/gitFetcher.sh'
alias gg='bash ~/bin/rebaseG.sh'
# Futur aliases ?
#alias nb='git checkout -b "$USER-$(date +%s)"' # new branch
#alias ga='git add . --all'
#alias gb='git branch'
#alias gc='git clone'
#alias gci='git commit -a'
#alias gco='git checkout'
#alias gd="git diff ':!*lock'"
#alias gdf='git diff' # git diff (full)
#alias gi='git init'
#alias gl='git log'
#alias gp='git push origin HEAD'
#alias gr='git rev-parse --show-toplevel' # git root
#alias gs='git status'
#alias gt='git tag'
#alias gu='git pull' # gu = git update

# Repos
alias cddo='cd /mnt/c/Users/jsandrin/Downloads/'
alias cdk='cd ~/AmbaSDK'
alias cda='cd ~/AmbaSDK/rtos/cortex_a'
alias cdr='cd ~/AmbaSDK/rtos/cortex_r'
alias cdl='cd ~/AmbaSDK/ambalink'
alias cdg='cd /mnt/g'
alias cdt='cd /mnt/c/Temp/'
alias cdpr='cd ~/AmbaSDK/rtos/cortex_a/tools/partitionReader'
alias cdok='cd ~/OLDAmbaSDK'
alias cdoa='cd ~/OLDAmbaSDK/rtos/cortex_a'
alias cdor='cd ~/OLDAmbaSDK/rtos/cortex_r'
alias cdol='cd ~/OLDAmbaSDK/ambalink'

# Amba
alias dok='bash ~/AmbaSDK/ambalink/svm_apps/tools/rundock.sh'
alias newdocker='bash ~/AmbaSDK/ambalink/svm_apps/tools/createdock.sh ~/AmbaSDK/ /mnt/c'
alias ba='bash ~/AmbaSDK/rtos/cortex_a/svm_scripts/sstBuilder.sh'
alias br='ba -r'
alias bl='ba -l'
alias eclipse='/opt/eclipse/eclipse > /dev/null 2>&1 &' #GDK_DPI_SCALE=1.5
alias conf='. ~/bin/afterDockerStart.sh'

alias ssecu='ssh root@$ecuip'

# Python
alias doexe='pyinstaller --onefile reader.py && mv dist/reader reader && rm -rf dist && rm -rf build && rm reader.spec'

# Lore
alias Taiwan='TZ=Asia/Taipei date'
alias Turc='TZ=Turquey date'
alias setTime="sudo ntpdate time.windows.com"
alias cronStatus="systemctl status cron"

