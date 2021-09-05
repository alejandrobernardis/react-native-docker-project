#!/usr/bin/env bash

HISTSIZE=1000
HISTFILESIZE=0
HISTCONTROL=ignoreboth

alias c='clear'
alias cl='clear;ls'
alias cpl='clear;pwd;ls'
alias :q='exit'
alias reload='exec $SHELL -l'
alias cp='cp -i'
alias rm='rm -i'
alias mv='mv -i'
alias mkdir='mkdir -p'

list() {
  local ls_opts='-lv --classify --group-directories-first --human-readable --color=always'
  alias l="ls $ls_opts"
  alias ll=l
  alias l.="ls -d $ls_opts .*"
  unset ls_opts
} && list && unset -f list

dotted() {
  local dots='.'; local under='_'; local parents='';
  for _ in {1..7}; do
    dots+='.'; under+='_'; parents+='../';
    alias $dots="cd $parents"
    alias $under="cd $parents; pwd; ls"
  done
  unset dots under parents
} && dotted && unset -f dotted

up() {
  local value=$1
  if [[ "$value" == '' ]]; then
    cd ..
  elif ! [[ "$value" =~ ^[0-9]+$ ]]; then
    echo 'Argument must be a number'
  elif ! [[ "$value" -gt '0' ]]; then
    echo 'Argument must be positive'
  else
    for _ in $(seq 1 "$value"); do
      cd ..;
    done
  fi
}

PS1=' \[\033[01;34m\]\w\[\033[00m\]\[\033[01;32m\]:\[\033[00m\] '

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
  fi
fi
