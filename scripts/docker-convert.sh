#!/usr/bin/bash

tree
source scripts/docker-convert-util.sh
inputPath="$1"
outputPath="$2"
createSlides="$3"
slideInputPath="$inputPath/slides"
slideOutputPath="$outputPath/slides"

echo "input => $inputPath"
echo "output => $outputPath"
echo "slideInputPath => $slideInputPath"
echo "slideOutputPath => $slideOutputPath"
echo building html

mkdir $outputPath
cp -r $inputPath/* $outputPath

echo "createSlides => $createSlides"

if [ $createSlides = true ]; then
    convertFolderToSlides "$slideInputPath" "$slideOutputPath" "$outputPath"
fi

inputPath="$inputPath"
outputPath="$outputPath"

convertFolderToHTML "$outputPath"

# set permissions of output folder to the same as the input folder - fixes #1
if [ -d "$inputPath" ] && [ -d "$outputPath" ]; then
    chown $(stat "$inputPath" -c %u:%g) "$outputPath" -R
fi
