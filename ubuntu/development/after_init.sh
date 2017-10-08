#!/bin/bash

sudo dpkg-reconfigure locales && \
sudo dpkg-reconfigure tzdata && \
vim +PlugUpgrade +qa && vim +PlugInstall +qa

# TODO: Fix npm upgrade dependencies.
# gem update && npm i -g npm && npm -g update
