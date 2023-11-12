function connections --description 'Get open connections on a given port'
    lsof +c 0 -i :$argv | grep -v '^launchd ' | grep ESTABLISHED
end
