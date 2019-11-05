mergelines: src/merge.sh src/merger.mk
	cat $^ > $@
	chmod +x $@

.PHONY: clean
clean:
	rm -f mergelines