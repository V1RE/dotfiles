# Dotfiles ⚙️

![Dotfiles in action](./dots.png)

## Requirements 📦

- Git
- Stow
- 5 minutes of your time

## Installation 🪄

Start by cloning this repository into your `$HOME` directory:

```bash
git clone https://github.com/V1RE/dotfiles.git ~
```

Now you can symlink these dotfiles to your `$HOME` using `stow`.

```bash
cd ~/dotfiles
stow */
```

If you're having problems with the `.git` directory getting symlinked to your
`$HOME` directory, try the following command:

```bash
cd ~/dotfiles
stow -D .git
```
