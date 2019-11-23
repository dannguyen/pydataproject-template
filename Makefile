.DEFAULT_GOAL := help
.PHONY : clean help ALL

SQLIZED_DB = data/sqlized.sqlite
STUB_STASHED = data/stashed/hello.txt
STUB_WRANGLED = data/wrangled/hello.csv

help:
	@echo 'Run `make ALL` to see how things run from scratch'

ALL: clean sqlize


clean:
	@echo --- Cleaning
	test -f $(SQLIZED_DB)  && rm $(SQLIZED_DB) || true
	rm -f data/wrangled/hello.csv


# change sqlize task to do something else besides sqlize_bootstrap.sh,
# when you need something more sophisticated
sqlize: $(SQLIZED_DB)

# create data/sqlized/mydata.sqlite from CSVs in wrangled
$(SQLIZED_DB): wrangle
	@echo ""
	@echo --- Building $@
	@echo
	./scripts/sqlizeboot.sh \
		$(SQLIZED_DB) \
		data/wrangled

# wrangle task should ideally call wrangling scripts
# e.g. myfoo/wrangle/my_wrangler.py
wrangle: $(STUB_WRANGLED)

$(STUB_WRANGLED): $(STUB_STASHED)
	@echo ""
	@echo --- Wrangling $@
	@echo

	mkdir -p $(dir $@)
	cat $< | tr '\t' ',' > $@


