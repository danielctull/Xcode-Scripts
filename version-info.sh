#!/bin/bash

function current_branch {
    echo `git rev-parse --abbrev-ref HEAD`
}

function version_number {
    echo `git log --oneline | wc -l | tr -d ' '`
}

function tag_prefix {
    echo "build."
}

function previous_tag {
    TAG_PREFIX=$(tag_prefix)
    echo `git for-each-ref --sort=taggerdate --format '%(tag)' refs/tags | grep $TAG_PREFIX | tail -1`
}

function current_tag {
    echo "$(tag_prefix)$(version_number)"
}

function first_commit {
    echo `git rev-list --max-parents=0 HEAD`
}

function changelog {

    PREVIOUS_TAG=$(previous_tag)
    if [[ $PREVIOUS_TAG == "" ]]; then
        PREVIOUS_TAG="$(first_commit)"
    fi

    CHANGELOG=`git log $PREVIOUS_TAG..HEAD --merges --pretty=format:"* %s" --reverse | grep -v "$Merge branch"`    
    FIRST_CHARACTER=$(echo "$CHANGELOG" | head -c 1)
    if [[ "$FIRST_CHARACTER" != "*" ]]; then
        CHANGELOG="No release notes with this build."
    fi

    echo "$CHANGELOG"
}

echo "Version Number: $(version_number)"
echo "Previous Tag: $(previous_tag)"
echo "Current Tag: $(current_tag)"
echo "Changelog:
$(changelog)"
