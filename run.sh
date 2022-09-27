#!/bin/bash

VERSION=$(cat VERSION)
docker run -t -d --name dotfiles csegarragonz/dotfiles:${VERSION}
