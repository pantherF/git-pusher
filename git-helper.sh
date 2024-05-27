#!/bin/bash

function random_words() {
    random=$(shuf -i 1-10 -n 1)

    response=$(curl -s "https://random-word-api.herokuapp.com/word?number=$random")

    if [ $? -ne 0 ]; then
        echo "ERROR: Failed to fetch data from the API."
        exit 1
    fi

    if [ -z "$response" ]; then
        echo "ERROR: Empty response from the API."
        exit 1
    fi

    sentence=$(echo "$response" | jq -r '.[]' | tr '\n' ' ' | sed 's/ $//')

    if [ $? -ne 0 ]; then
        echo "ERROR: Failed to parse JSON."
        exit 1
    fi

    echo $sentence
}

RAND_NUM=$(shuf -i 5-10 -n 1)

if [ -z "$1" ]; then
    echo "ERROR: No project path provided."
    echo "Usage: $0 [project path] [commit-message] [branch]"
    exit 1
elif [ -n "$1" ]; then
  PROJECT_PATH="$1"
fi

if [ -z "$2" ]; then
    echo "WARNING: No commit message provided."
    echo "Usage: $0 [project path] [commit-message] [branch]"
    echo "INFO: generating random commit message."
    COMMIT_MESSAGE=$(random_words)
elif [ -n "$2" ]; then
  COMMIT_MESSAGE="$2"
fi

if [ -z "$3" ]; then
    echo "WARNING: No branch name provided."
    echo "Usage: $0 [project path] [commit-message] [branch]"
    echo "INFO: setting 'main' as the default branch."
    BRANCH_NAME="main"
elif [ -n "$3" ]; then
  BRANCH_NAME="$3"
fi

cd $PROJECT_PATH

git add .
git commit -m "$COMMIT_MESSAGE"
git push -u origin $BRANCH_NAME

echo "Execution complete."