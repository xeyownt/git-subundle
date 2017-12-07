# git subundle
A wrapper around `git bundle` that supports bundling repositories with submodules.

Install
=======

Just run `make install` as root. Basically, you just have to install the script `git-subundle`
somewhere in your path

Usage
=====
Check `git subundle -h` for usage:

    NAME
            git subundle - Create bundle including submodules.
    
    SYNOPSYS
            git subundle [-h] [-b <name>] create [REPOSITORY] [BUNDLE_FILE]
            git subundle [-h] [-b <name>] unbundle [REPOSITORY] [BUNDLE_FILE]
            git subundle [-h] [-b <name>] reset [REPOSITORY]
    
    DESCRIPTION
            Create bundle 'BUNDLE_FILE.bundle' that contains also submodules.
    
            -b <name>
                    Use <name> as bundle remote name. If omitted, the default
                    remote name is 'bundle'.
    
            -h
                    Print this help.
    
            -d
                    Debug output.
    
    SEE ALSO
            git-bundle(1).

Tests
=====
The package come with some basic tests. Run `make test` to run them.
