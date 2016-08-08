PATH := /usr/local/bin:/usr/local/nginx/sbin:$(PATH)
test:
	@WORKDIR=$(shell pwd) /usr/bin/prove
mtest:
	@WORKDIR=$(shell pwd) TEST_NGINX_USE_VALGRIND=1 /usr/bin/prove

.PHONY: test
