.PHONY=help
help:
	@echo "available targets -->\n"
	@cat Makefile | grep ".PHONY" | python3 -c 'import sys; sys.stdout.write("".join(list(map(lambda line: line.replace(".PHONY"+"=", "") if (".PHONY"+"=") in line else "", sys.stdin))))'

.PHONY=update-gettext-version
update-gettext-version:
	scripts/latest-gettext.sh | tee GETTEXT_VERSION
	git diff GETTEXT_VERSION
