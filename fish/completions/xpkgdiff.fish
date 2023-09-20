complete -c xpkgdiff -f
complete -c xpkgdiff -s c -d 'Compare a file from package' -rF
complete -c xpkgdiff -s S -d 'Compare package metadata'
complete -c xpkgdiff -s f -d 'Compare package file lists'
complete -c xpkgdiff -s r -d 'Reverse diff (compare local to remote)'
complete -c xpkgdiff -s R -d 'Set remote repo URL' -xa '(__xtools_complete_repo_urls)'
complete -c xpkgdiff -s x -d 'Compare package dependencies'
complete -c xpkgdiff -s t -d 'Compare the full package dependency tree for -x'
complete -c xpkgdiff -s a -d 'Set architecture for comparison' -xa '(__xtools_complete_archs)'
# TODO: complete package properties
complete -c xpkgdiff -s p -d 'Compare package properties' -x
complete -c xpkgdiff -a '(__xtools_complete_packages)'
