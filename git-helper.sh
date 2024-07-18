#!/bin/bash

usage() {
    echo "Example usage: $0 -p <project_path> -m [<commit_message>] -b [<branch>]"
    echo "  -p <project_path>     : Path to the application directory (required)"
    echo "  -m <commit_message>   : Commit message (default: random string of words)"
    echo "  -b <branch>           : Branch to checkout (default: main)"
    exit 1
}

APP_DIR=""
COMMIT_MESSAGE=""
BRANCH_NAME="main" # Default branch name

while getopts ":p:m:b:" opt; do
    case ${opt} in
        p)
            APP_DIR=$OPTARG
            ;;
        m)
            COMMIT_MESSAGE=$OPTARG
            ;;
        b)
            BRANCH_NAME=$OPTARG
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            usage
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            usage
            ;;
    esac
done

# Check required arguments
if [[ -z "$APP_DIR" ]]; then
    echo "ERROR: Project path is required."
    usage
fi

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

# Set commit message to random words if not provided
if [[ -z "$COMMIT_MESSAGE" ]]; then
    COMMIT_MESSAGE=$(random_words)
fi

cd $APP_DIR

git add .
git commit -m "$COMMIT_MESSAGE"
git push -u origin "$BRANCH_NAME"

echo "Execution complete."

