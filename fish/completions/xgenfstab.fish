complete -c xgenfstab -f
complete -c xgenfstab -s p -d 'Exclude pseudo-filesystems'
complete -c xgenfstab -s P -d 'Include pseudo-filesystems'
complete -c xgenfstab -s t -d 'Use TAG for identifiers' -xa 'LABEL UUID PARTLABEL PARTUUID'
complete -c xgenfstab -s L -d 'Use labels for identifiers'
complete -c xgenfstab -s U -d 'use UUIDs for identifiers'
complete -c xgenfstab -a '(__fish_complete_directories)'
