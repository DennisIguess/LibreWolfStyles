#!/bin/bash

# Set LibreWolf chrome folder path
chromePath="/Users/dennis/Library/Application Support/librewolf/Profiles/dqpufw27.default-default/chrome"

# Set local style repository path
repoPath="/Users/dennis/Documents/DennisDokumente/Coding/LibreWolfCSS"

# Set url to remote repository with the style sheets
gitURL="https://github.com/DennisIguess/LibreWolfStyles"

# Set color escape characters
RED='\033[0;31m'
GREEN='\033[0;32m'
NOCOLOR='\033[0m'

cd "$repoPath"

echo "Checking remote repository..."
if ! git ls-remote --exit-code "$gitURL" > /dev/null; then
    read -p "Cannot find repository, exiting"
    exit 0
fi
echo -e "${GREEN}Repository valid!${NOCOLOR}"

echo "Updating local repo..."
git pull origin main

echo "These themes are currently available:"
ls -d */

echo -e "Enter the full name of the theme as seen above ${RED}EXCLUDING${NOCOLOR} trailing /:"
read theme

if ! test -d "$theme"; then
    read -p "This theme is not  available. Exiting"
    exit 0
fi

echo "'$theme' selected, preparing chrome folder: '$chromePath'"
cd "$chromePath"

echo "These files are about to be deleted, are you sure? [y or n]"
ls -lAh .
read sure

if [ "$sure" != "y" ]; then
    read -p "Exiting script, nothing was deleted"
    exit 0
fi

echo "Clearing chrome folder"
cd ..
rm -rf chrome
mkdir chrome
cd chrome


echo "Cloning repository in clean chrome folder" 
git clone "$gitURL" .
find . -mindepth 1 -maxdepth 1 -not -name "$theme" -print0 | xargs -0 -r rm -rf
mv "$theme"/* .
rm -r "$theme"

read -p "New theme applied!"
exit 0