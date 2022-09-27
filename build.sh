#!/bin/bash

VERSION=$(cat VERSION)
docker build -t csegarragonz/dotfiles:${VERSION} .
