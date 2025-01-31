.PHONY: clean link

link: clean
	ln -s ~/dotfiles/nvim ~/.config/nvim
	ln -s ~/dotfiles/.wezterm.lua ~/.wezterm.lua

clean:
	rm -f ~/.config/nvim
	rm -f ~/.wezterm.lua
