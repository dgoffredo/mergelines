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
	@sort -u -o $(OUTPUT) $^ # merge/uniq the temporary files into the output

$(WORKDIR)/%: $(INDIR)/%
	@sed '/^\s*$$/d' $< > $@  # remove empty lines
	@sort -c $@               # check that the input is sorted
	@sort -u -o $@ $@         # sort/uniq the input into a temporary file