local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ %s)"

function get_pwd() {
    print -D $PWD
}

YELLOW="\e[33m"
END_COLOR="\033[0m"

function get_git_commits() {
    OUTPUT=""
    if git rev-parse --git-dir > /dev/null 2>&1; then
        CHANGED_FILE_COUNT=$(git status -s | wc -l | tr -d ' ')
        if [ $CHANGED_FILE_COUNT -ne 0 ]; then
            OUTPUT="${OUTPUT}${CHANGED_FILE_COUNT}"
        fi


        BRANCH=$(current_branch)

        # Count the number of branches being tracked on teh remote
        REMOTE_COUNT=$(git branch -vv | grep origin/${BRANCH} | grep -v gone\] | wc -l | tr -d ' ')

        if [ $REMOTE_COUNT -eq 0 ]; then

            # Count the 'gone' branches (i.e. can't find on the server)
            GONE_COUNT=$(git branch -vv | grep origin/${BRANCH} | grep  gone\] | wc -l | tr -d ' ')
            if [ $GONE_COUNT -eq 1 ]; then
                OUTPUT="${OUTPUT} [${YELLOW}gone${END_COLOR}]"
            fi

        else
            local mainline=$(git rev-parse --abbrev-ref origin/HEAD)
            # Count the commits ahead and behind the current
            local ahead=$(git rev-list @{u}.. --count)
            local behind=$(git rev-list ..@{u} --count)
            local master=$(git rev-list ..${mainline} --count)

            OUTPUT="${OUTPUT} [A\033[92m${ahead}\033[0m, B\033[91m${behind}${END_COLOR}, M\033[93m${master}${END_COLOR}]"
        fi
    fi
    print "${OUTPUT}"
}

PROMPT='${ret_status}%{$fg_bold[green]%}%p %{$fg[cyan]%}$(get_pwd) %{$fg_bold[blue]%}$(git_prompt_info)$(get_git_commits)%{$fg_bold[blue]%} % %{$reset_color%} 
$ '

ZSH_THEME_GIT_PROMPT_PREFIX="git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
