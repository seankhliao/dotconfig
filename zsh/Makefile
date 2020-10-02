all: clean .zshrc-merged

.zshrc-merged: zshenv .zshrc
	cat zshenv .zshrc > .zshrc-merged

.zshrc: setopt.zsh load.zsh zle.zsh alias.zsh function.zsh function_repo.zsh function_semver.zsh prompt.zsh completion.zsh zsh-syntax-highlighting.zsh remote
	@cat \
		setopt.zsh \
		load.zsh \
		zle.zsh \
		alias.zsh \
		function.zsh \
		function_repo.zsh \
		function_semver.zsh \
		prompt.zsh \
		completion.zsh \
		zsh-autosuggestions.zsh \
		zsh-syntax-highlighting.zsh \
		zsh-history-substring-search.zsh \
		> .zshrc

remote: zsh-autosuggestions.zsh zsh-history-substring-search.zsh

zsh-autosuggestions.zsh:
	@curl -sLO https://raw.githubusercontent.com/zsh-users/zsh-autosuggestions/master/zsh-autosuggestions.zsh

zsh-history-substring-search.zsh:
	@curl -sLO https://raw.githubusercontent.com/zsh-users/zsh-history-substring-search/master/zsh-history-substring-search.zsh

.PHONY: clean
clean:
	@rm zsh-autosuggestions.zsh zsh-history-substring-search.zsh || true
