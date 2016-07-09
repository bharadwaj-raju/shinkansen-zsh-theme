# Main file for Shinkansen
# Usage: source shinkansen.zsh-theme

# ------------------------------------------------------------------------------
# CONFIGURATION
# The default configuration, that can be overwrite in your .zshrc file
# ------------------------------------------------------------------------------

# Define order and content of prompt
if [ ! -n "${SHINKANSEN_PROMPT_ORDER+1}" ]; then
	SHINKANSEN_PROMPT_ORDER=(
	time
	status
	custom
	context
	dir
	)
fi

# PROMPT
if [ ! -n "${SHINKANSEN_PROMPT_CHAR+1}" ]; then
	SHINKANSEN_PROMPT_CHAR="\$"
fi

if [ ! -n "${SHINKANSEN_PROMPT_ROOT+1}" ]; then
	SHINKANSEN_PROMPT_ROOT=true
fi

if [ ! -n "${SHINKANSEN_PROMPT_SEPARATE_LINE+1}" ]; then
	SHINKANSEN_PROMPT_SEPARATE_LINE=true
fi

if [ ! -n "${SHINKANSEN_PROMPT_ADD_NEWLINE+1}" ]; then
	SHINKANSEN_PROMPT_ADD_NEWLINE=true
fi

# STATUS
if [ ! -n "${SHINKANSEN_STATUS_SHOW+1}" ]; then
	SHINKANSEN_STATUS_SHOW=true
fi

if [ ! -n "${SHINKANSEN_STATUS_EXIT_SHOW+1}" ]; then
	SHINKANSEN_STATUS_EXIT_SHOW=false
fi

if [ ! -n "${SHINKANSEN_STATUS_BG+1}" ]; then
	SHINKANSEN_STATUS_BG=green
fi

if [ ! -n "${SHINKANSEN_STATUS_ERROR_BG+1}" ]; then
	SHINKANSEN_STATUS_ERROR_BG=red
fi

if [ ! -n "${SHINKANSEN_STATUS_FG+1}" ]; then
	SHINKANSEN_STATUS_FG=white
fi

# TIME
if [ ! -n "${SHINKANSEN_TIME_SHOW+1}" ]; then
	SHINKANSEN_TIME_SHOW=true
fi

if [ ! -n "${SHINKANSEN_TIME_BG+1}" ]; then
	SHINKANSEN_TIME_BG=white
fi

if [ ! -n "${SHINKANSEN_TIME_FG+1}" ]; then
	SHINKANSEN_TIME_FG=black
fi

# CUSTOM
if [ ! -n "${SHINKANSEN_CUSTOM_MSG+1}" ]; then
	SHINKANSEN_CUSTOM_MSG=false
fi
if [ ! -n "${SHINKANSEN_CUSTOM_BG+1}" ]; then
	SHINKANSEN_CUSTOM_BG=black
fi
if [ ! -n "${SHINKANSEN_CUSTOM_FG+1}" ]; then
	SHINKANSEN_CUSTOM_FG=default
fi

# DIR
if [ ! -n "${SHINKANSEN_DIR_BG+1}" ]; then
	SHINKANSEN_DIR_BG=blue
fi
if [ ! -n "${SHINKANSEN_DIR_FG+1}" ]; then
	SHINKANSEN_DIR_FG=white
fi
if [ ! -n "${SHINKANSEN_DIR_CONTEXT_SHOW+1}" ]; then
	SHINKANSEN_DIR_CONTEXT_SHOW=false
fi
if [ ! -n "${SHINKANSEN_DIR_EXTENDED+1}" ]; then
	SHINKANSEN_DIR_EXTENDED=1
fi

# CONTEXT
if [ ! -n "${SHINKANSEN_CONTEXT_ALWAYS_SHOW+1}" ]; then
	SHINKANSEN_CONTEXT_ALWAYS_SHOW=false
fi
if [ ! -n "${SHINKANSEN_CONTEXT_BG+1}" ]; then
	SHINKANSEN_CONTEXT_BG=black
fi
if [ ! -n "${SHINKANSEN_CONTEXT_FG+1}" ]; then
	SHINKANSEN_CONTEXT_FG=default
fi
if [ ! -n "${SHINKANSEN_CONTEXT_HOSTNAME+1}" ]; then
	SHINKANSEN_CONTEXT_HOSTNAME=%m
fi

# Is SSH?
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
	SHINKANSEN_IS_SSH_CLIENT=true
else
	case $(ps -o comm= -p $PPID) in
	sshd|*/sshd) SHINKANSEN_IS_SSH_CLIENT=true;;
	esac
fi

# ------------------------------------------------------------------------------
# SEGMENT DRAWING
# A few functions to make it easy and re-usable to draw segmented prompts
# ------------------------------------------------------------------------------

CURRENT_BG='NONE'
SEGMENT_SEPARATOR=''

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_segment() {
	local bg fg
	[[ -n $1 ]] && bg="%K{$1}" || bg="%k"
	[[ -n $2 ]] && fg="%F{$2}" || fg="%f"
	if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
	echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
	else
	echo -n "%{$bg%}%{$fg%} "
	fi
	CURRENT_BG=$1
	[[ -n $3 ]] && echo -n $3
}

# End the prompt, closing any open segments
prompt_end() {
	if [[ -n $CURRENT_BG ]]; then
	echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
	else
	echo -n "%{%k%}"
	fi
	echo -n "%{%f%}"
	CURRENT_BG=''
}

# ------------------------------------------------------------------------------
# PROMPT COMPONENTS
# Each component will draw itself, and hide itself if no information needs
# to be shown
# ------------------------------------------------------------------------------

# Context: user@hostname (who am I and where am I)
context() {
	local user="$(whoami)"
	[[ "$user" != "$SHINKANSEN_CONTEXT_DEFAULT_USER" || -n "$SHINKANSEN_IS_SSH_CLIENT" ]] && echo -n "${user}@$SHINKANSEN_CONTEXT_HOSTNAME"
}
prompt_context() {
	local _context="$(context)"
	if [[ $SHINKANSEN_IS_SSH_CLIENT == true ]]; then
		[[ -n "$_context" ]] && prompt_segment $SHINKANSEN_CONTEXT_BG $SHINKANSEN_CONTEXT_FG "$_context"
	elif [[ $SHINKANSEN_CONTEXT_ALWAYS_SHOW == true ]]; then
		[[ -n "$_context" ]] && prompt_segment $SHINKANSEN_CONTEXT_BG $SHINKANSEN_CONTEXT_FG "$_context"
	fi
}


# Custom
prompt_custom() {
	if [[ $SHINKANSEN_CUSTOM_MSG == false ]]; then
		return
	fi

	prompt_segment $SHINKANSEN_CUSTOM_BG $SHINKANSEN_CUSTOM_FG "${SHINKANSEN_CUSTOM_MSG}"
}

# Dir: current working directory
prompt_dir() {
	local dir=''
	local _context="$(context)"
	[[ $SHINKANSEN_DIR_CONTEXT_SHOW == true && -n "$_context" ]] && dir="${dir}${_context}:"

	if [[ $SHINKANSEN_DIR_EXTENDED == 0 ]]; then
		# short directories
		dir="${dir}%1~"
	elif [[ $SHINKANSEN_DIR_EXTENDED == 2 ]]; then
		#long directories
		dir="${dir}%0~"
	else
		#medium directories (default case)
		dir="${dir}%4(c:...:)%3c"
	fi

	prompt_segment $SHINKANSEN_DIR_BG $SHINKANSEN_DIR_FG $dir
}

prompt_time() {
	if [ ! -n "${SHINKANSEN_TIME_DATE_CMD+1}" ]; then
		if [[ $SHINKANSEN_TIME_12HR == true ]]; then
			SHINKANSEN_TIME_DATE_CMD=$(date "+%I:%M:%S %p")
		else
			SHINKANSEN_TIME_DATE_CMD=$(date "+%H:%M:%S")
		fi
	fi

	prompt_segment $SHINKANSEN_TIME_BG $SHINKANSEN_TIME_FG "${SHINKANSEN_TIME_DATE_CMD}"
}

# Status:
# - was there an error?
# - am I root?
# - are there background jobs?
prompt_status() {
	local symbols
	symbols=()
	[[ $RETVAL -ne 0 && $SHINKANSEN_STATUS_EXIT_SHOW != true ]] && symbols+="✘"
	[[ $RETVAL -ne 0 && $SHINKANSEN_STATUS_EXIT_SHOW == true ]] && symbols+="✘ $RETVAL"
	[[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}⚡%f"
	[[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="⚙"

	if [[ -n "$symbols" && $RETVAL -ne 0 ]]; then
		prompt_segment $SHINKANSEN_STATUS_ERROR_BG $SHINKANSEN_STATUS_FG "$symbols"
	elif [[ -n "$symbols" ]]; then
		prompt_segment $SHINKANSEN_STATUS_BG $SHINKANSEN_STATUS_FG "$symbols"
	fi

}

# Prompt Character
prompt_char() {
	local bt_prompt_char
	bt_prompt_char=""

	if [[ ${#SHINKANSEN_PROMPT_CHAR} -eq 1 ]]; then
		bt_prompt_char="${SHINKANSEN_PROMPT_CHAR}"
	fi

	if [[ $SHINKANSEN_PROMPT_ROOT == true ]]; then
		bt_prompt_char="%(!.%F{red}#.%F{green}${bt_prompt_char}%f)"
	fi

	if [[ $SHINKANSEN_PROMPT_SEPARATE_LINE == false ]]; then
		bt_prompt_char="${bt_prompt_char}"
	fi

	echo -n $bt_prompt_char
}

# Prompt Line Separator
prompt_line_sep() {
	if [[ $SHINKANSEN_PROMPT_SEPARATE_LINE == true ]]; then
		# newline wont print without a non newline character, so add a zero-width space
		echo -e '\n%{\u200B%}'
	fi
}

# ------------------------------------------------------------------------------
# MAIN
# Entry point
# ------------------------------------------------------------------------------

build_prompt() {
	RETVAL=$?

	for segment in $SHINKANSEN_PROMPT_ORDER
	do
		prompt_$segment
	done

	prompt_end
}

NEWLINE='
'
PROMPT=''
[[ $SHINKANSEN_PROMPT_ADD_NEWLINE == true ]] && PROMPT="$PROMPT$NEWLINE"
PROMPT="$PROMPT"'%{%f%b%k%}$(build_prompt)'
[[ $SHINKANSEN_PROMPT_SEPARATE_LINE == true ]] && PROMPT="$PROMPT$NEWLINE"
PROMPT="$PROMPT"'%{${fg_bold[default]}%}'
[[ $SHINKANSEN_PROMPT_SEPARATE_LINE == false ]] && PROMPT="$PROMPT "
PROMPT="$PROMPT"'$(prompt_char) %{$reset_color%}'

# Enable running clock (redraw prompt)

TMOUT=1	# redraw interval

TRAPALRM() {
	zle reset-prompt 2&> /dev/null > /dev/null
}
