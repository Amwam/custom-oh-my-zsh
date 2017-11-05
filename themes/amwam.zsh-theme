local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ %s)"

function get_pwd() {
    print -D $PWD
}

function get_git_commits() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        BRANCH=`current_branch`
        REMOTE_COUNT=`git branch -vv | grep origin/${BRANCH} | wc -l | tr -d ' '`
        if [ $REMOTE_COUNT -eq 0 ]; then
            print ""
        else
            local ahead=$(git rev-list @{u}.. --count)
            local behind=$(git rev-list ..@{u} --count)

            print " [A\033[92m${ahead}\033[0m, B\033[91m${behind}\033[0m]"
        fi
    else
        print ""
    fi
}

PROMPT='${ret_status}%{$fg_bold[green]%}%p %{$fg[cyan]%}$(get_pwd) %{$fg_bold[blue]%}$(git_prompt_info)$(get_git_commits)%{$fg_bold[blue]%} % %{$reset_color%} 
$ '

ZSH_THEME_GIT_PROMPT_PREFIX="git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
