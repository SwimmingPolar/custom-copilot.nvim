TESTS_INIT=tests/minimal_init.lua
TESTS_DIR=tests/

.PHONY: test, install

install:
	python3 venv venv \
	./venv/bin/activate \
	pip install -r requirements.txt

test:
	@nvim \
		--headless \
		--noplugin \
		-u ${TESTS_INIT} \
		-c "PlenaryBustedDirectory ${TESTS_DIR} { minimal_init = '${TESTS_INIT}' }"
