# Expected input variables
# ========================
# INDIR: the input directory
# OUTPUT: the output file
# WORKDIR: a (temporary) working directory for intermediate results

INDIR ?= .
OUTPUT ?= result

INPUTS = $(wildcard $(INDIR)/*)
SORTIES = $(patsubst $(INDIR)/%, $(WORKDIR)/%, $(INPUTS))

.PHONY: $(OUTPUT)
$(OUTPUT): $(SORTIES)
	@sort --unique --merge --output=$(OUTPUT) $^ # merge/uniq temporary files

$(WORKDIR)/%: $(INDIR)/%
	@sed '/^\s*$$/d' $< > $@       # remove empty lines into a temporary file
	@sort --check $@               # check that the input is sorted