#!/usr/bin/env zsh

# ------------------------------------------------------------------------------
#
# Pureline - A minimal and beautiful theme for zsh (modified from Pure/Refined)
#
# Based on the custom Zsh-prompt of the same name by Sindre Sorhus. A huge
# thanks goes out to him for designing the fantastic Pure prompt in the first
# place! I'd also like to thank Julien Nicoulaud for his "nicoulaj" theme from
# which I've borrowed both some ideas and some actual code. You can find out
# more about both of these fantastic two people here:
#
# Sindre Sorhus
#   Github:   https://github.com/sindresorhus
#   Twitter:  https://twitter.com/sindresorhus
#
# Julien Nicoulaud
#   Github:   https://github.com/nicoulaj
#   Twitter:  https://twitter.com/nicoulaj
#
# ------------------------------------------------------------------------------

# ZSH indents the right prompt by 1 by default. Remove that
ZLE_RPROMPT_INDENT=0

ICON_POWERLINE_LEFT=`echo "\ue0b2"`
ICON_CHEVRON_RIGHT=`echo "\uf054"`
ICON_INFO=`echo "\ufb4d"`
ICON_GITHUB=`echo "\uf7a3"`
ICON_VSTS=`echo "\ufb0f"`
ICON_GIT=`echo "\uf7a1"`
ICON_UP_CHEVRON=`echo "\uf077"`
ICON_DOWN_CHEVRON=`echo "\uf078"`
ICON_COMMIT=`echo "\ue729"`
ICON_UNLINK=`echo "\uf127"`
ICON_STAR=`echo "\uf41e"`
ICON_DOT=`echo "\uf444"`
ICON_PLUS=`echo "\uf44d"`
ICON_BRANCH=`echo "\uf418"`

# Set required options
setopt prompt_subst

# Load required modules
autoload -Uz vcs_info
autoload -Uz async && async

#########################
# Async infrastructure
#########################

prompt_async_runner() {
    # If we've never initialized the worker before (i.e. on first run), start
    # the worker and register the callback.
    ((!${prompt_async_worker_initialized:-0})) && {
        async_start_worker "prompt" -u -n
        async_register_callback "prompt" prompt_async_callback
        typeset -g prompt_async_worker_initialized=1
    }

    # Update the current working directory of the async worker.
    async_worker_eval "prompt" builtin cd -q $PWD

    # Create the vcs info variable if it is not present so we can reference
    # into it
    typeset -gA prompt_vcs_info
    typeset -gA prompt_commits
    typeset -gA prompt_modifications

    async_job "prompt" prompt_async_job_vcs_info

    # Only perform tasks if we're inside a repo
    [[ -n $prompt_vcs_info[repo] ]] && prompt_async_run_jobs
}

prompt_async_callback() {
    setopt localoptions noshwordsplit

    local job=$1 code=$2 output=$3 next_pending=$6
    local do_render=0
    local vcs_updated=0

    case $job in
        \[async])
            # code is 1 for corrupted worker output and 2 for dead worker
            if [[ $code -eq 2 ]]; then
                # Our worker died unexpectedly. Clear the flag so it gets
                # reinitialized next time
                typeset -g prompt_async_worker_initialized=0
            fi
            ;;
        prompt_async_job_vcs_info)
            local -A vcs
            typeset -gA prompt_vcs_info

            # Turn the stringified array back into an array
            vcs=("${(Q@)${(z)output}}")

            if [[ $vcs[cwd] = $PWD ]]; then
                # check if git toplevel has changed
                local -H MATCH MBEGIN MEND
                if [[ $vcs[repo] = $prompt_vcs_info[repo] ]]; then
                    # if stored pwd is part of $PWD, $PWD is shorter and likelier
                    # to be toplevel, so we update pwd
                    if [[ $prompt_vcs_info[cwd] = ${PWD}* ]]; then
                        prompt_vcs_info[cwd]=$PWD
                    fi
                else
                    # store $PWD to detect if we (maybe) left the git path
                    prompt_vcs_info[cwd]=$PWD
                fi
                unset MATCH MBEGIN MEND

                # Update has a git toplevel set which means we just entered a new
                # git directory, run the async refresh tasks
                [[ -n $vcs[repo] ]] && [[ -z $prompt_vcs_info[repo] ]] && prompt_async_run_jobs

                # always update branch and toplevel
                prompt_vcs_info[folder]=$vcs[folder]
                prompt_vcs_info[branch]=$vcs[branch]
                prompt_vcs_info[repo]=$vcs[repo]
                prompt_vcs_info[vcs]=$vcs[vcs]

                do_render=1
                vcs_updated=1
            fi
            ;;
        prompt_async_job_commits)
            local -A commits
            typeset -gA prompt_commits

            commits=("${(Q@)${(z)output}}")

            if [[ $prompt_vcs_info[branch] = $commits[branch] && $prompt_vcs_info[repo] = $commits[repo] ]]; then
                prompt_commits[has_remote]=$commits[has_remote]
                prompt_commits[ahead]=$commits[ahead]
                prompt_commits[behind]=$commits[behind]

                do_render=1
            fi
            ;;
        prompt_async_job_modifications)
            local -A modifications
            typeset -gA prompt_modifications

            modifications=("${(Q@)${(z)output}}")

            if [[ $prompt_vcs_info[branch] = $modifications[branch] && $prompt_vcs_info[repo] = $modifications[repo] ]]; then
                prompt_modifications[staged]=$modifications[staged]
                prompt_modifications[unstaged]=$modifications[unstaged]
                prompt_modifications[untracked]=$modifications[untracked]

                do_render=1
            fi
            ;;
    esac

    if (( next_pending )); then
        (( do_render )) && typeset -g prompt_render_requested=1
        return
    fi

    [[ ${prompt_render_requested:-$do_render} = 1 ]] && prompt_render
    unset prompt_render_requested

    # Run an extra round of updates dependent on vcs info if necessary, but
    # wait until after rendering to avoid stacking
    [[ $vcs_updated = 1 ]] && prompt_async_run_jobs
}

prompt_async_run_jobs() {
    setopt localoptions noshwordsplit

    if [[ -n $prompt_vcs_info[branch] && -n $prompt_vcs_info[repo] ]]; then
        async_job "prompt" prompt_async_job_commits $prompt_vcs_info[branch] $prompt_vcs_info[repo]

        async_job "prompt" prompt_async_job_modifications $prompt_vcs_info[branch] $prompt_vcs_info[repo]
    fi
}

#######################
# Async jobs
#######################

prompt_async_job_vcs_info() {
    setopt localoptions noshwordsplit

    # Set vcs_info parameters
    #
    zstyle ':vcs_info:*' enable git
    zstyle ':vcs_info:*:*' max-exports 5
    zstyle ':vcs_info:*:*' formats "$FX[bold]%r$FX[no-bold]/%S" "%b" "" "%s" "%R"
    zstyle ':vcs_info:*:*' actionformats "$FX[bold]%r$FX[no-bold]/%S" "%b" "%a" "%s" "%R"
    zstyle ':vcs_info:*:*' nvcsformats "%~" "" "" "" ""

    vcs_info # Get version control info before we start outputting stuff

    local -A vcs=(
        cwd     $PWD
        folder  $vcs_info_msg_0_
        branch  $vcs_info_msg_1_
        action  $vcs_info_msg_2_
        vcs     $vcs_info_msg_3_
        repo    $vcs_info_msg_4_
    )

    print -r - ${(@kvq)vcs}
}

prompt_async_job_commits() {
    local branch=$1
    local repo=$2

    local -A commits=(
        repo        "${repo}"
        has_remote  "$(git_has_remote $branch)"
        branch      "${branch}"
        ahead       "$(git_ahead_count $branch)"
        behind      "$(git_behind_count $branch)"
    )

    print -r - "${(@kvq)commits}"
}

prompt_async_job_modifications() {
    local branch=$1
    local repo=$2

    local -A modifications=(
        branch      "${branch}"
        repo        "${repo}"
        staged      "$(git_staged_count)"
        unstaged    "$(git_unstaged_count)"
        untracked   "$(git_untracked_count)"
    )

    print -r - "${(@kvq)modifications}"
}

git_unstaged_count() {
    local -a files
    files=($(git ls-files --modified --deleted --exclude-standard -- $(git rev-parse --show-toplevel)))
    print $#files
}

git_untracked_count() {
    local -a files
    files=($(git ls-files --others --exclude-standard -- $(git rev-parse --show-toplevel)))
    print $#files
}

git_staged_count() {
    local -a files
    files=($(git diff --name-only --staged))
    print $#files
}

git_has_remote() {
    local branch=$1
    command git rev-parse --verify $branch@{upstream} &> /dev/null
    print $?
}

git_ahead_count() {
    local branch=$1
    local -a commits
    commits=($(git rev-list $branch@{upstream}..HEAD))
    print $#commits
}

git_behind_count() {
    local branch=$1
    local -a commits
    commits=($(git rev-list HEAD..$branch@{upstream}))
    print $#commits
}

git_remote_is_github() {
    git remote --verbose | grep 'origin.\+github.com' > /dev/null
}

git_remote_is_vsts() {
    git remote --verbose | grep 'origin.\+visualstudio.com' > /dev/null
}

##############################
# Prompt printing functions
##############################

left_prompt() {
    # Display a red prompt char on failure
    print "$(repo_information)%F{yellow}$cmd_execution_time%f%(?.%F{magenta}.%F{red})❯%f "
}

right_prompt() {
    local -H MATCH MBEGIN MEND
    if [[ $PWD = ${prompt_vcs_info[repo]}* && $prompt_vcs_info[vcs] = 'git' ]]; then
        local trailer=$(modification_info)
        if [ -z "$trailer" ]; then
            trailer=$(commit_info)
        fi
        print "$(vi_mode_prompt_info) %F{252}$ICON_POWERLINE_LEFT%f%K{252} %F{bold}$(branch_info)%f $trailer%k"
    else
        print "$(vi_mode_prompt_info) %k"
    fi
    unset MATCH MBEGIN MEND
}

git_remote_icon() {
    local icon=""
    if [[ $prompt_vcs_info[vcs] = 'git' ]]; then
        # if $(git_remote_is_github); then
        #     icon="$ICON_GITHUB "
        # elif $(git_remote_is_vsts); then
        #     icon="$ICON_VSTS "
        # else
        #     icon="$ICON_GIT "
        # fi
        icon="$ICON_BRANCH "
    fi
    print $icon
}

# Vi mode indicator
vi_mode_prompt_info () {
    if [[ ${KEYMAP} = 'vicmd' ]]; then
        echo "%F{178}$ICON_POWERLINE_LEFT%f%K{178} %F{8}N%f"
    else
        echo "%F{74}$ICON_POWERLINE_LEFT%f%K{74} %F{8}I%f"
    fi
}

# Display information about the current repository
repo_information() {
    local folder

    local -H MATCH MBEGIN MEND
    if [[ -n $prompt_vcs_info[repo] && $PWD = ${prompt_vcs_info[repo]}* ]]; then
        folder=${prompt_vcs_info[folder]%%/.}
    else
        folder="%~"
    fi
    unset MATCH MBEGIN MEND

    echo "%F{80}$folder %f"
}

branch_info() {
    echo "%F{8}$(git_remote_icon)$prompt_vcs_info[branch]%f"
}

modification_info() {
    if [[ $prompt_modifications[staged] -ne 0 || $prompt_modifications[unstaged] -ne 0 || $prompt_modifications[untracked] -ne 0 ]]; then
        echo "%F{8}$ICON_POWERLINE_LEFT%K{8} %F{green}${ICON_STAR}$prompt_modifications[staged] %F{yellow}${ICON_DOT}$prompt_modifications[unstaged] %F{202}${ICON_PLUS}$prompt_modifications[untracked]%f %k"
    else
        echo ""
    fi
}

commit_info() {
    if [[ -n $prompt_commits[has_remote] ]]; then
        echo "%F{8}$ICON_POWERLINE_LEFT%K{8} %F{252}$ICON_COMMIT %F{green}${ICON_UP_CHEVRON}$prompt_commits[ahead] %F{red}${ICON_DOWN_CHEVRON}$prompt_commits[behind]%f %k"
    else
        echo "%F{8}$ICON_POWERLINE_LEFT%K{8} %F{252}$ICON_UNLINK%f %k"
    fi
}

# turns seconds into human readable time
# 165392 => 1d 21h 56m 32s
# https://github.com/sindresorhus/pretty-time-zsh
prompt_pretty_time() {
	local human total_seconds=$1
	local days=$(( total_seconds / 60 / 60 / 24 ))
	local hours=$(( total_seconds / 60 / 60 % 24 ))
	local minutes=$(( total_seconds / 60 % 60 ))
	local seconds=$(( total_seconds % 60 ))
	if (( days > 0 )); then
        human="${days}d"
        (( hours > 0 )) && human+=" ${hours}h"
    elif (( hours > 0 )); then
        human="${hours}h"
        (( minutes > 0 )) && human+=" ${minutes}m"
    elif (( minutes > 0 )); then
        human="${minutes}m"
        (( seconds > 0 )) && human+=" ${seconds}s"
    else
        human="${seconds}s"
    fi

    print $human
}

#####################
# Init / Runtime
#####################

# Get the initial timestamp for cmd_exec_time
prompt_preexec() {
    unset cmd_timing_stop
    cmd_timestamp=`date +%s`
}

# Output additional information about paths, repos and exec time
prompt_precmd() {
    vcs_info # Get version control info before we start outputting stuff
    
    # Timing stuff
    if [ -z ${cmd_timing_stop+x} ]; then
        # Use the actual stop the first time
        cmd_timing_stop=`date +%s`
    else
        # If we get here again it's not a real command. Zero out
        cmd_timing_stop=$cmd_timestamp
    fi
    local start=${cmd_timestamp:-$cmd_timing_stop}
    let local elapsed=$cmd_timing_stop-$start
    if [ $elapsed -gt 5 ]; then
        cmd_execution_time="$(prompt_pretty_time $elapsed) "
    else
        cmd_execution_time=''
    fi

    prompt_async_runner
}

function zle-line-init zle-keymap-select {
    prompt_render
}

prompt_render() {
    PROMPT="$(left_prompt)"
    RPROMPT="$(right_prompt)"
    zle .reset-prompt
}

prompt_setup() {
    zle -N zle-line-init
    zle -N zle-keymap-select

    add-zsh-hook precmd prompt_precmd
    add-zsh-hook preexec prompt_preexec

    # Define prompts
    #
    PROMPT="$(left_prompt)"
    RPROMPT="$(right_prompt)"
}

prompt_setup "$@"

# ------------------------------------------------------------------------------
#
# List of vcs_info format strings:
#
# %b => current branch
# %a => current action (rebase/merge)
# %s => current version control system
# %r => name of the root directory of the repository
# %c => show staged changes in the repository
#
# List of prompt format strings:
#
# prompt:
# %F => color dict
# %f => reset color
# %~ => current path
# %* => time
# %n => username
# %m => shortname host
# %(?..) => prompt conditional - %(condition.true.false)
#
# ------------------------------------------------------------------------------
