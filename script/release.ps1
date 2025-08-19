$module = "hdfk7-boot-starter-discovery"
$version = "1.1.2"

$work = Get-Location
$target = "target"
$staging = "$target/central-staging"
$publishing = "$work/$target/central-publishing"
$path = "$staging/cn/hdfk7/boot/$module/$version"
$pom = "$module-$version.pom"
$jar = "$module-$version.jar"
$javadoc = "$module-$version-javadoc.jar"
$sources = "$module-$version-sources.jar"

mvn clean install
New-Item -ItemType Directory -Force -Path $path
New-Item -ItemType Directory -Force -Path $publishing
Copy-Item -Path "pom.xml" -Destination (Join-Path $path $pom)
Copy-Item -Path "target/$jar" -Destination (Join-Path $path $jar)
Copy-Item -Path "target/$javadoc" -Destination (Join-Path $path $javadoc)
Copy-Item -Path "target/$sources" -Destination (Join-Path $path $sources)
Set-Location $path

gpg --armor --output "$pom.asc" --detach-sig $pom
Get-FileHash $pom -Algorithm MD5 | ForEach-Object { $_.Hash } | Set-Content "$pom.md5"
Get-FileHash $pom -Algorithm SHA1 | ForEach-Object { $_.Hash } | Set-Content "$pom.sha1"
Get-FileHash $pom -Algorithm SHA256 | ForEach-Object { $_.Hash } | Set-Content "$pom.sha256"
Get-FileHash $pom -Algorithm SHA512 | ForEach-Object { $_.Hash } | Set-Content "$pom.sha512"

gpg --armor --output "$jar.asc" --detach-sig $jar
Get-FileHash $jar -Algorithm MD5 | ForEach-Object { $_.Hash } | Set-Content "$jar.md5"
Get-FileHash $jar -Algorithm SHA1 | ForEach-Object { $_.Hash } | Set-Content "$jar.sha1"
Get-FileHash $jar -Algorithm SHA256 | ForEach-Object { $_.Hash } | Set-Content "$jar.sha256"
Get-FileHash $jar -Algorithm SHA512 | ForEach-Object { $_.Hash } | Set-Content "$jar.sha512"

gpg --armor --output "$javadoc.asc" --detach-sig $javadoc
Get-FileHash $javadoc -Algorithm MD5 | ForEach-Object { $_.Hash } | Set-Content "$javadoc.md5"
Get-FileHash $javadoc -Algorithm SHA1 | ForEach-Object { $_.Hash } | Set-Content "$javadoc.sha1"
Get-FileHash $javadoc -Algorithm SHA256 | ForEach-Object { $_.Hash } | Set-Content "$javadoc.sha256"
Get-FileHash $javadoc -Algorithm SHA512 | ForEach-Object { $_.Hash } | Set-Content "$javadoc.sha512"

gpg --armor --output "$sources.asc" --detach-sig $sources
Get-FileHash $sources -Algorithm MD5 | ForEach-Object { $_.Hash } | Set-Content "$sources.md5"
Get-FileHash $sources -Algorithm SHA1 | ForEach-Object { $_.Hash } | Set-Content "$sources.sha1"
Get-FileHash $sources -Algorithm SHA256 | ForEach-Object { $_.Hash } | Set-Content "$sources.sha256"
Get-FileHash $sources -Algorithm SHA512 | ForEach-Object { $_.Hash } | Set-Content "$sources.sha512"

Set-Location "$work/$staging"
Compress-Archive -Path "./*" -DestinationPath "$publishing/central-bundle.zip"

Set-Location "$work"
