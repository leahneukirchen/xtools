complete -c xmypkgs -f
complete -c xmypkgs -n '[ (count (commandline -poc)) -eq 1 ]' -a '(git -C (xdistdir) log --pretty=%ce)' -d Contributor
