#!/bin/sh
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

cd "$(dirname $0)"
# any suggestion how to avoid this rename and use just replaces in go.mod is welcome
HERE=$PWD
STAG="1.2.0"
DTAG="v1.2.1"
cd wsk
#git reset --hard
git checkout "$STAG" -B openserverless
cp $HERE/i18n_resources.go wski18n/i18n_resources.go
sed -i '/wski18n\/i18n_resources.go/d' .gitignore
git add wski18n/i18n_resources.go
sed -i -e 's/"wsk"/"ops -wsk"/' commands/wsk.go
find . \( -name \*.go -o -name go.mod \) | while read file 
do echo $file 
   sed -i 's!apache/openwhisk-cli/!sciabarracom/openwhisk-cli/!' $file
   sed -i 's!apache/openwhisk-cli"!sciabarracom/openwhisk-cli"!' $file
   sed -i 's!apache/openwhisk-cli !sciabarracom/openwhisk-cli !' $file
   sed -i 's!apache/openwhisk-cli$!sciabarracom/openwhisk-cli!' $file
   sed -i 's!apache/openwhisk-wskdeploy!sciabarracom/openwhisk-wskdeploy!' $file
done
sed -i '/openwhisk-wskdeploy/d' go.mod
DEPLOYVER=$(git ls-remote https://github.com/sciabarracom/openwhisk-wskdeploy | awk '/refs\/heads\/openserverless/{print $1}')
go get github.com/sciabarracom/openwhisk-wskdeploy@$DEPLOYVER
go mod tidy
git commit -m "patching sh for ops" -a
git tag $DTAG
git push origin-auth openserverless -f --tags
go clean -modcache -cache -testcache -fuzzcache
VER=$(git rev-parse HEAD)
cd ..
mkdir -p bin
GOBIN=$HERE/bin go install github.com/sciabarracom/openwhisk-cli@$VER

