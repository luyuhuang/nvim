# nvim

My personal Neovim configurations

## Installation

```sh
mkdir -p ~/.config
git clone https://github.com/luyuhuang/nvim.git ~/.config/nvim
cd ~/.config/nvim
git submodule init
git submodule update
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
```
