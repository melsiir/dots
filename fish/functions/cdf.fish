function cdf -d "cd to directory with assistance from fzf"

    set -l wire1 w1
    set -l selected_dir (fd --max-depth 3 --type directory --hidden | fzf)

    set -l wire2 $wire1 $selected_dir
    set wire2len (string length "$wire2")

    if test $wire2len -le 2
        return
    else
        cd $selected_dir
    end

end
