.PHONY: clean
clean:
	xcodebuild -project DiscoverBook/DiscoverBook.xcodeproj -alltargets clean

.PHONY: test
test:
	osascript -e 'tell app "iPhone Simulator" to quit'
	xcodebuild -scheme "DiscoverBook" -configuration Debug -sdk iphonesimulator build TEST_AFTER_BUILD=YES

.PHONY: update
update:
	git submodule sync
	git submodule update --init --recursive

.PHONY: testflight
testflight:
	./DiscoverBook/scripts/testflight-deploy.sh 2> /tmp/testflight.error.log
	if ! grep -q "200 OK" /tmp/testflight.error.log; then echo "\n****\n** DEPLOY FAILED!!! **\n****"; cat /tmp/testflight.error.log; exit 1; fi
	echo "\n****\n** DEPLOY SUCCESSED **\n****"
