.PHONY: cover

BIN_PATH:=node_modules/.bin/

all:	bitcore-wallet-client-snowgem.min.js

clean:
	rm bitcore-wallet-client-snowgem.js
	rm bitcore-wallet-client-snowgem.min.js

bitcore-wallet-client-snowgem.js: index.js lib/*.js
	${BIN_PATH}browserify $< > $@

bitcore-wallet-client-snowgem.min.js: bitcore-wallet-client-snowgem.js
	uglify  -s $<  -o $@

cover:
	./node_modules/.bin/istanbul cover ./node_modules/.bin/_mocha -- --reporter spec test
