complete -c xoptdiff -f
complete -c xoptdiff -s q -d 'Only list differing packages'
complete -c xoptdiff -a '(__fish_print_xbps_packages -i)'
