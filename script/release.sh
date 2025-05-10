#!/bin/bash -ile

export module=hdfk7-boot-starter-discovery
export version=1.1.0

work=$(pwd)
export target="target"
export staging="${target}/central-staging"
export publishing="${work}/${target}/central-publishing"
export path="${staging}/cn/hdfk7/boot/${module}/${version}"
export pom="${module}-${version}.pom"
export jar="${module}-${version}.jar"
export javadoc="${module}-${version}-javadoc.jar"
export sources="${module}-${version}-sources.jar"

mvn clean install
mkdir -p "${path}"
mkdir -p "${publishing}"
cp pom.xml "${path}/${pom}"
cp "target/${jar}" "${path}/${jar}"
cp "target/${javadoc}" "${path}/${javadoc}"
cp "target/${sources}" "${path}/${sources}"
cd $path

gpg --armor --output "${pom}.asc" --detach-sig $pom
md5 -q $pom > "${pom}.md5"
shasum -a 1 $pom | awk '{print $1}' > "${pom}.sha1"
shasum -a 256 $pom | awk '{print $1}' > "${pom}.sha256"
shasum -a 512 $pom | awk '{print $1}' > "${pom}.sha512"

gpg --armor --output "${jar}.asc" --detach-sig $jar
md5 -q $jar > "${jar}.md5"
shasum -a 1 $jar | awk '{print $1}' > "${jar}.sha1"
shasum -a 256 $jar | awk '{print $1}' > "${jar}.sha256"
shasum -a 512 $jar | awk '{print $1}' > "${jar}.sha512"

gpg --armor --output "${javadoc}.asc" --detach-sig $javadoc
md5 -q $javadoc > "${javadoc}.md5"
shasum -a 1 $javadoc | awk '{print $1}' > "${javadoc}.sha1"
shasum -a 256 $javadoc | awk '{print $1}' > "${javadoc}.sha256"
shasum -a 512 $javadoc | awk '{print $1}' > "${javadoc}.sha512"

gpg --armor --output "${sources}.asc" --detach-sig $sources
md5 -q $sources > "${sources}.md5"
shasum -a 1 $sources | awk '{print $1}' > "${sources}.sha1"
shasum -a 256 $sources | awk '{print $1}' > "${sources}.sha256"
shasum -a 512 $sources | awk '{print $1}' > "${sources}.sha512"

cd "${work}/${staging}"
zip -r "${publishing}/central-bundle.zip" "./"
