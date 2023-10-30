#!/usr/bin/bash

convertFolderToSlides() {
  inputPath=$1

  echo "=== compiling Slides  ==="

  i=1
  numberOfFiles=$(find "$slidesOutputPath" -type f -name "*.adoc" | wc -l)
  [ ! -d "$inputPath/revealjs" ] && downloadReveal "$inputPath" "$slidesOutputPath"

  for f in $(find "$slidesOutputPath" -type f -name "*.adoc"); do
      imgFolder=$(evalPath "/documents/${f%/*}" "/documents/$baseOutputPath/images")
      revealFolder=$(evalPath "/documents/${f%/*}" "/documents/$slidesOutputPath/revealjs")

      echo "[$((i*100 / numberOfFiles)) %] compiling $f"
      convertFileToSlides "$f" "$imgFolder" "$revealFolder"

      i=$((i+1))
  done
}

convertFilesToSlides() {
  inputPath=$1
  asciidoctorVersion=$2

  downloadReveal $inputPath
  revealFolder="$inputPath/slides"

  docker run --rm \
         -v ${PWD}/$inputPath/slides:/documents \
         asciidoctor/docker-asciidoctor:$asciidoctorVersion /bin/bash -c "asciidoctor-revealjs \
         -r asciidoctor-diagram \
         -a icons=font \
         -a revealjs_theme=white \
         -a source-highlighter=rouge \
         -a imagesdir=images \
         -a revealjsdir=$revealFolder \
         -a revealjs_slideNumber=c/t \
         -a revealjs_transition=slide \
         -a revealjs_hash=true \
         -a sourcedir=src/main/java \
         -b revealjs \
         '**/*.adoc'"
}

downloadReveal() {
  inputPath=$1
  REVEAL_VERSION="5.0.0"
  REVEAL_DIR="$inputPath/slides"
  curl -L https://github.com/hakimel/reveal.js/archive/$REVEAL_VERSION.zip --output revealjs.zip
  unzip revealjs.zip
  mv reveal.js-$REVEAL_VERSION ./$REVEAL_DIR/revealjs
  cp -r "$inputPath/revealjs" "$outputPath/revealjs"
  rm revealjs.zip
}



convertFilesToHTML() {

    echo "=== compiling HTML  ==="
    echo $inputPath


    docker run --rm \
      -v ${PWD}/$inputPath/docs:/documents \
      asciidoctor/docker-asciidoctor:1.58 /bin/bash -c "asciidoctor \
      -r asciidoctor-diagram \
      -a icons=font \
      -a experimental=true \
      -a source-highlighter=rouge \
      -a rouge-theme=github \
      -a rouge-linenums-mode=inline \
      -a docinfo=shared \
      -a imagesdir=images \
      -a toc=left \
      -a toclevels=2 \
      -a sectanchors=true \
      -a sectnums=true \
      -a favicon=themes/favicon.png \
      -a sourcedir=src/main/java \
      -b html5 \
      '**/*.adoc'"

      rm -rf -v $inputPath/docs/*.adoc
      mv $inputPath/docs/* $inputPath
      rm $inputPath/docs

      tree

    #docker run --rm \
    #  -v ${PWD}/$inputPath:/documents \
    #  asciidoctor/docker-asciidoctor:1.58 /bin/bash -c "tree && ls -lh"
}
