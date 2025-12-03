-include .env

#
# Development
#

test:
	uv run pytest

test-coverage:
	uv run pytest --cov=src/async_siril --cov-report=term-missing --cov-report=html

check:
	uv run ruff check
	@echo ""
	uv run ty check --output-format concise

format:
	uv run ruff format

# 
# Generators (tool)
# 

generate-commands:
	cd packages/siril-command-src && uv run export_commands.py --clean
	cd packages/siril-command-src && uv run merge_commands.py ../../src/async_siril/command.py

#
# Deployment
#

clean:
	echo "cleaning build folder..."
	rm -rf ./dist

build: clean
	# bump the version with `uv version --bump <major|minor|patch> OR uv version <version>`
	uv build --no-sources

publish:
	uv publish --token ${UV_PUBLISH_TOKEN}

# 
# Dockerized Siril
# 

build-docker:
	docker build -f Dockerfile.siril -t async-siril:latest .

run-docker:
	docker run --rm -it --name siril-test async-siril:latest
