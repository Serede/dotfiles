DOTFILES := $(shell pwd)

_compton = .config/compton.conf
_fcitx = .config/fcitx/config
_gtk2 = .gtkrc-2.0
_gtk3 = .config/gtk-3.0/settings.ini
_i3 = .config/i3/config .config/i3/i3blocks.conf .config/i3/scripts/swap.py
_nvim = .config/nvim/init.vim
_rofi = .config/rofi/config.rasi .config/rofi/scripts/calc
_trizen = .config/trizen/trizen.conf
_ctags = .ctags
_git = .git_template/hooks/ctags .git_template/hooks/post-checkout .git_template/hooks/post-commit .git_template/hooks/post-merge .git_template/hooks/post-rewrite .gitconfig .gitignore_global
_psql = .psqlrc
_ssh = .ssh/config
_tmux = .tmux.conf .tmux/tmuxline.conf
_vim = .vimrc
_zsh = .zshrc

compton = $(patsubst %, ${HOME}/%, $(_compton))
fcitx = $(patsubst %, ${HOME}/%, $(_fcitx))
gtk2 = $(patsubst %, ${HOME}/%, $(_gtk2))
gtk3 = $(patsubst %, ${HOME}/%, $(_gtk3))
i3 = $(patsubst %, ${HOME}/%, $(_i3))
nvim = $(patsubst %, ${HOME}/%, $(_nvim))
rofi = $(patsubst %, ${HOME}/%, $(_rofi))
trizen = $(patsubst %, ${HOME}/%, $(_trizen))
ctags = $(patsubst %, ${HOME}/%, $(_ctags))
git = $(patsubst %, ${HOME}/%, $(_git))
psql = $(patsubst %, ${HOME}/%, $(_psql))
ssh = $(patsubst %, ${HOME}/%, $(_ssh))
tmux = $(patsubst %, ${HOME}/%, $(_tmux))
vim = $(patsubst %, ${HOME}/%, $(_vim))
zsh = $(patsubst %, ${HOME}/%, $(_zsh))

all: compton fcitx gtk3 gtk2 i3 nvim rofi trizen ctags git psql ssh tmux vim zsh

compton: $(compton)
fcitx: $(fcitx)
gtk3: $(gtk3)
gtk2: $(gtk2)
i3: $(i3)
nvim: $(nvim)
rofi: $(rofi)
trizen: $(trizen)
ctags: $(ctags)
git: $(git)
psql: $(psql)
ssh: $(ssh)
tmux: $(tmux)
vim: $(vim)
zsh: $(zsh)

${HOME}/%:
	@mkdir -pv $(dir $@)
	@ln -sfv $(patsubst ${HOME}/%, $(DOTFILES)/%, $@) $@

.PHONY: clean
clean:
	@rm -frv $(compton)
	@rm -frv $(fcitx)
	@rm -frv $(gtk3)
	@rm -frv $(gtk2)
	@rm -frv $(i3)
	@rm -frv $(nvim)
	@rm -frv $(rofi)
	@rm -frv $(trizen)
	@rm -frv $(ctags)
	@rm -frv $(git)
	@rm -frv $(psql)
	@rm -frv $(ssh)
	@rm -frv $(tmux)
	@rm -frv $(vim)
	@rm -frv $(zsh)
