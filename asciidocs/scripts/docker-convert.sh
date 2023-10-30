#!/usr/bin/bash

tree
inputPath="$1"
createSlides="$2"
source $inputPath/scripts/docker-convert-util.sh
slideInputPath="$inputPath/slides"
ASCIIDOCTOR_VERSION="1.58"

echo "input => $inputPath"
echo "slideInputPath => $slideInputPath"
echo "createSlides => $createSlides"
echo building html

if [ $createSlides = true ]; then
    convertFolderToSlides "$slideInputPath" $ASCIIDOCTOR_VERSION
fi

inputPath="$inputPath"

convertFilesToHTML "$inputPath"

# set permissions of output folder to the same as the input folder - fixes #1
#if [ -d "$inputPath" ] && [ -d "$outputPath" ]; then
#    chown $(stat "$inputPath" -c %u:%g) "$outputPath" -R
#fi
