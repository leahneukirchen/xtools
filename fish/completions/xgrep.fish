complete -c xgrep -f
complete -c xgrep -n '[ (count (commandline -poc)) -gt 1 ]' -a '(__fish_print_xbps_packages -i)'
