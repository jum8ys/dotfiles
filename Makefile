.DEFAULT_GOAL := help

# Colors
BOLD   := \033[1m
DIM    := \033[2m
GREEN  := \033[32m
YELLOW := \033[33m
CYAN   := \033[36m
RESET  := \033[0m

.PHONY: install local-claude-rules local-zshrc

install: ## Set up this repository on a new machine
	@printf "$(BOLD)$(CYAN)▶ chezmoi dotfiles setup$(RESET)\n"
	@echo ""
	@printf "$(BOLD)[1/5] .chezmoidata.toml$(RESET)\n"
	@if [ ! -f .chezmoidata.toml ]; then \
		cp .chezmoidata.toml.example .chezmoidata.toml; \
		printf "      $(GREEN)✓ Created from example$(RESET)\n"; \
		printf "      Opening in $${EDITOR:-vim}. Fill in the values and save.\n"; \
		$${EDITOR:-vim} .chezmoidata.toml; \
	else \
		printf "      $(YELLOW)→ Already exists. Skipping.$(RESET)\n"; \
	fi
	@echo ""
	@printf "$(BOLD)[2/5] dot_claude/settings.json$(RESET)\n"
	@if [ ! -f dot_claude/settings.json ]; then \
		cp dot_claude/settings.json.example dot_claude/settings.json; \
		printf "      $(GREEN)✓ Created from example$(RESET)\n"; \
	else \
		printf "      $(YELLOW)→ Already exists. Skipping.$(RESET)\n"; \
	fi
	@echo ""
	@printf "$(BOLD)[3/5] chezmoi apply$(RESET)\n"
	@printf "$(DIM)"; printf '─%.0s' $$(seq 1 40); printf "$(RESET)\n"
	@chezmoi diff || true
	@printf "$(DIM)"; printf '─%.0s' $$(seq 1 40); printf "$(RESET)\n"
	@printf "Run chezmoi apply? [y/N]: "; \
	read -r ans; \
	if [ "$$ans" = "y" ] || [ "$$ans" = "Y" ]; then \
		chezmoi apply -v; \
		printf "$(GREEN)✓ Applied$(RESET)\n"; \
	else \
		printf "$(YELLOW)→ Skipped.$(RESET)\n"; \
	fi
	@echo ""
	@printf "$(BOLD)[4/5] Homebrew packages$(RESET)\n"
	@printf "Run brew bundle --global? [y/N]: "; \
	read -r ans; \
	if [ "$$ans" = "y" ] || [ "$$ans" = "Y" ]; then \
		brew bundle --global; \
		brew services start borders; \
		printf "$(GREEN)✓ Done$(RESET)\n"; \
	else \
		printf "$(YELLOW)→ Skipped.$(RESET)\n"; \
	fi
	@echo ""
	@printf "$(BOLD)[5/5] nix-darwin$(RESET)\n"
	@if ! command -v nix >/dev/null 2>&1; then \
		printf "      $(YELLOW)→ Nix not installed. Skipping.$(RESET)\n"; \
	elif [ ! -f $$HOME/.config/nix-darwin/flake.nix ]; then \
		printf "      $(YELLOW)→ ~/.config/nix-darwin/flake.nix not found (chezmoi apply may have been skipped). Skipping.$(RESET)\n"; \
	else \
		printf "Run sudo nix run nix-darwin -- switch --flake ~/.config/nix-darwin? [y/N]: "; \
		read -r ans; \
		if [ "$$ans" = "y" ] || [ "$$ans" = "Y" ]; then \
			backed_up=""; \
			backup_failed=0; \
			for f in /etc/bashrc /etc/zshrc; do \
				if [ -e "$$f" ] && [ ! -L "$$f" ]; then \
					if [ -e "$$f.before-nix-darwin" ]; then \
						printf "      $(YELLOW)→ $$f.before-nix-darwin already exists, leaving $$f as-is.$(RESET)\n"; \
					else \
						printf "      $(YELLOW)→ Backing up $$f to $$f.before-nix-darwin$(RESET)\n"; \
						if sudo mv "$$f" "$$f.before-nix-darwin"; then \
							backed_up="$$backed_up $$f"; \
						else \
							backup_failed=1; \
						fi; \
					fi; \
				fi; \
			done; \
			if [ "$$backup_failed" = "1" ]; then \
				printf "      $(YELLOW)⚠ Backup failed. Restoring and aborting.$(RESET)\n"; \
				for f in $$backed_up; do \
					if ! sudo mv "$$f.before-nix-darwin" "$$f"; then \
						printf "      $(YELLOW)⚠ Failed to restore $$f from $$f.before-nix-darwin. Please restore it manually.$(RESET)\n"; \
					fi; \
				done; \
				exit 1; \
			fi; \
			if sudo nix --extra-experimental-features "nix-command flakes" run nix-darwin -- switch --flake $$HOME/.config/nix-darwin; then \
				printf "      $(GREEN)✓ Done$(RESET)\n"; \
			else \
				printf "      $(YELLOW)⚠ Failed. See error above.$(RESET)\n"; \
				for f in $$backed_up; do \
					printf "      $(YELLOW)→ Restoring $$f$(RESET)\n"; \
					if ! sudo mv "$$f.before-nix-darwin" "$$f"; then \
						printf "      $(YELLOW)⚠ Failed to restore $$f from $$f.before-nix-darwin. Please restore it manually.$(RESET)\n"; \
					fi; \
				done; \
				exit 1; \
			fi; \
		else \
			printf "      $(YELLOW)→ Skipped.$(RESET)\n"; \
		fi; \
	fi
	@echo ""
	@printf "$(BOLD)$(GREEN)✓ Setup complete!$(RESET)\n"

local-claude-rules: ## Copy dot_claude/CLAUDE.local.md from example (machine-specific Claude Code rules)
	@if [ ! -f dot_claude/CLAUDE.local.md ]; then \
		cp dot_claude/CLAUDE.local.md.example dot_claude/CLAUDE.local.md; \
		printf "$(GREEN)✓ Created dot_claude/CLAUDE.local.md$(RESET)\n"; \
	else \
		printf "$(YELLOW)→ dot_claude/CLAUDE.local.md already exists. Skipping.$(RESET)\n"; \
	fi

local-zshrc: ## Copy dot_zshrc.local from example (machine-specific shell settings)
	@if [ ! -f dot_zshrc.local ]; then \
		cp dot_zshrc.local.example dot_zshrc.local; \
		printf "$(GREEN)✓ Created dot_zshrc.local$(RESET)\n"; \
	else \
		printf "$(YELLOW)→ dot_zshrc.local already exists. Skipping.$(RESET)\n"; \
	fi

help: ## Show available make targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
