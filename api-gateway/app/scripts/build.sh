#!/bin/bash

pnpm install
pnpm build

cd ../dist
mkdir ../../dist
zip -r ../../dist/app.zip .
