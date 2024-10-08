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
}

@test "welcome" {
    run ops -t
    assert_line '* fail_then_succeed:       fail then success'
    assert_line '* failing:                 failing'
    assert_line '* sub:                     sub command'
    assert_line '* testcmd:                 test ops commands'
}

@test "testcmd" {
    run ops testcmd
    assert_line "test"
}

@test "sub" {
    run ops sub
    assert_line '* opts:         opts test'
    assert_line '* simple:       simple'
}

@test "sub simple" {
    run ops sub simple
    assert_line simple
}

@test "other with shortening" {
    run ops o
    assert_line "* simple:       simple task in other"

    run ops o s
    assert_line "hidden"
}

@test "sub command not found" {
    run ops sub notfound
    assert_line "task execution error: no command named notfound found"
    assert_failure
}