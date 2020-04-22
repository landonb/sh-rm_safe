# `sh-rm_safe`

Safe, dash-aware `rm` wrapper.

By *safe*, it "deletes" files by moving them non-destructively to `~/.trash`.

By *dash-aware*, you don't need to worry about using `--` before path values.

## Usage

You'll probably want this easily accessible.

I like to just shadow the builtin command, e.g.,

  ```shell
  $ alias rm=rm_safe
  ```

Then you can "delete" files like normal, e.g.,

  ```shell
  $ ls ~/.trash

  $ touch -- foo -bar --baz && ls
  -bar  --baz  foo

  $ rm -bar --baz foo

  $ ls ~/.trash
  -bar  --baz  foo
  ```

See, the files were just moved to `~/.trash`!

Also, you do not need to prevent options parsing of dash-prefixed names,
i.e., you do not need to call `rm -- -bar --baz foo`.

Note that running the command preserves previously-"deleted" files,
e.g.,

  ```shell
  $ ls ~/.trash
  -bar  --baz  foo

  $ touch -- foo -bar --baz

  $ rm foo -bar --baz

  $ ls ~/.trash
  -bar  -bar.2020_03_17_22h54m20s_237166859  --baz  --baz.2020_03_17...
  ```

To cleanup the trash directory, run `rm_rotate` periodically.
This moves `~/.trash` to `~/.trash-TBD`,
and it deletes the previous `~/.trash-TBD`.
(So you really have to run `rm_rotate` twice after the initial `rm`
to really delete a file!)

As an alternative, if you're serious about really deleting a file
or a directory, run `rmrm` (and harness the destructive power of
`/bin/rm -rf -- "$@"`).

## Installation

The author recommends cloning the repository and wiring its `bin/` to `PATH`.

You can also create symlink to the executables (`rm_safe`, `rm_rotate`, and `rmrm`)
from a location already on `PATH`, such as `~/.local/bin`.

Or you could clone the project and run the commands first to evaluate them,
before deciding how you want to wire it.

Alternatively, you might find that using a shell package manager, such as
[`bkpg`](https://github.com/bpkg/bpkg),
is more appropriate for your needs, e.g.,
`bpkg install -g landonb/sh-rm_safe`.

### Makefile install

The included `Makefile` can also be used to help install.

- E.g., you could clone this project somewhere and
  then run a `sudo make install` to install it globally:

  ```shell
  git clone https://github.com/landonb/sh-rm_safe.git
  cd sh-rm_safe
  # Install to /usr/local/bin
  sudo make install
  ```

- Specify a `PREFIX` to install anywhere else, such as locally, e.g.,

  ```shell
  # Install to $USER/.local/bin
  PREFIX=~/.local/bin make install
  ```

  And then ensure that the target directory is on the user's `PATH` variable.

  You could, for example, add the following to `~/.bashrc`:

  ```shell
  export PATH=$PATH:$HOME/.local/bin
  ```

### Manual install

If you clone the project and want the library commands to be easily
accessible (without a full path), remember to ensure that files can
be found on `PATH`, e.g.,

  ```shell
  git clone https://github.com/landonb/sh-rm_safe.git
  export PATH=$PATH:/path/to/sh-rm_safe/bin
  ```

Enjoy!

