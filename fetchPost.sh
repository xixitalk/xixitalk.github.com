#! /bin/bash

HOSTNAME=$1

if [ $# -eq 0 ]; then
  echo "[WARN]need hostname"
  exit 1
fi

echo [LOG]$HOSTNAME
PROXY="--socks5-hostname 192.168.1.106:1081"
FILEPATH=/tmp

newflag=$(curl -s  ${PROXY} "${HOSTNAME}/md/getnewpost?action=flag")

if [ $newflag -ne 1 ]; then
  echo "[WARN]no new post"
  exit 2
fi

FILENAME=$(curl -s  ${PROXY} "${HOSTNAME}/md/getnewpost?action=getfilename")
MD5STR=$(curl -s  ${PROXY} "${HOSTNAME}/md/getnewpost?action=getfilemd5")

rm ${FILEPATH}/${FILENAME}
curl -s  ${PROXY} "${HOSTNAME}/md/getnewpost?action=getfilecontent" > ${FILEPATH}/${FILENAME}
if [ $? -eq 0 ]; then
  echo [LOG]curl fetch file ok
else
  echo [WARN]curl fetch file fail
fi
FILEMD5=$(md5sum $FILEPATH/$FILENAME | cut -d ' ' -f1)
echo [LOG]filename:$FILENAME 
echo [LOG]fileMD5:$MD5STR
echo [LOG]downfileMD5:$FILEMD5

if [ "$MD5STR"x = "$FILEMD5"x ]; then
  echo [LOG]file MD5 ok
else
  echo [WARN]MD5 not eq
  exit 3
fi
cp -v $FILEPATH/$FILENAME  ./source/_posts/

bash ./rakeAndpush.sh $FILENAME
if [ $? -eq 9 ]; then
  echo [LOG] blog deploy ok
else
  echo [WARN] blog deploy fail
fi

curl -s  ${PROXY} "${HOSTNAME}/md/getnewpost?action=cleanflag"
if [ $? -eq 0 ]; then
  echo [LOG]clean file publish flag ok
else
  echo [WARN]clean file publish flag fail
fi


