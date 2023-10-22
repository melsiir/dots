
set -xU repo "/storage/0A56-1B19/backup/Termux"
source ~/.config/fish/onDemand/packages.fish


function app
  set toInstall
  #loop through given arguments
  for i in $argv
    # set packageToInstall
    switch $i
      case "cmake"
        set packageToInstall = $cmake
        set packagedir "cmake"
      case "pkgUpdate"
        set packageToInstall = $pkgUpdate
        set packagedir "pkgUpdate"
      case "make"
        set packageToInstall = $make
        set packagedir "make"
      case "fish"
        set packageToInstall = $fish
        set packagedir "fish"
      case "neovim"
        set packageToInstall = $neovim
        set packagedir "neovim"
      case "lua"
        set packageToInstall = $lua
        set packagedir "lua"
      case "nodejs"
        set packageToInstall = $nodejs
        set packagedir "nodejs"
      case "tree"
        set packageToInstall = $tree
        set packagedir "tree"
      case "aria2"
        set packageToInstall = $aria2
        set packagedir "aria2"
      case "newsboat"
        set packageToInstall = $newsboat
        set packagedir "newsboat"
      case "gnupg"
        set packageToInstall = $gnupg
        set packagedir "gnupg"
      case "imagemagick"
        set packageToInstall = $imagemagick
        set packagedir "imagemagick"
      case "openssh"
        set packageToInstall = $openssh
        set packagedir "openssh"
      case "openssl"
        set packageToInstall = $openssl
        set packagedir "openssl"
      case "openssltool" or case "openssl-tool"
        set packageToInstall = $openssltool
        set packagedir "openssl-tool"
      case "libqrencode"
        set packageToInstall = $libqrencode
        set packagedir "libqrencode"
      case "w3m"
        set packageToInstall = $w3m
        set packagedir "w3m"
      case "exa"
        set packageToInstall = $exa
        set packagedir "eza"
      case "eza"
        set packageToInstall = $eza
        set packagedir "eza"
      case "fzf"
        set packageToInstall = $fzf
        set packagedir "fzf"
      case "fastfetch"
        set packageToInstall = $fastfetch
        set packagedir "fastfetch"
      case "ripgrep"
        set packageToInstall = $ripgrep
        set packagedir "ripgrep"
      case "termuxapi" or case "termux-api"
        set packageToInstall = $termuxapi
        set packagedir "termuxapi"
      case "emacs"
        set packageToInstall = $emacs
        set packagedir "emacs"
      case "wget"
        set packageToInstall = $wget
        set packagedir "wget"
      case "osspuuid" or case "ossp-uuid" 
        set packageToInstall = $osspuuid
        set packagedir "ossp-uuid"
      case "xmlstarlet"
        set packageToInstall = $xmlstarlet
        set packagedir "xmlstarlet"
      case "starship"
        set packageToInstall = $starship
        set packagedir "starship"
      case "fd"
        set packageToInstall = $fd
        set packagedir "a_semi_dependent"
      case "bat"
        set packageToInstall = $bat
        set packagedir "a_semi_dependent"
      case "duf"
        set packageToInstall = $duf
        set packagedir "a_semi_dependent"
      case "dua"
        set packageToInstall = $dua
        set packagedir "a_semi_dependent"
      case "hugo"
        set packageToInstall = $hugo
        set packagedir "a_semi_dependent"
      case "p7zip"
        set packageToInstall = $p7zip
        set packagedir "a_semi_dependent"
      case "zip"
        set packageToInstall = $zip
        set packagedir "zip"
      case "git"
        set packageToInstall = $git
        set packagedir "git"
      case "sift"
        set packageToInstall = $sift
        set packagedir "a_semi_dependent"
      case "ccrypt"
        set packageToInstall = $ccrypt
        set packagedir "a_semi_dependent"
      case "jq"
        set packageToInstall = $jq
        set packagedir "jq"
      case "strace"
        set packageToInstall = $strace
        set packagedir "strace"
      case "shfmt"
        mkdir $HOME/.local/bin
        cp $repo/offline-repo/shfmt/bin/shfmt $HOME/.local/bin
        echo "shfmt installed successfully"
        return
      case ""
        echo "please enter package name"
    end

    # find the package and install it 
    mkdir $phone/temp
    cp -r $repo/offline-repo/$packagedir $phone/temp
    for package in (string split , $packageToInstall)
      if string match "libxml2" $package or string match "glib" $package or string match "libandroid-support" $package \
        or string match "libdav1d" $package or string match "libaom" $package or string match "libde265" $package\
        or string match "libffi" $package or string match "libheif" $package or string match "libgnutls" $package \
        or string match "libjpeg-turbo" $package or string match "liblzma" $package or string match "libpng" $package\
        or string match "libnpth" $package or string match "libtiff" $package or string match "librav1e" $package \
        or string match "libwebp" $package or string match "libx265" $package 
        find $repo/offline-repo/libs -name "$package\_*.deb" | while read -l pkg
        cp $pkg $phone/temp
        set toInstall $toInstall $pkg
      end
    end
    find $phone/temp/$packagedir -name "$package\_*.deb" | while read pkg
    # find $repo/offline-repo/$packagedir -name "$package\_*.deb" | while read pkg
    # dpkg -i $pkg
    set toInstall $toInstall $pkg
  end
end
end
dpkg -i $toInstall
rm -r $phone/temp
end



function appu --description "uninstall packages with all dependencies"
  set pkgtorm (string split , $$argv)
  # string replace -a "liblzma" "" $pkgtorm
  pkg uninstall (echo $pkgtorm | string replace "liblzma" "")
end


# make folder called new and put all updated packages inside it
# and put pkgs inside theme
function updateOfflineRepo
  set repodir $repo/offline-repo
  set -l pkgs ""
  # extract package name from new dir
  find "./new/" -name "*.deb" | while read -l fullnewPkg
  set nonew (string replace "./new/" "" $fullnewPkg)
  set newpkg (string replace -r "_(.)*.deb" "" $nonew)
  set pkgs "$pkgs,$newpkg"
end
# copy all matching dirs
set dirstocopy
set dirstoloop ","
set curdir (pwd)
for i in (string split , $pkgs)
  find $repodir -name "$i\_*.deb" | while read -l pkg
  set repoPkgDir (echo $pkg | awk -F/ '{nlast = NF -1;print $nlast}')
  #this is neat way to get file parent dir but i have no time to work it out
  # set repoPkgDir (dirname $pkg )
  if string match -q "*$repoPkgDir*" $dirstocopy
    #do nothing
  else 
    set dirstoloop "$dirstoloop,$curdir/$repoPkgDir"
    set dirstocopy $dirstocopy $repodir/$repoPkgDir
  end
end
 end
 cp  $dirstocopy ./
 #remove the first comma in the string
 set dirstoloop (string replace ",," "" $dirstoloop)

 set copyed
 for olddir in (string split , $dirstoloop)
   for i in (string split , $pkgs)
     find $olddir -name "$i\_*.deb" | while read -l pkg
     if test -f $pkg
       rm $pkg
       set npkg (find "./new" -name "$i\_*.deb")
       cp $npkg $olddir
       if string match -q "*$npkg*" $copyed
         #do nothing
       else
         set copyed "$copyed,$npkg"
       end
     end
   end
 end
end
#remove debs after done copying
for i in (string split "," $copyed)
  rm $i
end
end




function trimdpn
  sed -i "/Recommends/d" $argv
  sed -i "/Suggests/d" $argv
  sed -i "/Replaces/d" $argv
  sed -i "/Breaks/d" $argv
  sed -i "/Reverse/d" $argv
  sed -i "/Conflicts/d" $argv
  sed -i "s/Depends://" $argv
  #remove firstline
  sed -i "1d" $argv
  # remove tags 
  sed -i -E "s/\((.*?)\)//g" $argv
  #remove white space at the start of the lines
  sed -i 's/^[[:blank:]]*//g' $argv
  #replace newline with space
  # sed -i ':a;N;$!ba;s/\n/ /g' $argv

  sed -i ':a;N;$!ba;s/\n/,/g' $argv
  sed -i 's/ //g' $argv
end


function apprm -d "remove packages and all thair dependencies"
  set toremove ""

  # list all installed pkgs
  pkg list-installed > list.txt
  sed -i "s/\/.*//g" list.txt
  sed -i "/Listing.../d" list.txt
  sed -i ':a;N;$!ba;s/\n/,/g' list.txt
  set list (cat list.txt)
  #add comma to the end and the start of list
  set list ",$list"
  set list "$list,"
  #====================================
  #list pkg dependencies
  dbn $argv > dpns.txt
  trimdpn dpns.txt
  set dependencies (cat dpns.txt)


  #remove sub dependences
  #check dependecies sub dependences
  # for debs in (string split "," $dependencies)
  #   dbn $debs > subdeb.txt
  #   trimdpn subdeb.txt
  #   set subDebs (cat subdeb.txt)
  #   for subdeb in (string split "," $subDebs)
  #     rdbn $subdeb > rsubdpns.txt
  #     # sed -i "s/$subdeb//" rsubdpns.txt
  #     #if reverse dependency contain one of dependencies of package that you want remove  then remove that string
  #     set list (string replace ",$subdeb," "," $list)      
  #     trimdpn rsubdpns.txt
  #     set subCanBeRemoved true
  #     set rsubdps (cat rsubdpns.txt)
  #     for reverseSubDependency in (string split "," $rsubdps)
  #       if string match -q "*,$reverseSubDependency,*" $list
  #         # echo $reverseDependency
  #         set subCanBeRemoved false
  #       end
  #     end
  #     if $subCanBeRemoved
  #       set toremove $toremove $subdeb
  #       rm rsubdpns.txt
  #     end
  #     #   ##$$$$$
  #   end
  # end



  #check if dependencies has other programs need's it
  for dependency in (string split "," $dependencies)


    dbn $dependency > subdeb.txt
    trimdpn subdeb.txt
    set subDebs (cat subdeb.txt)
    for subdeb in (string split "," $subDebs)
      rdbn $subdeb > rsubdpns.txt
      # sed -i "s/$subdeb//" rsubdpns.txt
      #if reverse dependency contain one of dependencies of package that you want remove  then remove that string
      set list (string replace ",$subdeb," "," $list)      
      trimdpn rsubdpns.txt
      set subCanBeRemoved true
      set rsubdps (cat rsubdpns.txt)
      # echo $rsubdps
      for reverseSubDependency in (string split "," $rsubdps)
        if string match -q "*,$reverseSubDependency,*" $list
          # echo $reverseDependency
          set subCanBeRemoved false
        end
      end
      if string match -q "*$subdeb*" $toremove
        set notExisting false
      else
        set notExisting true
      end
        if $subCanBeRemoved and  $notExisting
        set toremove "$toremove $subdeb"
        rm rsubdpns.txt
      end
    end






    rdbn $dependency > rdpns.txt
    sed -i "s/$argv//" rdpns.txt
    #if reverse dependency contain one of dependencies of package that you want remove  then remove that string
    set list (string replace ",$dependency," "," $list)      
    trimdpn rdpns.txt
    set canBeRemoved true
    set rdps (cat rdpns.txt)
    for reverseDependency in (string split "," $rdps)
      if string match -q "*,$reverseDependency,*" $list
        # echo $reverseDependency
        set canBeRemoved false
      end
    end
          if string match -q "*$dependency*" $toremove
        set notExisting false
      else
        set notExisting true
      end
    if $canBeRemoved and $notExisting
      set toremove $toremove $dependency
      rm rdpns.txt
    end








  end
  echo $toremove
  rm list.txt
  rm dpns.txt
  rm subdeb.txt
end

