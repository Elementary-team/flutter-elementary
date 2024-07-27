.PHONY: serve-docs

init-docs:
	@echo "Requires to have python and pip installed"
	@python3 -m venv $(HOME)/myenv
	@source $HOME/myenv/bin/activate
	@pip install mkdocs
	@pip install mkdocs-material

serve-docs:
	@cd documentation/elementary && source $(HOME)/myenv/bin/activate && mkdocs serve