#! /bin/sh

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

comment=$1
if [ -z $comment ]; then
    echo "input comment pls"
    exit 2
fi

echo "generate and deoploy"
rake generate && rake deploy
rakeret=$?
if [ $rakeret -ne 0 ]; then
    echo "rake error" > /tmp/git.txt
    exit 3
fi

echo "git add source/_posts/*.markdown"
git add source/_posts/*.markdown

echo "git commit -m $comment"
git commit -m  "$comment"

echo "git push origin source"
git push origin source

md5sum  source/_posts/* > ._posts.md5
