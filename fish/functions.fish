# Searches and replaces for text in all files in the current folder
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

function copyClip -d "copy content to clipboard"
    if test (count $argv) -eq 0
        termux-clipboard-set
    else
        if test -f $argv[1]
            termux-clipboard-set <$argv
        else
            termux-clipboard-set $argv
        end

    end
end

function reload --description 'Reloads shell (i.e. invoke as a login shell)'
    exec $SHELL -l
end

function linkbin -d "link .config/bin to .local/bin"
    mkdir -p ~/.local/bin
    ln -sf ~/.config/bin/* ~/.local/bin/
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

function trimmd -d "trim unnecesery content from markdown"
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
function nowspace -d "remove all whitespaces at the end of lines"
    sed -i 's/[[:blank:]]*$//g' $argv
end

function remove-dupl -d "remove duplicate files"
    # remove duplicate files
    set dir (pwd)
    remove-duplicate $dir
end


# Copy and go to the directory
function cpg -d "Copy and go to the directory"
    if test -d "$argv[2]"
        cp "$argv[1]" "$argv[2]" && cd "$argv[2]"
    else
        cp "$argv[1]" "$argv[2]"
    end
end

# Move and go to the directory
function mvg -d "Move and go to the directory"
    if test -d "$argv[2]"
        mv "$argv[1]" "$argv[2]" && cd "$argv[2]"
    else
        mv "$argv[1]" "$argv[2]"
    end
end

# show the path of file or dir
function copypath --description "Copy full file path"
    # readlink -e $argv #| xclip -sel clip
    readlink -e $argv | copyClip
    echo "copied to clipboard"
end

# Create and go to the directory
function mkdirg -d "make directory and cd to it"
    mkdir "$argv"
    cd "$argv"
end

function mkdirmv -d "make directory and move files into it"
    if test -z $argv[2]
        echo "please enter files or directories you want to move"
        return
    end
    mkdir $argv[-1]
    mv $argv[1..-2] $argv[-1]
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

# generate new ssh intity
function gen-ssh
    ssh-keygen -f ~/.ssh/$argv -C "$argv"
    echo "Host $argv" >>~/.ssh/config
    echo " HostName __IP__" >>~/.ssh/config
    echo " ForwardAgent yes" >>~/.ssh/config
    echo " PreferredAuthentications publickey" >>~/.ssh/config
    echo " IdentityFile ~/.ssh/$argv" >>~/.ssh/config
    echo "" >>~/.ssh/config
    # vim ~/.ssh/config
end

# github
function gitssh -d "generate and add ssh key to github"
    set -l gitName "$argv[1]"
    set -l gitEmail "$argv[2]"
    #set git name and email
    if test (count $argv) -le 1
        set -l gitConfigName (git config --global --get user.name)
        set -l gitConfigEmail (git config --global --get user.email)
        if test -z $gitConfigName
            read --prompt "echo ' Enter your name: ' " -l gitName
            read --prompt "echo ' Enter your email: ' " -l gitEmail
            git config --global user.name $gitName
            git config --global user.email $gitEmail
        else
            set gitName $gitConfigName
            set gitEmail $gitConfigEmail
        end
    else
        # if supplied as argument set them from 
        git config --global user.name $gitName
        git config --global user.email $gitEmail
    end
    #store credential in cache 
    # security flow !
    git config --global credential.helper cache

    set -l keyName github
    if test -f ~/.ssh/$keyName
        #if there already key just use it
        #start ssh agent
        eval (ssh-agent -c)
        # private ssh key ssh agent
        ssh-add ~/.ssh/$keyName
    else
        # generate new key
        ssh-keygen -f ~/.ssh/$keyName -t ed25519 -C $gitEmail

        # printf "%s\n" \
        #     "Host github.com" \
        #     "  IdentityFile ~/.ssh/$keyName" \
        #     "  LogLevel ERROR" >>~/.ssh/config

        #start ssh agent
        eval (ssh-agent -c)
        # private ssh key ssh agent
        ssh-add ~/.ssh/$keyName
        echo "copy the the following public key to make personal access token in github"
        copyClip ~/.ssh/$keyName.pub
        echo -e "$GREEN\e the public key copyed to your clipboard$RC"
        echo "now goto this link and create new access token"
        open "https://github.com/settings/ssh/new"
        echo
        echo "to test your ssh key connection run the following command"
        echo
        echo -e "$GREEN\e ssh -T git@github.com$RC"
        echo
        echo "if you connecting with key for the first time"
        echo "you may get a warrning message just type yes"
        echo "if got error says pubkey not autherized re add the the keyfile to the ssh-agent"
    end
    echo "to auth with github make sure to add the the remote url as ssh url like:"
    echo "git remote add origin git@github.com:githubUserName/repoName.git"
end

function dg
    set -l repoPath (string replace "https://" "" "$argv[1]")
    set -l splitPath (string split "/" $repoPath)
    set -l auther $splitPath[2]
    set -l repository $splitPath[3]
    set -l branch $splitPath[5]
    set -l rootName $splitPath[-1]
    set -l urlPrefix "https://api.github.com/repos/$author/$repository/contents/"
    set -l urlPostfix "?ref=$branch"


end

# print repo remote urls
function giturl
    git remote get-url --all origin $argv
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
    git clone $argv
end
function get -d "download with curl"
    set -l github_bolb "^(https?:\/\/)?github\.com([\/\w\?=.-]*)/blob/([\/\w\?=.-]*)"
    set -l github_raw "^(https?:\/\/)?github\.com([\/\w\?=.-]*)/raw/([\/\w\?=.-]*)"
    set -l github_clone "^(https?:\/\/)?github\.com([\/\w\?=.-]*)"
    if string match -q --regex $github_bolb $argv[1]
        set -l dn $argv
        set dn (string replace "/blob/" "/raw/" $argv)
        curl -LJO $dn
    else if string match -q --regex $github_raw $argv[1]
        curl -LJO $argv
    else if string match -q --regex $github_clone $argv[1]
        git clone $argv
    else
        curl -LJO $argv
    end
end


function gitlog --description "git commit browser. uses fzf"
    # todo add "$argv" in there without breaking the no-argv case.
    git log --graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" | fzf --ansi --no-sort --reverse --tiebreak=index --toggle-sort=\` --bind "ctrl-m:execute:
                echo '{}' | grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R'"
end

function opm -d "open md documents"
    if test -f README.md
        open README.md
    else
        open *.md
    end
end

function o
    set -l files (fzf)
    # set -l files (fzf --print0 --preview "bat --theme ansi --color always {}")
    if test -z "$files"
        return
    end
    echo -n "$files" | xargs -0 -o "$EDITOR"
end

function getExt -d "get file extension"
    set -l ext (string split "." $argv[1])[-1]
    return $ext
end
# run hugo server
function hug
    # hugo server -F --bind=127.0.0.0:8844 -p=8844 --baseURL=http://127.0.0.0:8844
    hugo server -F --bind=127.0.0.0 --baseURL=http://127.0.0.0
end

function hs -d "start hugo development server"
    # -D include drafts 
    hugo server -D $argv
end

function draft -d "write drafts for later usage"
    if test (count $argv) -eq 0
        vi ~/.draft/draft
    else
        printf "$argv\n\n" >>~/.draft/draft
    end
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

function zd -d "list files in dir quickly"
    set -l finds (fd --type directory --max-depth 5)

    if [ -z "$finds" ]
        return 0
    end

    set -l fzf_selection (printf '%s\n' $finds | fzf)

    if [ -n "$fzf_selection" ]
        cd $fzf_selection && eza --grid --all --classify --icons
    else
        return 0
    end
end

function zipall -d "compress all file in this dir"
    if test (count $argv) -eq 0
        set archiveName (string split "/" (pwd))[-1]
    else
        set archiveName $argv
    end
    zip -r $archiveName *
end

function extract -d "extracting different files"
    switch $argv
        case "*.tar.bz2"
            tar xjf $argv

        case "*.tar.gz"
            tar xzf $argv

        case "*.bz2"
            bunzip2 $argv

        case "*.rar"
            unrar x $argv

        case "*.gz"
            gunzip $argv

        case "*.tar"
            tar xf $argv

        case "*.tbz2"
            tar xjf $argv

        case "*.tgz"
            tar xzf $argv

        case "*.zip"
            unzip $argv

        case "*.Z"
            uncompress $argv

        case "*.7z"
            7z x $argv

        case "*.deb"
            ar x $argv

        case "*.tar.xz"
            tar xf $argv

        case "*.tar.zst"
            unzstd $argv

        case "*"
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
        if test -e $argv
            cat $argv | qrencode --background=00000000 --foreground=FFFFFF -t ansi -o -
        else
            printf "$argv" | qrencode --background=00000000 --foreground=FFFFFF -t ansi -o -
        end
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

function obsBakdots -d "backup obsidian dotfiles"
    pushd $obsidian
    zip -r ../obsidian.zip .obsidian
    popd
end

function obsResdots -d "restore obsidian dotfiles"
    pushd $obsidian/..
    cp obsidian.zip ob.zip
    unzip ob.zip
    rm -rf $obsidian/.obsidian
    mv .obsidian $obsidian
    rm ob.zip
    popd
end

abbr -ag obrs obsResdots

# get package urls to download for offline
function pkgurl
    apt-get --print-uris install $argv >out
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


function getlog -d "get the package installtion histort"
    cp /data/data/com.termux/files/usr/var/log/apt/term.log ./
    extdebs ./term.log
    # rm ./term.log
end
function extdebs -d "extract packges names from log file"
    # sift "_(.*?).deb" $argv[1] >deb.txt
    grep -E "_(.*?).deb" $argv[1] >deb.txt
    # grep -E "_(.*?).deb|Setting up" $argv[1] >deb.txt
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
    set pid $last_pid
    echo " The proccess is running"
    while true
        # for X in ⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏
        for X in - / '|' '\\'
            echo -en "\b$X"
            sleep 0.1
        end
    end
end
function sp
    $argv & set PID $last_pid

    echo " The proccess is running"
    while kill -0 $PID 2>/dev/null
        for X in ⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏
            # for X in - / '|' '\\'
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
    linkbin
    # cp $HOME/.config/bin/* $HOME/.local/bin/
    set -xU repo /storage/0A56-1B19/backup/Termux
    app pkgUpdate
    mkdir -p temp
    #    apt -f install
    # dpkg --configure util-linux
    cp $repo/offline-repo/pkgUpdate/libsmartcols_*.deb ./temp
    cp $repo/offline-repo/pkgUpdate/termux-tools_*.deb ./temp
    cp $repo/offline-repo/pkgUpdate/util-linux_*.deb ./temp
    dpkg -i ./temp/libsmartcols_*.deb
    dpkg -i ./temp/util-linux_*.deb
    dpkg -i --force-confnew ./temp/termux-tools_*.deb
    # apt -f install
    rm -rf temp
    app neovim fzf eza lua make zip \
        tree git sift bat fd
    updateAptsrc
end

# set list (printf %s (cat ./bitward.csv ))
function gpass -d "cheap password manager"
    if test (count $argv) -eq 0
        echo "Please Enter username or email adress!"
        return
    end
    set sourcePass $HOME/storage/external-1/../../../../DCIM/bitward.csv
    command cp -rf $sourcePass $HOME/../usr/tmp
    # set passfile $phone/Aaaa/bitward.csv
    set passfile $HOME/../usr/tmp/bitward.csv
    set linenumber (grep -in $argv[1] $passfile | cut -d':' -f1)
    if test (count $linenumber) -eq 0
        echo "entery does not exist!"
        return
    else if test (count $linenumber ) -eq 1
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
        return
    else
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
        end
    end
end

function pp
    # set -l list (sed  ':a;N;$!ba;s/\n/@@@@@@@/g'  $HOME/warf.csv)
    set -l list (cat -A  $HOME/bitward.csv)
    set -l enteriesNum 0
    set -l chosenList
    for i in $list
        if string match -q "*$argv[1]*" $i
            set enteriesNum (math $enteriesNum + 1)
            set chosenList $chosenList \n $i
        end
    end
    # echo -e $chosenList
    if test $enteriesNum -eq 0
        echo "entery does not exist"
        return
    else #if test $enteriesNum -eq 1
        set chosenList (string replace ",," ",null," $chosenList)
        set -l passArray (string split "," $chosenList)
        echo \n
        echo " Link:    $passArray[6]"
        echo " Email:    $passArray[11]"
        echo " Password:    $passArray[12]"
        echo " email@password"
        echo " $passArray[11]@$passArray[12]"
        echo \n

        # for i in ( string split "," $chosenList)
        #     echo $i
        # end
    end

end

function cfont -d "change termux font"
    # rm $HOME/.termux/font.ttf
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

function terfont -d "change termux font with fuzzy finder"
    set fontdir $repo/nerd_fonts
    set selectedFont (command ls -R $fontdir | grep -E '\.ttf$|\.otf$' |  fzf --border rounded --border-label="Termux Fonts")
    if test -z $selectedFont
        echo "no font selected"
        return
    end
    set selectednoprop (string replace ".ttf" "" $selectedFont)
    echo "successfully selected $selectednoprop"
    rm -fR $HOME/.termux/font.ttf
    cfont (find $fontdir -regex ".*$selectedFont")
    termux-reload-settings
end

function updateAptsrc -d "update apt source list offline"
    set Termux /storage/0A56-1B19/backup/Termux
    cp $Termux/myConfig.zip ./
    unzip -q myConfig.zip -d temp
    if test -d $HOME/../usr/var/lib/apt/lists
        rm -rf $HOME/../usr/var/lib/apt/lists
    end
    mkdir -p $HOME/../usr/var/lib/apt/lists
    cp -fr temp/packages/* $HOME/../usr/var/lib/apt/lists
    rm -rf temp
    rm -rf myConfig.zip
end


#android apk 

function apk
    java -jar $HOME/.local/bin/APKEditor.jar
end

function apkdecode
    apktool decode $argv[1] \
        --match-original \
        -api 29 \
        -o apkout
end

function apkmerge -d "merge split apks and apkm"
    # set -l inName 
    java -jar $HOME/.local/bin/APKEditor.jar m -i $argv
end

# function apkms -d "merge and sign apks"
#     set -l filename (echo $argv[1] | awk -F/ '{nlast = NF -0;print $nlast}')
#     set -l nameNoExtention (echo $filename | string split '.apk')
#     set -l extention (echo $filename | awk -F. '{nlast = NF -0;print $nlast}')
#     set -l output $nameNoExtention\_m.apk
#     java -jar $HOME/.local/bin/APKEditor.jar m -i $argv -o $output
#     apksign ./$output
#
# end

function apksign -d "sign apk files"
    # apksigner sign --ks $argv[1] $argv[2]
    if test $HOME/.local/release.keystore
        cp $repo/Keystore/release.keystore $HOME/.local/
        cp $repo/Keystore/pass.txt $HOME/.local/
    end
    apksigner sign --ks $HOME/.local/release.keystore --ks-pass file:$HOME/.local/pass.txt $argv[1]
    rm $HOME/.local/release.keystore $HOME/.local/pass.txt
end

function apkverify
    apksigner verify -v --print-certs $argv
end

function genkeystore -d "generate keystore"
    # validity in days
    keytool -genkey -v -keystore release.keystore -alias universal -keyalg RSA -keysize 2048 -validity 18000 $argv
end




# create new project

function nproject -d "create new project"

    function echoLangs
        echo "what is the type of projects you want to create ?"\n"-1 cpp."\n"-2 rust."\n"-3 python."\n"-4 java."\n"-5 javascript."\n"-6 web-project."\n
    end

    echo "enter the name of the project: "
    set projectName (read -l)
    if test -z $projectName
        echo "enter the name of the project: "
        set projectName (read -l)
    end
    echoLangs
    set projectType (read -l)

    mkdir $projectName
    if test $projectType -le 0; or test $projectType -ge 7
        echoLangs
        set projectType (read -l)
    else
        if test $projectType = 1
            touch $projectName/main.cpp
        else if test $projectType = 2
            touch $projectName/main.rs
        else if test $projectType = 3
            touch $projectName/main.py
        else if test $projectType = 4
            touch $projectName/main.py
        else if test $projectType = 5
            touch $projectName/main.js
        else if test $projectType = 6
            touch $projectName/main.html
            touch $projectName/style.css
            touch $projectName/script.js

        end
    end
end

#java programing

function rj -d "run java program"
    if test ./Main.java
        java Main.java
    end
end

# function mvn
#     /data/data/com.termux/files/home/.local/apache-maven-3.6.0/bin/mvn
# end

# rust

function rs -d "run rust code without building it"
    cargo run $argv
end

function rcpp -d "run c++ code"
    if test (count $argv) -eq 0
        clang++ -Wall ./*.cpp && ./a.out
    else
        clang++ -Wall $argv && ./a.out
    end
end



function dii -d "get any file parent directory from path"
    dirname $argv
end

function killvnc -d "stop vnc server on linux distros that download it from andronix"
    ps -ef | tail -n +2 | awk '{printf $2; for (i=8; i<=NF; i++) printf " " $i; print""}' | grep vnc | awk '{print $1}' | xargs kill -9 && echo "the vnc server has been stopped successfully"
    ps -ef | tail -n +2 | awk '{printf $2; for (i=8; i<=NF; i++) printf " " $i; print""}' | grep proot | awk '{print $1}' | xargs kill -9
    ps -ef | tail -n +2 | awk '{printf $2; for (i=8; i<=NF; i++) printf " " $i; print""}' | grep ssh-agent | awk '{print $1}' | xargs kill -9
    ps -ef | tail -n +2 | awk '{printf $2; for (i=8; i<=NF; i++) printf " " $i; print""}' | grep gpg-agent | awk '{print $1}' | xargs kill -9
    ps -ef | tail -n +2 | awk '{printf $2; for (i=8; i<=NF; i++) printf " " $i; print""}' | grep daemon | awk '{print $1}' | xargs kill -9


    # pkill vnc
    # pkill proot
    # pkill ssh-agent
    # pkill gpg-agent
    # pkill xfce
    # pkill proot

    rm $HOME/arch-fs/tmp/.X*-lock
    rm $HOME/arch-fs/tmp/.X11-unix/X*
    echo "the vnc server has been stopped successfully"
end

function starch -d "start arch distro"
    $HOME/start-arch.sh
end

function stubuntu -d "start ubuntu distro"
    $HOME/start-ubuntu22.sh
end


function fish_search_commands
    set -l cmd_description
    set -l selected_cmd (command | fzf --preview 'command -d {}')
    if test -n "$selected_cmd"
        man $selected_cmd
    end
end
