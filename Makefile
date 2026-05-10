.DEFAULT_GOAL := help

.PHONY: install
install: ## Set up this repository on a new machine
	@echo ">>> chezmoi dotfiles setup"
	@echo ""
	@if [ ! -f .chezmoidata.toml ]; then \
		echo "[1/5] Copying .chezmoidata.toml from .chezmoidata.toml.example..."; \
		cp .chezmoidata.toml.example .chezmoidata.toml; \
		echo "      Opening in $${EDITOR:-vim}. Fill in the values and save."; \
		$${EDITOR:-vim} .chezmoidata.toml; \
	else \
		echo "[1/5] .chezmoidata.toml already exists. Skipping."; \
	fi
	@echo ""
	@if [ ! -f dot_claude/settings.json ]; then \
		echo "[2/5] Copying dot_claude/settings.json from dot_claude/settings.json.example..."; \
		cp dot_claude/settings.json.example dot_claude/settings.json; \
	else \
		echo "[2/5] dot_claude/settings.json already exists. Skipping."; \
	fi
	@echo ""
	@if [ ! -f dot_zshrc.local ]; then \
		echo "[3/5] Copying dot_zshrc.local from dot_zshrc.local.example..."; \
		cp dot_zshrc.local.example dot_zshrc.local; \
	else \
		echo "[3/5] dot_zshrc.local already exists. Skipping."; \
	fi
	@echo ""
	@echo "[4/5] Previewing changes (chezmoi diff):"
	@echo "---"
	@chezmoi diff || true
	@echo "---"
	@printf "Run chezmoi apply? [y/N]: "; \
	read -r ans; \
	if [ "$$ans" = "y" ] || [ "$$ans" = "Y" ]; then \
		chezmoi apply -v; \
	else \
		echo "Skipped."; \
	fi
	@echo ""
	@echo "[5/5] Install Homebrew packages"
	@printf "Run brew bundle --global? [y/N]: "; \
	read -r ans; \
	if [ "$$ans" = "y" ] || [ "$$ans" = "Y" ]; then \
		brew bundle --global; \
	else \
		echo "Skipped."; \
	fi
	@echo ""
	@echo ">>> Setup complete!"

help: ## Show available make targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
