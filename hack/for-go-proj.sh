#! /bin/bash

# Copyright 2017 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -o errexit
set -o pipefail
set -o nounset

CONTRIB_ROOT="$(dirname ${BASH_SOURCE})/.."

if [ $# -ne 1 ];then
  echo "missing subcommand: [build|install|test]"
  exit 1
fi

CMD="${1}"

case "${CMD}" in
  "build")
    ;;
  "install")
    ;;
  "test")
    ;;
  *)
    echo "invalid subcommand: ${CMD}"
    exit 1
    ;;
esac

dep_projects=$(find "${CONTRIB_ROOT}" -wholename '*Gopkg.toml' -not -path "*/vendor/*")
for dep_file in ${dep_projects}; do
  (
    project="${dep_file%Gopkg.toml}"

    if [[ ( $TRAVIS_GO_VERSION =~ ^1\.9 && ! $project =~ 'custom-metrics-stackdriver-adapter' ) ||
          ( $TRAVIS_GO_VERSION =~ ^1\.10 && $project =~ 'custom-metrics-stackdriver-adapter' ) ]]; then
      echo "go ${CMD}ing ${project}"
      cd "${project}"
      go "${CMD}" ./...
    fi
  )
done;
