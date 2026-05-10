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
	@printf "$(BOLD)[1/4] .chezmoidata.toml$(RESET)\n"
	@if [ ! -f .chezmoidata.toml ]; then \
		cp .chezmoidata.toml.example .chezmoidata.toml; \
		printf "      $(GREEN)✓ Created from example$(RESET)\n"; \
		printf "      Opening in $${EDITOR:-vim}. Fill in the values and save.\n"; \
		$${EDITOR:-vim} .chezmoidata.toml; \
	else \
		printf "      $(YELLOW)→ Already exists. Skipping.$(RESET)\n"; \
	fi
	@echo ""
	@printf "$(BOLD)[2/4] dot_claude/settings.json$(RESET)\n"
	@if [ ! -f dot_claude/settings.json ]; then \
		cp dot_claude/settings.json.example dot_claude/settings.json; \
		printf "      $(GREEN)✓ Created from example$(RESET)\n"; \
	else \
		printf "      $(YELLOW)→ Already exists. Skipping.$(RESET)\n"; \
	fi
	@echo ""
	@printf "$(BOLD)[3/4] chezmoi apply$(RESET)\n"
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
	@printf "$(BOLD)[4/4] Homebrew packages$(RESET)\n"
	@printf "Run brew bundle --global? [y/N]: "; \
	read -r ans; \
	if [ "$$ans" = "y" ] || [ "$$ans" = "Y" ]; then \
		brew bundle --global; \
		printf "$(GREEN)✓ Done$(RESET)\n"; \
	else \
		printf "$(YELLOW)→ Skipped.$(RESET)\n"; \
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
