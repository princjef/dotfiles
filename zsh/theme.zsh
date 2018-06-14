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

ICON_POWERLINE_LEFT=`echo "\ue0b2"`
ICON_CHEVRON_RIGHT=`echo "\uf054"`
ICON_INFO=`echo "\ufb4d"`
ICON_GITHUB=`echo "\uf7a3"`
ICON_VSTS=`echo "\ufb0f"`
ICON_GIT=`echo "\uf7a1"`

# Set required options
#
setopt prompt_subst

# Load required modules
#
autoload -Uz vcs_info

# Set vcs_info parameters
#
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*:*' max-exports 4
zstyle ':vcs_info:*:*' formats "$FX[bold]%r$FX[no-bold]/%S" "%b" "" "%s"
zstyle ':vcs_info:*:*' actionformats "$FX[bold]%r$FX[no-bold]/%S" "%b" "(%a)" "%s"
zstyle ':vcs_info:*:*' nvcsformats "%~" "" "" ""

# Fastest possible way to check if repo is dirty
#
git_dirty() {
    # Check if we're in a git repo
    command git rev-parse --is-inside-work-tree &>/dev/null || return
    # Check if it's dirty
    command git diff --quiet --ignore-submodules HEAD &>/dev/null; [ $? -eq 1 ] && echo "*"
}

# Display information about the current repository
#
repo_information() {
    echo "%F{80}${vcs_info_msg_0_%%/.} %f"
}

branch_info() {
    echo "%F{8}$(git_remote_icon)$vcs_info_msg_1_%f"
}

mod_info() {
    local added=$(git_added_count)
    local modified=$(git_modified_count)
    local deleted=$(git_deleted_count)
    if [[ $added -ne 0 || $modified -ne 0 || $deleted -ne 0 ]]; then
        echo "%F{8}$ICON_POWERLINE_LEFT%K{8} %F{green}+$added %F{yellow}~$modified %F{red}-$deleted%f %k"
    else
        echo ""
    fi
}

# Get the initial timestamp for cmd_exec_time
#
preexec() {
    unset cmd_timing_stop
    cmd_timestamp=`date +%s`
}

# Output additional information about paths, repos and exec time
#
precmd() {
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
        cmd_execution_time="${elapsed}s "
    else
        cmd_execution_time=''
    fi
}

# Vi mode indicator
vi_mode_prompt_info () {
    if [[ ${KEYMAP} = 'vicmd' ]]
    then
        echo "%F{178}$ICON_POWERLINE_LEFT%f%K{178} %F{8}N%f"
    else
        echo "%F{74}$ICON_POWERLINE_LEFT%f%K{74} %F{8}I%f"
    fi
}

git_modified_count() {
    local -a files
    files=($(git ls-files --modified --exclude-standard))
    print $#files
}

git_added_count() {
    local -a files
    files=($(git ls-files --others --exclude-standard))
    print $#files
}

git_deleted_count() {
    local -a files
    files=($(git ls-files --deleted --exclude-standard))
    print $#files
}

git_remote_is_github() {
    git remote --verbose | grep 'origin.\+github.com' > /dev/null
}

git_remote_is_vsts() {
    git remote --verbose | grep 'origin.\+visualstudio.com' > /dev/null
}

git_remote_icon() {
    local icon=""
    if [[ ${vcs_info_msg_3_} = 'git' ]]; then
        if $(git_remote_is_github); then
            icon="$ICON_GITHUB "
        elif $(git_remote_is_vsts); then
            icon="$ICON_VSTS "
        else
            icon="$ICON_GIT "
        fi
    fi
    print $icon
}

right_prompt() {
    if [[ ${vcs_info_msg_3_} = 'git' ]]; then
        print "$(vi_mode_prompt_info) %F{252}$ICON_POWERLINE_LEFT%f%K{252} %F{bold}$(branch_info)%f $(mod_info)%k"
    else
        print "$(vi_mode_prompt_info) %k"
    fi
}

function zle-line-init zle-keymap-select {
    PROMPT="$(repo_information)%F{yellow}$cmd_execution_time%f%(?.%F{magenta}.%F{red})❯%f " # Display a red prompt char on failure
    RPROMPT="$(right_prompt)"
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

# Define prompts
#
PROMPT="$(repo_information)%F{yellow}$cmd_execution_time%f%(?.%F{magenta}.%F{red})❯%f " # Display a red prompt char on failure
RPROMPT="$(right_prompt)"

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
#!/usr/bin/env zsh

#!/usr/bin/env zsh
