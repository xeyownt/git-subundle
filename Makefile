.SILENT:

.PHONY: install
install: git-subundle
	cp -v $< /usr/local/bin 2> /dev/null || echo "ERROR: You need to be root to install"

.PHONY: clean
clean:
	./run.sh clean

.PHONY: test
test:
	./run.sh
