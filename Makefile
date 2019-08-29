.PHONY: cover

BIN_PATH:=node_modules/.bin/

all:	bitcore-wallet-client-vidulum.min.js

clean:
	rm bitcore-wallet-client-vidulum.js
	rm bitcore-wallet-client-vidulum.min.js

bitcore-wallet-client-vidulum.js: index.js lib/*.js
	${BIN_PATH}browserify $< > $@

bitcore-wallet-client-vidulum.min.js: bitcore-wallet-client-vidulum.js
	uglify  -s $<  -o $@

cover:
	./node_modules/.bin/istanbul cover ./node_modules/.bin/_mocha -- --reporter spec test
