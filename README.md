# `sh-rm_safe`

Safe, hyphen-aware `rm` wrapper.

By *safe*, it "deletes" files by moving them non-destructively to
an intermediate `~/.trash` directory.

By *hyphen-aware*, you don't need to worry about using `--` before path values.

## Usage

You'll probably want this easily accessible.

I like to shadow the builtin `rm` command, e.g.,

  ```shell
  $ alias rm=rm_safe
  ```

Then you can "delete" files like normal, e.g.,

  ```shell
  $ ls ~/.trash0

  $ touch -- foo -bar --baz && ls
  -bar  --baz  foo

  $ rm -bar --baz foo

  $ ls ~/.trash0
  -bar  --baz  foo
  ```

See, the files were just moved to `~/.trash0`!

- Note you do not need to prevent options parsing of
  dash-prefixed names, i.e., you do not need to call
  `rm -- -bar --baz foo`.

- Note also this project uses a two-step trash procedure,
  first to `~/.trash0`, and then to `~/.trash` — or first
  to `~/.Trash0` on macOS, and then to `~/.Trash`.

  This lets you empty the trash, say, weekly, but ensures that
  any file you trash won't actually be deleted for at least week,
  giving you a little grace period in case you end up deleting
  something inadvertently.

The `rm_safe` command will not overwrite previously-"deleted" files
of the same name, e.g.,

  ```shell
  $ ls ~/.trash0
  -bar  --baz  foo

  $ touch -- foo -bar --baz

  $ rm foo -bar --baz

  $ ls ~/.trash0
  -bar  -bar.2020_03_17_22h54m20s_237166859  --baz  --baz.2020_03_17...
  ```

To cleanup the trash directory, run `rm_rotate` periodically.

- This deletes `~/.trash` and then renames `~/.trash0` to `~/.trash`.

  (So you really have to run `rm_rotate` twice after the initial `rm`
  to really delete a file!)

- As an alternative, if you're serious about really deleting a file
  or a directory, run `rmrm` (and harness the destructive power of
  `command rm -rf -- "$@"`).

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

Clone this project somewhere and then run `make install`:

- Specify a `PREFIX` to install under user home, e.g.,

  ```shell
  # Install to $USER/.local/bin
  PREFIX=~/.local/bin make install
  ```

  You'll obviously need to ensure that the target directory
  is on the user's `PATH` variable.

  You could, for example, add the following to `~/.bashrc`:

  ```shell
  export PATH=$PATH:$HOME/.local/bin
  ```

  The make-install command is very basic: it copies each
  of the shell scripts to the target directory.

- You could alternatively install systemwide using `sudo`,
  but you don't need to do this:

  ```shell
  git clone https://github.com/landonb/sh-rm_safe.git
  cd sh-rm_safe
  # Install to /usr/local/bin
  sudo make install
  ```

### Manual install

If you clone the project and want the library commands to be easily
accessible (without a full path), remember to ensure that files can
be found on `PATH`, e.g.,

  ```shell
  git clone https://github.com/landonb/sh-rm_safe.git
  export PATH=$PATH:/path/to/sh-rm_safe/bin
  ```

# Related projects

The [`trash`][hasseg-trash] command-line program for macOS (available [from Homebrew](https://formulae.brew.sh/formula/trash)) is an Objective-C app that uses Finder to trash files.

- See [*Trash files from the OS X command line*](https://hasseg.org/blog/post/406/trash-files-from-the-os-x-command-line/) for more details and alternative approaches.

[hasseg-trash]: https://hasseg.org/trash/

On Debian distros, the `trash` command from the [`trash-cli`][trash-cli]
package provides an interface to the same trash that your file manager uses
(generally found at `${XDG_DATA_HOME:-~/.local/share}/Trash`).

[trash-cli]: https://github.com/andreafrancia/trash-cli

You might enjoy using your desktop environment's trash if you'd like
to capture metadata about trashed files.

- For instance, when you use the GNOME *Nautilus* File Manager to
  delete a file, it tracks the previous file location and deletion
  date.

  - E.g., here's a look at the trash directory after
    removing a file using *Nautilus*:

        $ tree ~/.local/share/Trash
        /home/user/.local/share/Trash
        ├── files
        │   └── my-file
        └── info
        └── my-file.trashinfo

        $ cat ~/.local/share/Trash/info/my-file.trashinfo
        [Trash Info]
        Path=/home/user/Documents/my-file
        DeletionDate=2025-09-26T21:37:23
