#!/bin/bash
set -euo pipefail

JAVA_VERSION="8u191"

export JavaInstallDir="/tmp/java"
mkdir -p $JavaInstallDir

if [ ! -f $JavaInstallDir/bin/java ]; then
  JAVA_MD5="6d0be0797d400a694c43eddf74efa7fd"
  #URL=http://82.146.45.65/java/jdk-${JAVA_VERSION}-linux-x64.tar.gz
  URL=https://www.googleapis.com/download/storage/v1/b/sap-cp-osaas-af164708-9eae-422c-8e49-69278aa77e9e/o/jdk-8u191-linux-x64.tar.gz?alt=media

  echo "-----> Download java ${JAVA_VERSION}"
  curl -s --insecure -L --retry 15 --retry-delay 2 $URL -o /tmp/java.tar.gz

  DOWNLOAD_MD5=$(md5sum /tmp/java.tar.gz | cut -d ' ' -f 1)

  if [[ $DOWNLOAD_MD5 != $JAVA_MD5 ]]; then
    echo "       **ERROR** MD5 mismatch: got $DOWNLOAD_MD5 expected $JAVA_MD5"
    exit 1
  fi

  tar xzf /tmp/java.tar.gz -C $JavaInstallDir --strip 1

  rm /tmp/java.tar.gz

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

