_color_k   := \033[0;30m
_color_r   := \033[0;31m
_color_g   := \033[0;32m
_color_y   := \033[0;33m
_color_b   := \033[0;34m
_color_m   := \033[0;35m
_color_c   := \033[0;36m
_color_w   := \033[0;37m
_color_end := \033[0m

DOTFILES := $(realpath $(dir $(firstword $(MAKEFILE_LIST))))

targets = $(shell find $(DOTFILES) -mindepth 1 -maxdepth 1 -type d -not -name '.*' -printf '%P ')
clean_targets = $(patsubst %,%_clean,$(targets))
.PHONY: $(targets) $(clean_targets)

all: $(targets)

$(targets):%:
	@$(foreach file,$(shell find $(DOTFILES)/$* -type f -printf '%P '),\
		if [ ! -d $(HOME)/$(file) ] && [ ! -f $(HOME)/$(file) ]; then \
			if [ ! -d $(HOME)/$(dir $(file)) ]; then \
				printf "$(_color_c)[DIR]$(_color_end) "; \
				mkdir -pv $(HOME)/$(dir $(file)) | tail -n 1; \
			fi;\
			printf "$(_color_g)[LNK]$(_color_end) "; \
			ln -fsv $(DOTFILES)/$*/$(file) $(HOME)/$(file); \
		else \
			printf "$(_color_m)[IGN]$(_color_end) '$(HOME)/$(file)' already exists.\n"; \
		fi;\
	)

.PHONY: clean
clean: $(clean_targets)

$(clean_targets):%_clean:
	@$(foreach file,$(shell find $(DOTFILES)/$* -type f -printf '%P '),\
		if [ -L $(HOME)/$(file) ]; then \
			printf "$(_color_y)[DEL]$(_color_end) "; \
			rm -fv $(HOME)/$(file); \
		elif [ -e $(HOME)/$(file) ]; then \
			printf "$(_color_m)[IGN]$(_color_end) '$(HOME)/$(file)' is not a symlink.\n"; \
		fi;\
	)
