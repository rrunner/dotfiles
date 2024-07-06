# My dotfiles

Managed with GNU Stow.

## Dependencies

- git
- stow

## Basic usage
### Create symlinks using package name

```bash
stow <package>
```
or
```bash
stow -R <package>
```
to re-stow

### Restore dotfiles on remote system

1. Clone the repo to local ~/dotfiles folder.

```bash
git clone --recursive https://github.com/rrunner/dotfiles ~/dotfiles
```

2. Restore symlinks

```bash
cd ~/dotfiles
stow <each individual package>
```

or all of them

```bash
cd ~/dotfiles
for i in "$(ls -d */)"; do
    stow "$i"
done
```
