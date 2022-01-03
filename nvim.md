# Installation of neovim

After having several problems, one way to rule them all to install neovim
regardless of the distro version we are using:
```bash
git clone https://github.com/neovim/neovim
cd neovim
make
sudo make install
pip3 install --upgrade --force-reinstall neovim
pip3 install pynvim
```
