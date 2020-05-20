.DEFAULT_GOAL := help
.PHONY : clean help ALL

SQLIZED_DB = data/wrapped/sqlized.sqlite
STUB_WRANGLED = data/wrangled/helloworld.csv
STUB_FUSED = data/compiled/helloworld.csv
STUB_COLLECTED = data/collected/hello.txt \
			   data/collected/world.txt

help:
	@echo 'Run `make ALL` to see how things run from scratch'

ALL: clean sqlize


clean: clean_sqlize
	@echo --- Cleaning stubs
	rm -f $(STUB_WRANGLED)
	rm -f $(STUB_FUSED)
	rm -f $(STUB_COLLECTED)


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
      $(SQLIZED_DB) data/compiled compiled

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
# e.g. mypkg/wrangle/my_wrangler.py
wrangle: $(STUB_WRANGLED)

$(STUB_WRANGLED): compile ./scripts/wrangle.py
	@echo ""
	@echo --- Wrangling $@
	@echo

	./scripts/wrangle.py


compile: $(STUB_FUSED)

$(STUB_FUSED): collect ./scripts/compile.py
	@echo ""
	@echo --- Collating $@

	./scripts/compile.py


collect:
	@echo "Gathers $(STUB_COLLECTED)"
	./scripts/collect.py
