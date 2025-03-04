# Global variables
MODULES := $(wildcard modules/*/*)
INSTALL_SCRIPTS := $(wildcard modules/*/*/install.sh)

# Colors
GREEN=\033[32m
RED=\033[31m
YELLOW=\033[33m
BLUE=\033[36m
ORANGE1=\033[38;5;208m
ORANGE2=\033[38;5;202m
RESET=\033[0m

# Logging
LOG = echo -e "${BLUE}[MAKE]${RESET}"

.PHONY: install $(notdir $(MODULES)) uninstall

install:
	@$(LOG) "${BLUE}Installing all modules...${RESET}"
	@for script in $(INSTALL_SCRIPTS); do \
		module=$$(basename $$(dirname $$script)); \
		category=$$(basename $$(dirname $$(dirname $$script))); \
		$(LOG) "${YELLOW}Installing${RESET} ${ORANGE2}$$category${RESET} ${ORANGE1}$$module${RESET}..."; \
		bash $$script install; \
	done

$(notdir $(MODULES)):
	@FOUND_SCRIPT=$$(find modules -type f -path "*/$@/install.sh"); \
	if [ -n "$$FOUND_SCRIPT" ]; then \
		category=$$(basename $$(dirname $${FOUND_SCRIPT})); \
		$(LOG) "${YELLOW}Installing${RESET} ${ORANGE2}$$category${RESET} ${ORANGE1}$$@${RESET}..."; \
		bash $$FOUND_SCRIPT install; \
	else \
		$(LOG) "${RED}Module $@ not found!${RESET}"; \
		exit 1; \
	fi

uninstall:
	@$(LOG) "${BLUE}Uninstalling all modules...${RESET}"
	@for script in $(INSTALL_SCRIPTS); do \
		module=$$(basename $$(dirname $$script)); \
		category=$$(basename $$(dirname $$(dirname $$script))); \
		$(LOG) "${YELLOW}Uninstalling${RESET} ${ORANGE2}$$category${RESET} ${ORANGE1}$$module${RESET}..."; \
		bash $$script uninstall; \
	done

# this is if you want to install modules as gui/other (not names conflicts)
# %:
# 	@FOUND_SCRIPT="modules/$*/install.sh"; \
# 	if [ -f "$$FOUND_SCRIPT" ]; then \
# 		category=$$(dirname $*); \
# 		module=$$(basename $*); \
# 		$(LOG) "${YELLOW}Installing${RESET} ${ORANGE2}$$category${RESET} ${ORANGE1}$$module${RESET}..."; \
# 		bash $$FOUND_SCRIPT; \
# 	else \
# 		$(LOG) "${RED}Module $* not found!${RESET}"; \
# 		exit 1; \
# 	fi