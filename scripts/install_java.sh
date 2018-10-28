#!/bin/bash
set -euo pipefail

JAVA_VERSION="8u191"

echo $(ls -la /)
echo $(id)


export JavaInstallDir="/home/vcap/app/java$JAVA_VERSION"
mkdir -p $JavaInstallDir

if [ ! -f $JavaInstallDir/bin/java ]; then
  JAVA_MD5="6d0be0797d400a694c43eddf74efa7fd"
  URL=http://82.146.45.65/java/jdk-${JAVA_VERSION}-linux-x64.tar.gz

  echo "-----> Download java ${JAVA_VERSION}"
  curl -s -L --retry 15 --retry-delay 2 $URL -o /java/java.tar.gz

  DOWNLOAD_MD5=$(md5sum /home/vcap/app/java.tar.gz | cut -d ' ' -f 1)

  if [[ $DOWNLOAD_MD5 != $JAVA_MD5 ]]; then
    echo "       **ERROR** MD5 mismatch: got $DOWNLOAD_MD5 expected $JAVA_MD5"
    exit 1
  fi

  tar xzf /home/vcap/app/java.tar.gz -C $JavaInstallDir --strip 1

  rm /home/vcap/app/java.tar.gz

  export PATH="${JavaInstallDir}/bin":$PATH
  export JAVA_HOME=$JavaInstallDir
  #echo "-----> java home: ${JAVA_HOME}"
  #echo "-----> Path of java: $(which javac)"
  #echo "-----> PATH ${PATH}" 
  echo ""

fi
if [ ! -f $JavaInstallDir/bin/java ]; then
  echo "       **ERROR** Could not download Java"
  exit 1
fi

