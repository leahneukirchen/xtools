complete -c xgensum -f
complete -c xgensum -s f -d 'Force (re-)download of distfiles'
complete -c xgensum -s c -d 'Use content checksum'
complete -c xgensum -s i -d 'Replace checksum in-place'
complete -c xgensum -s H -d 'Absolute path to hostdir' -xa '(__fish_complete_directories)'
complete -c xgensum -a '(__xtools_complete_one_package)'
