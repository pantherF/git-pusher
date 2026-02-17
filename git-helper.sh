#!/bin/bash

usage() {
    echo "  -h                    : This usage dialog"
    echo "  -p <project_path>     : Path to the application directory (default: current directory)"
    echo "  -m <commit_message>   : Commit message (default: random string of words)"
    echo "  -b <branch>           : Branch to checkout (default: main)"
    echo " "
    echo "Example usage: $0 -p [project_path] -m [commit_message] -b [branch]"
    exit 1
}

APP_DIR=""
COMMIT_MESSAGE=""
BRANCH_NAME="main" # Default branch name

while getopts ":p:m:b:h" opt; do
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
	h)
	    usage
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

if [[ -z "$APP_DIR" ]]; then
    cd $APP_DIR
fi

echo "Currently in directory:"
pwd

git add .
git commit -m "$COMMIT_MESSAGE"
git push -u origin "$BRANCH_NAME"

echo "Execution complete."

