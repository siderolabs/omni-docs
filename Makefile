.PHONY: docs-preview
docs-preview: ## Starts a local preview of the documentation using Hugo in docker
	@docker run --rm --interactive --tty \
	--volume $(PWD):/src --workdir /src \
	--publish 1313:1313 \
	klakegg/hugo:0.95.0-ext-alpine \
	server
