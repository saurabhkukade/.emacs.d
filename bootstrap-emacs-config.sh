#!/bin/bash
cp dot_emacs ~/.emacs
mkdir -p ~/.emacs.d
cp emacs.org ~/.emacs.d/
emacs -nw
