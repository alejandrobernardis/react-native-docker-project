#!/usr/bin/env make

# -- environ
PROJECT = ProjectName

# -- .env
ENV_FILE := ${PWD}/.env
$(eval include ${ENV_FILE})
$(eval export sed 's/=.*//' ${ENV_FILE})
IMAGE = react-native-android-compiler:v2021.9.5.1

# -- help
help:
	@echo ''
	@echo 'make [COMMAND]'
	@echo ''
	@echo 'COMMANDS:'
	@echo '  shell ..... Run container and show the shell'
	@echo '  init ...... Create a project, ex: make new PROJECT=NAME'
	@echo '  start ..... Start metro, ex: make start PROJECT=NAME'
	@echo '  release ... Build release, ex: make release PROJECT=NAME'
	@echo '  debug ..... Build debug, ex: make debug PROJECT=NAME'

# -- api
.PHONY: shell
shell:
	@$(cmd) sh -c 'cd $(PROJECT); bash;'
.PHONY: init
init:
	@$(cmd) sh -c 'npx react-native init $(PROJECT)'
.PHONY: start
start:
	@$(cmd) sh -c 'cd $(PROJECT); npx react-native start'
.PHONY: release
release:
	@$(cmd) sh -c 'cd $(PROJECT); yarn install; cd android; ./gradlew assembleRelease'
.PHONY: debug
debug:
	@$(cmd) sh -c 'cd $(PROJECT); yarn install; cd android; ./gradlew assembleDebug'


# -- build
.PHONY: build
build:
	@docker buildx build ${PWD} --progress plain --tag $(IMAGE)
.PHONY: clear
clear:
	@sudo rm -fr ${PWD}/.android
	@sudo rm -fr ${PWD}/.cache
	@sudo rm -fr ${PWD}/.config
	@sudo rm -fr ${PWD}/.gradle
	@sudo rm -fr ${PWD}/.npm
	@sudo rm -fr ${PWD}/.yarn
	@sudo rm -fr ${PWD}/.yarnrc
	@sudo rm -f ${PWD}/.bash_*

# -- helpers
docker := $(shell command -v docker 2>/dev/null)
ifdef docker
	cmd := $(docker) run --rm -ti -w /home/reactnative -v ${PWD}:/home/reactnative $(IMAGE)
endif
