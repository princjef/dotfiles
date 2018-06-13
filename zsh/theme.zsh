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

# Set required options
#
setopt prompt_subst

# Load required modules
#
autoload -Uz vcs_info

# Set vcs_info parameters
#
zstyle ':vcs_info:*' enable hg bzr git
zstyle ':vcs_info:*:*' unstagedstr '!'
zstyle ':vcs_info:*:*' stagedstr '+'
zstyle ':vcs_info:*:*' formats "$FX[bold]%r$FX[no-bold]/%S" "%s/%b" "%%u%c"
zstyle ':vcs_info:*:*' actionformats "$FX[bold]%r$FX[no-bold]/%S" "%s/%b" "%u%c (%a)"
zstyle ':vcs_info:*:*' nvcsformats "%~" "" ""

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
    echo "%F{131}${vcs_info_msg_0_%%/.} %F{8}$vcs_info_msg_1_`git_dirty` $vcs_info_msg_2_%f"
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
        echo "%F{178}N%f"
    else
        echo "%F{74}I%f"
    fi
}

ICON_CODEPOINT_CHEVRON_RIGHT=`echo "\uf054"`

function zle-line-init zle-keymap-select {
    PROMPT="$(repo_information)%F{yellow}$cmd_execution_time%f$(vi_mode_prompt_info) %(?.%F{magenta}.%F{red})$ICON_CODEPOINT_CHEVRON_RIGHT%f " # Display a red prompt char on failure
    RPROMPT="%F{8}${SSH_TTY:+%n@%m}%f"    # Display username if connected via SSH
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

# Define prompts
#
PROMPT="$(repo_information)%F{yellow}$cmd_execution_time%f$(vi_mode_prompt_info) %(?.%F{magenta}.%F{red})$ICON_CODEPOINT_CHEVRON_RIGHT%f " # Display a red prompt char on failure
RPROMPT="%F{8}${SSH_TTY:+%n@%m}%f"    # Display username if connected via SSH

# ------------------------------------------------------------------------------
#
# List of vcs_info format strings:
#
# %b => current branch
# %a => current action (rebase/merge)
# %s => current version control system
# %r => name of the root directory of the repository
# %u => show unstaged changes in the repository
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

