#!/usr/bin/env make

# -- environ
PROJECT = ProjectName

# -- .env
ENV_FILE := ${PWD}/.env
$(eval include ${ENV_FILE})
$(eval export sed 's/=.*//' ${ENV_FILE})
IMAGE = react-native-android-compiler:v2021.09

# -- help
help:
	@echo "\n make [COMMAND]\n"
	@echo " * shell ... run container and show the shell"
	@echo " * new ..... create a project, ex: make new PROJECT=NAME"
	@echo " * start ... start metro, ex: make start PROJECT=NAME"
	@echo " * run ..... build release, ex: make start PROJECT=NAME\n\n"

# -- api
.PHONY: shell
shell:
	@$(cmd) sh -c 'cd $(PROJECT); bash;'
.PHONY: new
new:
	@$(cmd) sh -c 'npx react-native init $(PROJECT)'
.PHONY: start
start:
	@$(cmd) sh -c 'cd $(PROJECT); npx react-native start'
.PHONY: run
run:
	@$(cmd) sh -c 'cd $(PROJECT); yarn install; cd android; ./gradlew assembleRelease'

# -- build
.PHONY: build
build:
	@docker buildx build ${PWD} --progress plain --tag $(IMAGE) --target compiler
.PHONY: build-full
build-full:
	@docker buildx build ${PWD} --file ${PWD}/build.Dockerfile --progress plain --tag $(IMAGE)
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
cmd := docker run --rm -ti -w /home/reactnative -v ${PWD}:/home/reactnative $(IMAGE)
