#! /bin/bash

export txtblk=$'\e[0;30m' # Black - Regular
export txtred=$'\e[0;31m' # Red
export txtgrn=$'\e[0;32m' # Green
export txtylw=$'\e[0;33m' # Yellow
export txtblu=$'\e[0;34m' # Blue
export txtpur=$'\e[0;35m' # Purple
export txtcyn=$'\e[0;36m' # Cyan
export txtwht=$'\e[0;37m' # White
export bldblk=$'\e[1;30m' # Black - Bold
export bldred=$'\e[1;31m' # Red
export bldgrn=$'\e[1;32m' # Green
export bldylw=$'\e[1;33m' # Yellow
export bldblu=$'\e[1;34m' # Blue
export bldpur=$'\e[1;35m' # Purple
export bldcyn=$'\e[1;36m' # Cyan
export bldwht=$'\e[1;37m' # White
export txtrst=$'\e[0m'    # Text Reset

BASE=run.sh

set -e

die()
{
    CODE=$1
    shift
    >&2 echo "$bldred$BASE: ERROR -- $@$txtrst"
    exit $CODE
}

function die_status() {
    status
    die "$@"
}

function status() {
    tree $BASEDIR/$1
}

function pushd_hush()
{
    pushd "$@" > /dev/null
}

function popd_hush()
{
    popd "$@" > /dev/null
}

function try_subundle() {
    echo "${bldblk}Trying: ${bldpur}./git-subundle $@${txtrst}${txtwht}"
    $BASEDIR/git-subundle -d "$@" || die_status 1 "git-subundle failed."
    echo -n "${txtrst}"
}

function try_subundle_ignore() {
    echo "${bldblk}Trying [ignore]: ${bldpur}./git-subundle $@${txtrst}${txtwht}"
    ./git-subundle -d "$@" || true
    echo -n "${txtrst}"
}

function ok() {
    echo "${bldgrn}OK${txtrst}"
}

function fail() {
    die_status 1 "FAIL"
}

function test_if_exists() {
    echo -n "${bldblk}... testing that file '$1' exists..."
    [ -e "$1" ] && ok || fail
}

function test_if_exists_dir() {
    echo -n "${bldblk}... testing that directory '$1' exists..."
    [ -d "$1" ] && ok || fail
}

function test_if_setup_ok() {
    pushd_hush "$1"

    echo -n "${bldblk}... repo: testing that commit '$REPO_HEAD' exists..."
    git rev-parse $REPO_HEAD &> /dev/null && ok || fail
    echo -n "${bldblk}... repo: testing master branch..."
    [ "$(git rev-parse master)" == $REPO_HEAD ] &> /dev/null && ok || fail

    cd subrepo
    echo -n "${bldblk}... subrepo: testing that commit '$SUBREPO_HEAD' exists..."
    git rev-parse $SUBREPO_HEAD &> /dev/null && ok || fail
    echo -n "${bldblk}... subrepo: testing master branch..."
    [ "$(git rev-parse master)" == $SUBREPO_HEAD ] &> /dev/null && ok || fail

    popd_hush
}

function test_setup_helper() {

    mkdir -p network cpu1 cpu2
    mkdir -p "$1"
    pushd "$1"

    # Create a submodule repository
    mkdir subrepo
    pushd subrepo
    echo b > b
    git init
    git add -A
    git commit -m "First commit"
    export SUBREPO_HEAD=$(git rev-parse HEAD)
    popd

    # Create a second repository, with repo above as submodule
    mkdir repo
    pushd repo
    echo a > a
    git init
    git add -A
    git commit -m "First commit"
    git submodule add ../subrepo
    git add -A
    git commit -m "Add 'subrepo' as submodule "
    export REPO_HEAD=$(git rev-parse HEAD)
    popd

    # Clone repository including submodule
    git clone --recursive repo clone

    popd
}

function test_setup() {
    SETUP=${1:-cpu1}
    echo "Creating test setup '$SETUP'"
    test_setup_helper "$SETUP" &> /dev/null || die 1 "test_setup failure"
}

function test-cleanup() {
    echo $BASEDIR
    cd $BASEDIR
    rm -rf test cpu1 cpu2 network repo subrepo
    rm -f *.bundle
}

function test_new() {
    test-cleanup
    echo
    echo "${bldblk}[$((++testcount))] $1${txtrst}..."
}

BASEDIR=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd )
STARTPWD=$PWD

trap 'trap - INT TERM EXIT; cd $STARTPWD' INT TERM EXIT

# Start from basedir, and clean up old execution
test-cleanup
if [ "$1" == "clean" ]; then
    exit 0
fi

cd $BASEDIR

test_new "Synopsys text"
try_subundle_ignore

test_new "Help text"
try_subundle -h

test_new "Basic subundle creation"
test_setup cpu1
pushd cpu1
try_subundle create repo
popd
test_if_exists cpu1/repo.bundle
test_if_exists cpu1/repo_subrepo.bundle

test_new "Basic subundle creation (repo with subfolder)"
test_setup cpu1
try_subundle create cpu1/repo
test_if_exists repo.bundle
test_if_exists repo_subrepo.bundle

test_new "Basic subundle creation (with bundlefile parameter)"
test_setup cpu1
try_subundle create cpu1/repo network/myrepo
test_if_exists network/myrepo.bundle
test_if_exists network/myrepo_subrepo.bundle

test_new "Basic subundle restore"
test_setup cpu1
try_subundle create cpu1/repo
pushd cpu2
try_subundle unbundle ../repo.bundle
test_if_exists_dir repo
test_if_setup_ok repo
popd




