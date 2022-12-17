#!/bin/bash

# Set LibreWolf chrome folder path
chromePath="/Users/dennis/Library/Application Support/librewolf/Profiles/dqpufw27.default-default/chrome"

# Set local style repository path
repoPath="/Users/dennis/Documents/DennisDokumente/Coding/LibreWolfCSS"

# Set url to remote repository with the style sheets
gitURL="https://github.com/DennisIguess/LibreWolfStyles"

cd "$repoPath"

echo "Checking remote repository..."
if ! git ls-remote --exit-code "$gitURL" > /dev/null; then
    echo "Cannot find repository, exiting"
    exit 0
fi
echo "Repository valid!"

echo "Generating list of available themes..."
ls -d */ > availableThemes.txt

echo "These themes are currently available:"
cat availableThemes.txt

echo "Enter the full name of the theme as seen on the git repo: "
read theme

if ! grep -q "'$theme'" availableThemes.txt; then
    echo "This theme is not  available. Exiting"
    exit 0
fi

echo "'$theme' selected, preparing chrome folder: '$chromePath'"
cd "$chromePath"

echo "These files are about to be deleted, are you sure? [y or n]"
ls -lAh .
read sure

if [ "$sure" != "y" ]; then
    echo "Exiting script, nothing was deleted" && exit 0
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

echo "New theme applied!"
exit 0