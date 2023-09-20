complete -c xvoidstrap -f
complete -c xvoidstrap -n '[ (count (commandline -poc)) -eq 1 ]' -a '(__fish_complete_directories)'
complete -c xvoidstrap -n '[ (count (commandline -poc)) -gt 1 ]' -a '(__fish_print_xbps_packages)'
