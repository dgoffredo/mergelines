mergelines: src/merge.sh src/merger.mk
	cat $^ > $@
	chmod +x $@