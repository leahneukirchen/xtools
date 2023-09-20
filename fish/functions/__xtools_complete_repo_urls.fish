function __xtools_complete_repo_urls
    if [ -e /usr/share/xmirror/mirrors.lst ]
        string match -vr '^\s*#' </usr/share/xmirror/mirrors.lst | while read -l line
            set -l values (string split \t -- $line)
            # Mirror url, location, and tier
            echo -- $values[2]\t$values[3], Tier $values[4]
        end
    end
end
