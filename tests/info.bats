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

setup() {
    load 'test_helper/bats-support/load'
    load 'test_helper/bats-assert/load'
    export NO_COLOR=1
    export OPS_VERSION="test"
}

@test "version" {
    run ops -version
    assert_line 'test'

    run ops -v
    assert_line "test"
}

@test "-info" {
    run ops -info
    WD=$(pwd)
    assert_line "OPS_VERSION: test"
    assert_line "OPS_PWD: $WD"
    assert_line "OPS_ROOT: $WD/olaris"
    assert_line "OPS_TMP: $HOME/.ops/tmp"
    assert_line --partial "OPS_OLARIS: "
    assert_success
}