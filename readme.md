# Dotfiles ⚙️

![Dotfiles in action](./dots.png)

## Requirements 📦

- Git
- macOS or another chezmoi-supported system

## Installation 🪄

Bootstrap a new machine with chezmoi:

```bash
sh -c "$(curl -fsLS https://get.chezmoi.io)" -- init --apply V1RE/dotfiles
```

Review pending changes later with:

```bash
chezmoi diff
```

Apply them with:

```bash
chezmoi apply
```
