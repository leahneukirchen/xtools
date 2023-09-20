complete -c xrecent -f
complete -c xrecent -n '[ (count (commandline -poc)) -eq 1 ]' -xa '(__xtools_complete_repo_urls; __xtools_complete_archs)'
