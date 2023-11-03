# Searches and replaces for text in all files in the current folder
function log --description "git commit browser. uses fzf"
    # todo add "$argv" in there without breaking the no-argv case.
    git log --graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" | fzf --ansi --no-sort --reverse --tiebreak=index --toggle-sort=\` --bind "ctrl-m:execute:
                echo '{}' | grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R'"
end

function ftext
    # -i case-insensitive
    # -I ignore binary files
    # -H causes filename to be printed
    # -r recursive search
    # -n causes line number to be printed
    # optional: -F treat search term as a literal, not a regular expression
    # optional: -l only print filenames and not the matching lines ex. grep -irl "$1" *
    grep -iIHrn --color=always "$argv" . | less -r
end

# replace text recursively
function rrptext
    find . -type f -exec sed -i "s/$argv[1]/$argv[2]/g" {} +
end

#replace text for indivisual files
function rptext
    sed -i -- "s/$argv[2]/$argv[3]/g" $argv[1]
end

function cpp
    # set -e
    strace -q -ewrite cp -- "$argv[1]" "$argv[2]" 2>&1 \
        | awk '{
  count += $NF
  if (count % 10 == 0) 
    percent = count / total_size * 100
    printf "%3d%% [", percent
    for (i=0;i<=percent;i++)
      printf "="
      printf ">"
      for (i=percent;i<100;i++)
        printf " "
        printf "]\r"
      end
      }
      END { print "" }' total_size="$(stat -c '%s' "$argv[1]")" count=0
end

function reload --description 'Reloads shell (i.e. invoke as a login shell)'
    exec $SHELL -l
end


#make md look go by cuting unnecesery content
# it only cut from start to the text --start and from text --end to the end
function trimstart
    set start (grep -in "\-\-start" $argv | head -n 1 | cut -d':' -f1)
    set startd "$start"d
    set fstart "1, $startd"
    sed -i "$fstart" $argv
end

function trimend
    set end (grep -in "\-\-end" $argv | head -n 1 | cut -d':' -f1)
    set fend "$end, \$d"
    sed -i "$fend" $argv
end

function trimmd
    trimstart $argv
    trimend $argv
end

function trimallmd
    find . -type f -name "*.md" | while read -l mds
        trimstart $mds
        trimend $mds
    end
end
#remove all empty lined
function noemptylines
    sed -i '/^$/d' $argv
end

#remove all whitespaces at the end of lines
function nowspace
    sed -i 's/[[:blank:]]*$//g' $argv
end

function remove-dupl
    # remove duplicate files
    set dir (pwd)
    set Bash "$HOME/.config/fish/bash"
    chmod 700 $Bash/remove-dupl.sh
    $Bash/remove-dupl.sh $dir
end


# Copy and go to the directory
function cpg
    if [ -d "$2" ]
        then
        cp "$1" "$2" && cd "$2"
    else
        cp "$1" "$2"
    end
end

# Move and go to the directory
function mvg
    if [ -d "$2" ]
        then
        mv "$1" "$2" && cd "$2"
    else
        mv "$1" "$2"
    end
end

# show the path of file or dir
function copypath --description "Copy full file path"
    # readlink -e $argv #| xclip -sel clip
    readlink -e $argv | termux-clipboard-set
    echo "copied to clipboard"
end

# Create and go to the directory
function mkdirg
    mkdir "$argv"
    cd "$argv"
end

# Goes up a specified number of directories  (i.e. up 4)
function up
    set d ""
    set limit $argv[1]
    set --erase argv[1]
    for i in (seq 1 $limit)
        # set d "$d/"
        set d "$d/"".."
    end
    set d $(echo $d | sed 's/^\///')
    if [ -f "$d" ]
        set d ".."
    end
    cd $d
end


# Returns the last 2 fields of the working directory
function pwdtail
    pwd | awk -F/ '{nlast = NF -1;print $nlast"/"$NF}'
end

function match -d "check if string contain substring"
    if string match -q "*$argv[1]*" $argv[2]
        echo "$argv[1] was found"
    else
        echo "$argv[1] was not found"
    end
end


function sedmatch -d "check string matches with sed"
    if [ -n "(sed -n "/$argv[1]/p" > $argv[2])" ]

        echo "$argv[1] was found"

    else
        echo "$argv[1] was not found"

    end
end


# github
function setupgit
    git config --global user.name "$argv[1]"
    git config --global user.email "$argv[2]"
    #store credential in cache 
    # security flow !
    git config --global credential.helper cache
    # check existing ssh key
    # ls -al ~/.ssh
    # generate new key
    ssh-keygen -t ed25519 -C "$argv[1]"

    #start ssh agent
    eval (ssh-agent -c)
    # private ssh key ssh agent
    ssh-add ~/.ssh/id_ed25519
    echo "copy the the following public key to make personal access token in github"
    echo "at https://github.com/settings/ssh/new"
    echo \n
    cat ~/.ssh/id_ed25519.pub
    echo "to auth with github make sure to add the the remote url as ssh url like:"
    echo "git remote add origin git@github.com:githubUserName/repoName.git"
end

function setupgit2
    git config --global user.name "$argv[1]"
    git config --global user.email "$argv[2]"
    #store credential in cache 
    # security flow !
    git config --global credential.helper cache
    #start ssh agent
    eval (ssh-agent -c)
    # private ssh key ssh agent
    ssh-add ~/.ssh/id_ed25519
end
# is it a `main` or a `master` repo?
function gitmainormaster
    git branch --format '%(refname:short)' --sort=-committerdate --list master main | head -n1
end

function main
    git checkout (gitmainormaster)
end
function master
    main
end

function gst
    git status
end

function githistory -d "list of all git repo commits piped into fzf"
    git log --oneline --graph --color=always | nl | fzf --ansi --track --no-sort --layout=reverse-list
end
function gcom
    git add .
    git commit -m "$argv"
end

function hfzf -d "fuzzy search the command history"
    history | fzf --no-sort --border sharp
end
function lazyg
    git add .
    git commit -m "$argv"
    git push
end

function gcl
    git clone
end
# run hugo server
function hug
    # hugo server -F --bind=127.0.0.0:8844 -p=8844 --baseURL=http://127.0.0.0:8844
    hugo server -F --bind=127.0.0.0 -p=8844 --baseURL=http://127.0.0.0:8844
end

# encrypt files with gnupg

function encrypt
    gpg --batch --output $argv[1].gpg --passphrase $argv[2] --symmetric $argv[1]
    echo "$argv[1] encrypted successfully"
end

#decrypt files with gnugp

function decrypt
    gpg --batch --output (string replace ".gpg" "" $argv[1]) --passphrase $argv[2] --decrypt $argv[1]
    echo "$argv[1] decrypted successfully"
end

# Function for extracting different files
function ext
    switch $argv
        case *.tar.bz2
            tar xjf $argv

        case *.tar.gz
            tar xzf $argv

        case *.bz2
            bunzip2 $argv

        case *.rar
            unrar x $argv

        case *.gz
            gunzip $argv

        case *.tar
            tar xf $argv

        case *.tbz2
            tar xjf $argv

        case *.tgz
            tar xzf $argv

        case *.zip
            unzip $argv

        case *.Z
            uncompress $argv

        case *.7z
            7z x $argv

        case *.deb
            ar x $argv

        case *.tar.xz
            tar xf $argv

        case *.tar.zst
            unzstd $argv

        case *
            echo "'$argv' cannot be extracted via ex"

    end
    set_color normal
end

# Get week number
function week
    date +%V
end

# obsidisn related functions

function ctd -d "clean completed todo"
    sed -i "/[x]/d" "$obsidian/todo 📝.md"
    #remove emptylines
    # sed -i '/^$/d' "$obsidian/todo 📝.md"
    #replace multiple emtpy line with on empty line
    sed -i '/^$/N;/^\n$/D' "$obsidian/todo 📝.md"
    cat "$obsidian/todo 📝.md"
end

function td --description "Add to todo list"
    echo -e "\n- [ ] $argv" >>"$obsidian/todo 📝.md"
    cat "$obsidian/todo 📝.md"

end


function gtd --description 'view todo list'
    cat "$obsidian/todo 📝.md"
end

function color --description "Print color"
    echo (set_color (string trim -c '#' "$argv"))"██"
end

function tdck -d "check todo task"
    if test $argv = ""
        echo "please type text from your note!"
        return
    end
    for todo in $argv
        set linenumber (grep -in $todo "$obsidian/todo 📝.md"  | cut -d':' -f1)
        # replace text at that specific
        sed -i ""$linenumber"s/\[ \]/\[x\]/" "$obsidian/todo 📝.md"
        set noteline (sed -n {$linenumber}p "$obsidian/todo 📝.md")
        echo \n "the task is checked 🏁"
        echo $noteline
    end
end

function run --description "Make file executable, then run it"
    chmod +x "$argv"
    eval "./$argv"
end


function b --description "Exec command in bash. Useful when copy-pasting commands with imcompatible syntax to fish "
    bash -c "$argv"
end



function qr --description "Prints QR. E.g. super useful when you need to transfer private key to the phone without intermediaries `cat ~/.ssh/topsecret.pem | qr`"
    cls
    # -t determine the output format for stdout better use ansi, ansi256, ansiutf8, utf8 the default is png
    if [ "$argv" = "" ]
        echo "Please give input file or string value"
        # qrencode --background=00000000 --foreground=FFFFFF -t ansi -o -
        return
    else
        printf "$argv" | qrencode --background=00000000 --foreground=FFFFFF -t ansi -o -
    end
end

# alias sharewifi='qr "WIFI:T:WPA;S:aaa;P:bbb;;"'

function bak --description "Copies (backups) file in same folder with .bak extension"
    cp -i "$argv" "$argv.bak"
end

#obsidian

# go to obsidian vault directory


function obs
    cd $obsidian
    echo "you are now in your obsidian vault 🌙"
end

function obsClean
    rm -r $obsidian/.trash
end

function obsRestore
    cp -r $phone/obsidian_bakcup/* $documents
end

function obsbak
    rm -r $phone/obsidian_bakcup/
    mkdir $phone/obsidian_bakcup
    cp -r $obsidian $phone/obsidian_bakcup
end

function obsBakdots
    set dir (pwd)
    cd $obsidian
    tar -cf ../obsidian.tar .obsidian
    cd $dir
end

function obsResdots
    set dir (pwd)
    cd $obsidian
    cd ..
    cp obsidian.tar ob.tar
    tar -xf ob.tar
    rm -rf $obsidian/.obsidian
    mv .obsidian $obsidian
    rm ob.tar
    cd $dir
end

abbr -ag obrs obsResdots

# get package urls to download for offline
function pkgurl
    apt --print-uris install $argv >out
    cat out | grep http | tr -d \' | awk '{print $1}' >deblist
    rm out
    echo "the pkg(s) url(s) are listed in deblist"
end

function pkgdown
    apt --print-uris install $argv >out
    cat out | grep http | tr -d \' | awk '{print $1}' >deblist
    rm out
    echo "the pkg(s) url(s) are listed in deblist"

    for line in (cat ./deblist)
        curl -O $line
    end
end


function pkglist -d "open packages list file"
    vi $HOME/../usr/var/lib/apt/lists/packages-cf.termux.dev_apt_termux-main_dists_stable_main_binary-arm_Packages
end

function genbulk
    while true
        # echo "dep: dont know" >> bulk.txt
        echo $argv >>bulk.txt
    end
end



function getdeps
    dbn $argv >dbn.txt
    #remove the first line
    sed -i 1d dbn.txt
    sed -i /Recommends/d dbn.txt
    sed -i /Suggests/d dbn.txt
    sed -i /Replaces/d dbn.txt
    sed -i /Breaks/d dbn.txt
    sed -i "s/Depends://" dbn.txt
    # remove tags 
    sed -i -E "s/\((.*?)\)//g" dbn.txt
    #remove white space at the start of the lines
    sed -i 's/^[[:blank:]]*//g' dbn.txt
    #replace newline with space
    sed -i ':a;N;$!ba;s/\n/ /g' dbn.txt
    set pkgslist (cat dbn.txt)
    echo $pkgslist
    rm dbn.txt
end


function getlog
    cp /data/data/com.termux/files/usr/var/log/apt/term.log ./
end
function extdebs -d "extract packges names from log file"
    sift "_(.*?).deb" $argv[1] >deb.txt
    sed -i "s/Preparing to unpack ...\///g" deb.txt
    sed -i "s/archives\///g" deb.txt
    sed -i "s/apt\///g" deb.txt
    sed -i "s/_.*//g" deb.txt
    #use this in nvim replace to cut some starting digits
    #:%s/^\d*-//
    # you can use the in nvim replace to get the
    # name without extention and tag
    # # %s/_.*//
end

function spinner
    echo " The proccess is running"
    while true
        for X in - / '|' '\\'
            # echo -en "\b$X";
            echo -en "\b$X"
            sleep 0.1
        end
    end
end

function toggleship -d "switch on and off starship theme"
    if test -f "$HOME/.config/fish/functions/fish_prompt.fish.bak"
        mv "$HOME/.config/fish/functions/fish_prompt.fish.bak" "$HOME/.config/fish/functions/fish_prompt.fish"
    else if test -f "$HOME/.config/fish/functions/fish_prompt.fish"
        mv "$HOME/.config/fish/functions/fish_prompt.fish" "$HOME/.config/fish/functions/fish_prompt.fish.bak"
    end
end

function freshstart
    app pkgUpdate neovim fzf eza lua make zip \
        tree git sift bat fd
end


function gpass -d "cheap password manager"
    set passfile $phone/Aaaa/bitward.csv
    set linenumber (grep -in $argv[1] $passfile | cut -d':' -f1)
    if test -z $linenumber
        echo "entery not exist!"
        return
    else if test -z $argv
        echo "Please Enter username or email adress!"
        return
    end
    set 2dentry (sed -n {$linenumber[2]}p $passfile)
    if string match -q "*$argv[1]*" $2dentry
        if string length -q $argv[2]
            for k in $linenumber
                if string match -q "*$argv[2]*" (sed -n {$k}p $passfile)
                    set passline (sed -n {$k}p $passfile)
                    set passArray
                    for i in (string split ","  $passline)
                        set passArray $passArray $i
                    end
                    echo \n
                    echo " Link:    $passArray[4]"
                    echo " Email:    $passArray[9]"
                    echo " Password:    $passArray[10]"
                    echo " email@password"
                    echo " $passArray[9]@$passArray[10]"
                    echo \n
                end
            end
        else

            for j in $linenumber
                set passline (sed -n {$j}p $passfile)
                set passArray
                for i in (string split ","  $passline)
                    set passArray $passArray $i
                end
                echo \n
                echo " Link:    $passArray[4]"
                echo " Email:    $passArray[9]"
                echo " Password:    $passArray[10]"
                echo " email@password"
                echo " $passArray[9]@$passArray[10]"
                echo \n
            end
        end
    else
        echo not
        set passline (sed -n {$linenumber}p $passfile)
        set passArray
        for i in (string split ","  $passline)
            set passArray $passArray $i
        end
        echo \n
        echo "Link:    $passArray[4]"
        echo "Email:    $passArray[9]"
        echo "Password:    $passArray[10]"
        echo "email@password"
        echo "$passArray[9]@$passArray[10]"
        echo \n
    end
end

function cfont -d "change termux font"
    rm $HOME/.termux/font.ttf
    cp -R $argv $fon
end

function ctheme -d "change termux theme"
    # rm $HOME/.termux/colors.properties
    cp -Rf $argv $HOME/.termux/colors.properties
end


function tertheme -d "change termux theme with fuzzy finder"
    set themedir $HOME/.stuff/termux-themes
    set selectedTheme ( ls -I "*.txt" $themedir  | fzf --border rounded --border-label="Termux Themes")
    if test -z $selectedTheme
        echo "no theme selected"
        return
    end
    set selectednoprop (string replace ".properties" "" $selectedTheme)
    echo "successfully selected $selectednoprop"
    rm -fR $HOME/.termux/colors.properties
    ctheme $themedir/$selectedTheme
    termux-reload-settings
    # cm (fzf --preview='head -$LINES {}' ls)
end
