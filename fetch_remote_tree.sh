#!/usr/bin/env bash

# fetch a specific file from a remote repo
# example: git archive --format=tar --remote=ssh://git@bitbucket.org/quarkgames/qcore_user.git  master:priv/ qcore_user_api.proto | tar -x
if [[ "$#" -lt 4 ]]; then
    echo -e "invalid invocation: $@\n\n"
    echo -e "USAGE:"
    echo -e "\t$0 <output dir> <bitbucket repo> <ref/branch/tag> [<subtree>]"
    exit
fi

REMOTE="origin"
OUTPUT_DIR=$1 && shift
URL=$1 && shift
REVISION=$1 && shift
TREES=$@

mkdir -p $OUTPUT_DIR
cd $OUTPUT_DIR
git init
git remote add -f $REMOTE $URL
git config core.sparsecheckout true

echo "" > .git/info/sparse-checkout
for tree in $*
do
    echo "$tree" >> .git/info/sparse-checkout
done

git fetch $REMOTE
git checkout -f $REVISION
git reset --hard HEAD
git clean -f
