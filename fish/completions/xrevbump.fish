function __xrevbump_complete_git_commit_args
    set -l tokens (commandline -poc; commandline -ct)
    set -l dashdash (contains -i -- -- $tokens); or return
    set -e tokens[1..$dashdash]
    complete --do-complete="git commit $tokens"
end

complete -c xrevbump -f
complete -c xrevbump -n 'not contains -- -- (commandline -poc)' -n '[ (count (commandline -poc)) -gt 1 ]' -a '(__xtools_complete_packages)'
# Complete `git commit` args after `--`
complete -c xrevbump -a '(__xrevbump_complete_git_commit_args)'
