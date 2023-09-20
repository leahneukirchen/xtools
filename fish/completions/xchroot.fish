complete -c xchroot -f
complete -c xchroot -n '[ (count (commandline -poc)) -eq 1 ]' -a '(__fish_complete_directories)'
