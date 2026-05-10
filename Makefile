.DEFAULT_GOAL := help

.PHONY: install local-claude-rules local-zshrc

install: ## Set up this repository on a new machine
	@echo ">>> chezmoi dotfiles setup"
	@echo ""
	@if [ ! -f .chezmoidata.toml ]; then \
		echo "[1/4] Copying .chezmoidata.toml from .chezmoidata.toml.example..."; \
		cp .chezmoidata.toml.example .chezmoidata.toml; \
		echo "      Opening in $${EDITOR:-vim}. Fill in the values and save."; \
		$${EDITOR:-vim} .chezmoidata.toml; \
	else \
		echo "[1/4] .chezmoidata.toml already exists. Skipping."; \
	fi
	@echo ""
	@if [ ! -f dot_claude/settings.json ]; then \
		echo "[2/4] Copying dot_claude/settings.json from dot_claude/settings.json.example..."; \
		cp dot_claude/settings.json.example dot_claude/settings.json; \
	else \
		echo "[2/4] dot_claude/settings.json already exists. Skipping."; \
	fi
	@echo ""
	@echo "[3/4] Previewing changes (chezmoi diff):"
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
	@echo "[4/4] Install Homebrew packages"
	@printf "Run brew bundle --global? [y/N]: "; \
	read -r ans; \
	if [ "$$ans" = "y" ] || [ "$$ans" = "Y" ]; then \
		brew bundle --global; \
	else \
		echo "Skipped."; \
	fi
	@echo ""
	@echo ">>> Setup complete!"

local-claude-rules: ## Copy dot_claude/CLAUDE.local.md from example (machine-specific Claude Code rules)
	@if [ ! -f dot_claude/CLAUDE.local.md ]; then \
		echo "Copying dot_claude/CLAUDE.local.md from dot_claude/CLAUDE.local.md.example..."; \
		cp dot_claude/CLAUDE.local.md.example dot_claude/CLAUDE.local.md; \
	else \
		echo "dot_claude/CLAUDE.local.md already exists. Skipping."; \
	fi

local-zshrc: ## Copy dot_zshrc.local from example (machine-specific shell settings)
	@if [ ! -f dot_zshrc.local ]; then \
		echo "Copying dot_zshrc.local from dot_zshrc.local.example..."; \
		cp dot_zshrc.local.example dot_zshrc.local; \
	else \
		echo "dot_zshrc.local already exists. Skipping."; \
	fi

help: ## Show available make targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
