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

Example
=======

*   First create a bundle on the source PC. This assumes a git repository named `repo`:

    ```bash
    # On first PC
    git subundle create repo
    tar czf bundle.tgz *.bundle
    rm *.bundle
    ```

*   Transfer `bundle.tgz` to remote PC. Then:

    ```bash
    # On remote PC
    tar xf bundle.tgz
    git subundle -f unbundle repo
    rm bundle.tgz *.bundle
    ```

*   After creating some commit on the remote PC, we transfer back the changes to the source PC. 
    This will only transfer the new commits

    ```bash
    # On remote PC
    git subundle create repo
    tar czf bundle.tgz *.bundle
    rm *.bundle
    ```

*   We import the changes on the source PC. From that point on, creating a new bundle on the source PC
    will only include new commits not available on the remote PC

    ```bash
    # On source PC
    tar xf bundle.tgz
    git subundle -f unbundle repo
    rm bundle.tgz *.bundle
    ```

Tests
=====
The package come with some basic tests. Run `make test` to run them.
