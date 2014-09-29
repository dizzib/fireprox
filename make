#!/bin/sh

lsc -o ./dist -cw *.ls &

cp -v LICENSE ./dist
kramdown README.md > ./dist/README.html

cd dist
npm install
npm prune

while read
do
  :
done
