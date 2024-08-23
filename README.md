# Installation
## Requirements
- Fresh version of nvim
- fonts
- ripgrep
- php & composer

### Mac specific deps:

```
brew tap homebrew/cask-fonts
brew install --cask font-0xproto-nerd-font
brew install ripgrep
brew install gnu-sed
brew install php@8.0 composer
```

### Linux specific deps:
(Nerdfonts 0xProto)[https://github.com/ryanoasis/nerd-fonts/releases]

## Setup
Just clone into empty path as follows:
```
git clone git@github.com:krikus/nvim-config.git ~/.config/nvim
```

Install neovim with version > 0.8

```
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update
sudo apt install neovim
```

Install Packer

```
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
  ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```

Open neovim and type `:PackerInstall` (`:PackerSync`)

