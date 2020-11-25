.PHONY=help
help:
	@echo "available targets -->\n"
	@cat Makefile | grep ".PHONY" | python3 -c 'import sys; sys.stdout.write("".join(list(map(lambda line: line.replace(".PHONY"+"=", "") if (".PHONY"+"=") in line else "", sys.stdin))))'

.PHONY=update-gettext-version
update-gettext-version:
	scripts/latest-gettext.sh | tee GETTEXT_VERSION
	git diff GETTEXT_VERSION

.PHONY=bump-build-number
bump-build-number:
	scripts/bump-build-number.sh

.PHONY=image
image:
	docker build . -t daxxog/gnu-envsubst:latest --build-arg GETTEXT_VERSION=$$(cat GETTEXT_VERSION)

.PHONY=debug
debug: image
	docker run -i -t daxxog/gnu-envsubst:latest /bin/bash

.PHONY=test
test: image
	cat test/test-data1.txt | \
		docker run \
		-e TEST1=HELLO \
		-e TEST2=world \
		-i -a stdin -a stdout \
		daxxog/gnu-envsubst:latest \
		| grep -q "HELLO world"

.PHONY=tag
tag: image test bump-build-number
	@echo tagging version daxxog/gnu-envsubst:$$(cat GETTEXT_VERSION)-build$$(cat BUILD_NUMBER)
	docker tag daxxog/gnu-envsubst:latest daxxog/gnu-envsubst:$$(cat GETTEXT_VERSION)
	docker tag daxxog/gnu-envsubst:latest daxxog/gnu-envsubst:$$(cat GETTEXT_VERSION)-build$$(cat BUILD_NUMBER)
	git add BUILD_NUMBER
	git commit -m "tagging build number $$(cat BUILD_NUMBER)"
	git push
	git tag -a "$$(cat GETTEXT_VERSION)-build$$(cat BUILD_NUMBER)" -m "tagging version $$(cat GETTEXT_VERSION)-build$$(cat BUILD_NUMBER)"
	git push origin $$(cat BUILD_NUMBER)

.PHONY=push
push: tag
	docker push daxxog/gnu-envsubst:latest
	docker push daxxog/gnu-envsubst:$$(cat GETTEXT_VERSION)
	docker push daxxog/gnu-envsubst:$$(cat GETTEXT_VERSION)-build$$(cat BUILD_NUMBER)
	echo daxxog/gnu-envsubst:$$(cat GETTEXT_VERSION)-build$$(cat BUILD_NUMBER)
