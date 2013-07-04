#! /bin/sh

write_log()
{
    now_time='['$(date +"%Y-%m-%d %H:%M:%S")']'
    echo $1
    echo ${now_time} $1 >> /tmp/check.log
}

oldnum=$(cat ._posts.md5 | wc -l)
newnum=$(md5sum source/_posts/*.markdown | wc -l)
if [ $oldnum -eq $newnum ]; then
    md5sum  --status  -c  ._posts.md5
    md5ret=$?
    if [ $md5ret -eq 0 ]; then
        echo "no posts change"
        exit 0
    else
        echo "post update"
    fi
else
    echo "post add"
fi

newpostname=$1
if [ -z $newpostname ]; then
    write_log "input newpostname as comment pls"
    exit 2
fi

echo "generate and deoploy"
rake generate > /dev/null 2>&1
rakeret=$?
if [ $rakeret -ne 0 ]; then
    write_log "rake generate error"${rakeret}
    exit 3
fi

rake deploy > /dev/null 2>&1
rakeret=$?
if [ $rakeret -ne 0 ]; then
    write_log "rake deploy error"${rakeret}
    exit 4
fi

echo "git add source/_posts/*.markdown"
git add source/_posts/*.markdown

echo "git commit -m $newpostname"
git commit -m  "$newpostname"

echo "git push origin source"
git push origin source
rakeret=$?
if [ $rakeret -ne 0 ]; then
    write_log "rake push error"${rakeret}
    exit 5
fi

md5sum  source/_posts/* > ._posts.md5
