#!/usr/bin/env python

import os
import os.path
import shutil

def installFile(filename):
    home = os.environ['HOME']
    target = os.path.join(home, filename) 
    srcdir = os.path.dirname(os.path.abspath(__file__))
    src = os.path.join(srcdir, filename)
    if os.path.lexists(target):
        print "removing", target
        if os.path.isdir(target) and not os.path.islink(target):
            shutil.rmtree(target)
        else:
            os.remove(target)
    print "linking %s to %s" % (src, target)
    os.symlink(src, target)

if __name__ == '__main__':
    sources = [
            '.gitconfig',
            '.gitignore_global',
            '.vimrc',
            '.vim',
            '.inputrc',
            '.hgrc',
            '.hgignore_global',
            ]
    for f in sources:
        installFile(f)
