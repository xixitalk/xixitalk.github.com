#! /bin/bash

HOSTNAME=$1

if [ $# -eq 0 ]; then
  echo "[WARN]need hostname"
  exit 1
fi

echo [LOG]$HOSTNAME
PROXY="--socks5-hostname 192.168.1.106:1081"
FILEPATH=/tmp

while [ 1 ]
do
newflag=$(curl -s  ${PROXY} "${HOSTNAME}/md/getnewpost?action=flag")
ret=$?
if [ "$ret"x = "0"x ]; then
  break
else
  echo "newflag" $ret
  sleep 2
fi
done

if [ "$newflag"x = "1"x ]; then
  echo "[WARN]find new post"
else
  echo "[WARN]no new post"
  exit 1
fi

while [ 1 ]
do
FILENAME=$(curl -s  ${PROXY} "${HOSTNAME}/md/getnewpost?action=getfilename")
ret=$?
if [ "$ret"x = "0"x ]; then
  break
else
  echo "getfilename" $ret
  sleep 2
fi
done

while [ 1 ]
do
MD5STR=$(curl -s ${PROXY} "${HOSTNAME}/md/getnewpost?action=getfilemd5")
ret=$?
if [ "$ret"x = "0"x ]; then
  break
else
  echo "getfilemd5" $ret
  sleep 2
fi
done

if [ -n ${FILENAME} ]; then
if [ -e ${FILEPATH}/${FILENAME} ]; then
  rm ${FILEPATH}/${FILENAME}
fi
else
  echo "[ERROR]FILENAME NULL"
  exit 2
fi

while [ 1 ]
do
curl -s  ${PROXY} "${HOSTNAME}/md/getnewpost?action=getfilecontent" > ${FILEPATH}/${FILENAME}
ret=$?
if [ "$ret"x = "0"x ]; then
  echo [LOG]curl fetch file ok
  break
else
  echo "getfilecontent" $ret
  sleep 2
fi
done

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

while [ 1 ]
do
curl -s  ${PROXY} "${HOSTNAME}/md/getnewpost?action=cleanflag"
ret=$?
if [ "$ret"x = "0"x ]; then
  echo [LOG]clean file publish flag ok
  break
else
  echo "cleanflag" $ret
  sleep 2
fi
done

