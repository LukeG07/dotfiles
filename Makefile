.PHONY: clean link

link: clean
	ln -s ${PWD}/nvim ~/.config/
	ln -s ${PWD}/wezterm.lua ~/.wezterm.lua

clean:
	rm -rf ~/.config/nvim
	rm -f ~/.wezterm.lua
