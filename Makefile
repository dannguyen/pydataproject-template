.DEFAULT_GOAL := help
.PHONY : clean help ALL

SQLIZED_DB = data/myfoo.sqlite
STUB_WRANGLED = data/wrangled/helloworld.csv
STUB_COLLATED = data/collated/helloworld.csv
STUB_STASHED = data/stashed/hello.txt \
			   data/stashed/world.txt

help:
	@echo 'Run `make ALL` to see how things run from scratch'

ALL: clean sqlize


clean: clean_sqlize
	@echo --- Cleaning stubs
	rm -f $(STUB_WRANGLED)
	rm -f $(STUB_COLLATED)


clean_sqlize:
	test -f $(SQLIZED_DB)  && rm $(SQLIZED_DB) || true

# change sqlize task to do something else besides sqlize_bootstrap.sh,
# when you need something more sophisticated
sqlize: $(SQLIZED_DB)
# create data/sqlized/mydata.sqlite from CSVs in wrangled
$(SQLIZED_DB): wrangle clean_sqlize
	@echo ""
	@echo --- SQLizing tables $@
	@echo
	./scripts/sqlize.sh \
      $(SQLIZED_DB) data/collated collated

	@echo ""
	@echo "---"
	./scripts/sqlize.sh \
      $(SQLIZED_DB) data/wrangled wrangled


	@echo ""
	@echo ""
	@echo ""
	@echo "--- Open database with this command:"
	@echo ""
	@echo "      " open $(SQLIZED_DB)


# wrangle task should ideally call wrangling scripts
# e.g. myfoo/wrangle/my_wrangler.py
wrangle: $(STUB_WRANGLED)

$(STUB_WRANGLED): $(STUB_COLLATED) ./scripts/wrangle.py
	@echo ""
	@echo --- Wrangling $@
	@echo

	./scripts/wrangle.py


collate: $(STUB_COLLATED)

$(STUB_COLLATED): $(STUB_STASHED) ./scripts/collate.py
	@echo ""
	@echo --- Collating $@

	./scripts/collate.py

