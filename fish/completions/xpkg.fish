complete -c xpkg -f
complete -c xpkg -s r -d 'Full path for the target root directory' -xa '(__fish_complete_directories)'
complete -c xpkg -s R -d 'Consider only packages from repository' -xa '(__fish_complete_directories)'
complete -c xpkg -s a -d 'List all packages'
complete -c xpkg -s m -d 'List manual packages'
complete -c xpkg -s O -d 'List orphaned packages'
complete -c xpkg -s H -d 'List packages on hold'
complete -c xpkg -s D -d 'List installed packages not in repo'
complete -c xpkg -s L -d 'List installed packages not from remote repos'
complete -c xpkg -s v -d 'Show version numbers'
complete -c xpkg -s V -d 'Show version numbers and descriptions'
