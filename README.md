# <img src="http://rawgit.com/bharadwaj-raju/shinkansen-zsh-theme/master/img/icon.png" height="40px" width="40px" /> Shinkansen zsh theme

Shinkansen is a ZSH (Z Shell) theme.

It aims for simplicity and minimalism, showing only minimal information.

It is *not* a fancy git/rails/python/etc. info prompt.
It is just a prompt, useful nevertheless.

Shinkansen is [customizable](#customization) and [extensible](#custom-segments-and-extensions).

It currently shows:
- A *running* clock (24-hour or 12-hour, or [custom `date` command](#time))
- Current directory
- Background jobs
- Exit code of last command

For a tmux theme to work with it, I suggest [Maglev](https://github.com/caiogondim/maglev).

## Preview

![Preview](http://raw.github.com/bharadwaj-raju/shinkansen-zsh-theme/master/img/preview.gif)


## Requirements

In order to use the theme, you will first need:

- Powerline compatible fonts like [Vim Powerline patched fonts](https://github.com/Lokaltog/powerline-fonts), [Input Mono](http://input.fontbureau.com/) or [Monoid](http://larsenwork.com/monoid/).
- ZSH

Make sure terminal is using 256-colors mode with `export TERM="xterm-256color"`

For [iTerm 2](http://iterm2.com/) users, make sure you go into your settings and set both the regular font and the non-ascii font to powerline compatible [fonts](https://github.com/powerline/fonts) or the prompt separators and special characters will not display correctly.

## Installation

Download [shinkansen.zsh-theme](https://raw.github.com/bharadwaj-raju/shinkansen-zsh-theme/master/shinkansen.zsh-theme) (*Right-click* → *Save link as*) to a convenient location.

Simply:

```bash
source /path/to/shinkansen.zsh-theme
```

That's it.

You can also use it with Zplug, Zgen, oh-my-zsh, prezto or whatever plugin manager you use.

## Options

Shinkansen is configurable. You can change colors, the segment order, add custom segments and which segments you want
or don't want to see. All options must be overridden in your `.zshrc` file.

### Order
`SHINKANSEN_PROMPT_ORDER` defines order and enable/disable of prompt segments. Use zsh array
syntax to specify your own order, e.g:

```bash
SHINKANSEN_PROMPT_ORDER=(
	time
	status
	custom
	context
	dir
)
```

(That was the default.)

### Custom segments and extensions

Add the segment's name to `SHINKANSEN_PROMPT_ORDER` as follows:

```bash
SHINKANSEN_PROMPT_ORDER=(
	time
	status
	custom
	context
	dir
	sayhello
)

```
Create a function as follows:

```bash
prompt_sayhello() {
	prompt_segment yellow blue "hello"
}
```

The naming rule for such functions is `prompt_` + the segment's name.

*NOTE:* Such functions should be defined *before* the `source` or enabling of the plugin.

That's it.

### Built-in segment customization

See below for each one's options.

Set the value of each option-variable *before* the `source` part or before enabling the plugin.

#### Prompt

| Variable                         | Default | Meaning
|----------------------------------|---------|-------------------------------------------------|
|`SHINKANSEN_PROMPT_CHAR`          | `\$`    | Character to be show before any command
|`SHINKANSEN_PROMPT_ROOT`          | `true`  | Highlight if running as root
|`SHINKANSEN_PROMPT_SEPARATE_LINE` | `true`  | Make the prompt span across two lines
|`SHINKANSEN_PROMPT_ADD_NEWLINE`   | `true`  | Adds a newline character before each prompt line


#### Status

- The exit code of the last command.
- Am I root?
- Are there any background jobs?

| Variable                       |Default|Meaning
|--------------------------------|-------|-------
|`SHINKANSEN_STATUS_EXIT_SHOW`   |`false`|Show/hide exit code of last command
|`SHINKANSEN_STATUS_BG`          |`green`|Background color
|`SHINKANSEN_STATUS_ERROR_BG`    |`red`  |Background color of segment when last command exited with an error
|`SHINKANSEN_STATUS_FG`          |`black`|Foreground color

#### Time

The running clock.

|Variable                        |Default                                      |Meaning
|--------------------------------|--------------------------------------------|----------------------------------------|
|`SHINKANSEN_TIME_DATE_CMD`|`date +%H:%M:%S` (24hr) or `date "+%I:%M:%S %p"` (12hr)|Instead of default, use a custom command for time
|`SHINKANSEN_TIME_12HR`|`false`|Format time using 12-hour clock (am/pm)
|`SHINKANSEN_TIME_BG`|`white`|Background color
|`SHINKANSEN_TIME_FG` |`black`|Foreground color

#### Custom

A custom message, empty by default.

|Variable|Default|Meaning
|--------|-------|-------|
|`SHINKANSEN_CUSTOM_MSG`|`false`|Free segment you can put a custom message
|`SHINKANSEN_CUSTOM_BG`|`black`|Background color
|`SHINKANSEN_CUSTOM_FG`|`black`|Foreground color

#### Context

`user@hostname`, displayed if running over SSH.

|Variable|Default|Meaning
|--------|-------|-------|
|`SHINKANSEN_CONTEXT_DEFAULT_USER`|none|Default user. If you are running with other user other than default, the segment will be showed.
|`SHINKANSEN_CONTEXT_HOSTNAME`|`%m`|Hostname. Set %M to display the full qualified domain name.
|`SHINKANSEN_CONTEXT_ALWAYS_SHOW`|`false`|If `true`, the segment will be always on, regardless of SSH/no SSH.
|`SHINKANSEN_CONTEXT_BG`|`black`|Background color
|`SHINKANSEN_CONTEXT_FG`|`default`|Foreground color

#### Dir

Current directory.

|Variable|Default|Meaning
|--------|-------|-------|
|`SHINKANSEN_DIR_CONTEXT_SHOW`|`false`|Show user and machine in an SCP formatted style
|`SHINKANSEN_DIR_EXTENDED`|`1`|Extended path (0=short path, 1=medium path, 2=complete path, everything else=medium path)
|`SHINKANSEN_DIR_BG`|`blue`|Background color
|`SHINKANSEN_DIR_FG`|`white`|Foreground color


## Contributors

This project is a fork from [caiogondim/bullet-train-oh-my-zsh-theme](https://github.com/caiogondim/bullet-train-oh-my-zsh-theme).

*That* project was originally a fork from
[Powerline](https://github.com/jeremyFreeAgent/oh-my-zsh-powerline-theme), but
most of the code was later erased and its now more closely related to
[Agnoster](https://gist.github.com/agnoster/3712874).

See [Contributors](https://github.com/bharadwaj-raju/shinkansen-zsh-theme/graphs/contributors).

## Credits

This theme's code is based on [caiogondim/bullet-train-oh-my-zsh-theme](https://github.com/caiogondim/bullet-train-oh-my-zsh-theme).

This theme is highly inspired by the following themes:
- [Powerline](https://github.com/jeremyFreeAgent/oh-my-zsh-powerline-theme)
- [Agnoster](https://gist.github.com/agnoster/3712874)

This theme uses

## License
The MIT License (MIT)

Copyright (c) 2014-2015 [Caio Gondim](http://caiogondim.com)

Copyright (c) 2016 [Bharadwaj Raju](https://github.com/bharadwaj-raju)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
