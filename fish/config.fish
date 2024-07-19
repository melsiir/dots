
source ~/.config/fish/aliases.fish
# source ~/.config/fish/test.fish
source ~/.config/fish/functions.fish
source ~/.config/fish/web.fish
# source ~/.config/fish/onDemand/svgExtractor.fish
source ~/.config/fish/onDemand/offline.fish
# colors for echo
# replace e with cap E to bold
set RC '\e[0m'
set RED '\e[31m'
set YELLOW '\e[33m'
set GREEN '\e[32m'
set bold '\033[1m'
set origin '\033[0m'
set black '\E[30;1m'
set red '\E[31;1m'
set green '\E[32;1m'
set yellow '\E[33;1m'
set blue '\E[34;1m'
set magenta '\E[35;1m'
set cyan '\E[36;1m'
set white '\E[37;1m'
#use like so 
#echo -e $GREEN"string$RC"
#echo -e "$GREEN\e string$RC"
#echo -e "$GREEN string$RC"



# if status is-interactive
# Commands to run in interactive sessions can go here
set fish_greeting ""
set -gx TERM xterm-256color

# customization for bobthefish

# To have colors for ls and all grep commands such as grep, egrep and zgrep
# set -x CLICOLOR 1
# set -x LS_COLORS (vivid generate one-dark)
#set -x LS_COLORS 'no=00:fi=00:di=00;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:*.xml=00;31:'

# # set -x BAT_THEME Dracula

#chris titus
# Color for manpages in less makes manpages a little easier to read
set -x LESS_TERMCAP_mb $(printf '\e[01;31m')
set -x LESS_TERMCAP_md $(printf '\e[01;31m')
set -x LESS_TERMCAP_me $(printf '\e[0m')
set -x LESS_TERMCAP_se $(printf '\e[0m')
set -x LESS_TERMCAP_so $(printf '\e[01;44;33m')
set -x LESS_TERMCAP_ue $(printf '\e[0m')
set -x LESS_TERMCAP_us $(printf '\e[01;32m')

# set -lx LESS '-rsF -m +Gg'

command -qv nvim && alias vim nvim
set -gx EDITOR nvim
function edit
    echo "$EDITOR is currently set as your default editor. If you want to change it, then edit the fish config file at $HOME/.config/fish/config.fish"
    $EDITOR
end

abbr -ag nv nvim
abbr -ag v vim

set -gx PATH bin $PATH
set -gx PATH ~/bin $PATH
set -gx PATH ~/.local/bin $PATH
# NodeJS
set -gx PATH node_modules/.bin $PATH

set -gx JAVA_HOME /data/data/com.termux/files/usr
set -gx PATH /data/data/com.termux/files/home/.local/apache-maven-3.6.0/bin $PATH
set -gx PATH $HOME/.gradle/wrapper/dists/gradle-8.7-bin/bhs2wmbdwecv87pi65oeuq5iu/gradle-8.7/bin $PATH
#  storage
set -gx phone /storage/emulated/0
set -gx sdcard $HOME/storage/external-1
set -gx documents /storage/emulated/0/Documents
set -gx downloads /storage/emulated/0/Download
set -gx obsidian /storage/emulated/0/Documents/My\ obsidian

#: `fzf` defaults configuration.
# set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude ".git" --exclude node_modules --exclude ".ccls-cache" --exclude ".output" --exclude "*/storage/shared/Android/*" --exclude "*WhatsApp/*" --exclude "*ReadEra/*" --exclude "*.recycle/*" --exclude ".obsidian/*"  --exclude "*storage/shared/*"'
# set -gx FZF_DEFAULT_OPTS '--height 40% --layout=reverse --border'
# set -gx FZF_ALT_C_COMMAND 'fd -H -t d'


# FZF options
# set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git --exclude node_modules'
# set fzf_history_opts --sort --exact --history-size=30000
# set fzf_fd_opts --hidden --follow --exclude=.git
# set fzf_preview_dir_cmd eza -la --git --group-directories-first --icons --color=always
# set fzf_directory_opts --bind "ctrl-o:execute($EDITOR {} &> /dev/tty)"




# doc links
function cheatsheet
    if test $argv = linux
        vi $HOME/.config/fish/doc/linux_cheatsheet.txt
    else if test $argv = fish
        vi $HOME/.config/fish/doc/fish_cheatsheet.txt
    end
end

function dots
    cd $HOME/.config
end
# end

# pnpm
set -gx PNPM_HOME "/data/data/com.termux/files/home/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
