# My Dot Files 

## Purpose
The purpose of this repo is to make it easy to persist and replicate my dot files from one machine to another. The install and uninstall scripts help accomplish that

## Installation
**Note:** If you are not using BASH you will need to update the location of your rc_file variable in `generate_rc_entries.sh`

To install:
```shell
./install-dot-files.sh
# When this is done you will need to reload your shell once
```

**Recommended** run the install command in dry mode first to see plans
```shell
./install-dot-files.sh --dry
```

For additional usage try the help command
```shell
./install-dot-files.sh --help
```

## Uninstall
**Note:** Should something go terribly wrong with the uninstall command note that it will make a copy of your rc file before editing. `${HOME}/.your_rc_file-SAVE` this will allow you to recover from disaster by running
```shell
mv $HOME/.your_rc_file-SAVE $HOME/.your_rc_file
```

**Recommended** run the uninstall command in dry mode first to see plans
```shell
./uninstall-dot-files.sh --dry
```
Uninstall Command
```shell
./uninstall-dot-files.sh
```