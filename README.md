# How to make dotfiles working

## Install Home brew
_Better to follow the official site https://brew.sh_

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```


## Install Stow

```
brew install stow
```

## dotfiles
Clone the repo to home (~).
Inside the dotfiles use the command

```
stow --adopt .
```

## Terminal
This config is configure for [Allacritty](https://github.com/alacritty/alacritty)



# Other configs

## Install Starship
*Requirement* Nerd font "MesloLG Nerd Font" [here](https://www.nerdfonts.com/)

```
brew install starship
```


# Install Neo Vim

```
brew install nvim
```

To make the nvim working we need more things

```
brew install ripgrep
brew install fzf
brew install lazygit
```


## Install nvm
Better to follow the oficial GitHub [here](https://github.com/nvm-sh/nvm#installing-and-updating)
```
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
```

If want to use prettier in nvim install prettier global in the system
```
npm install -g prettier
```


## Install Zellij
```
brew install zellij
```


## Overwrite Apple git version
If using `git -v` show `git version x.x.x (Apple Git-xxx.x)`

```
brew install git
```

Overwrite git command
```
brew link --overwrite git
```

