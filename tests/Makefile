MAKEFILE_PATH = $(strip $(dir $(firstword $(MAKEFILE_LIST))))

.PHONY: package_shell_all_tests

package_shell_all_tests: \
	ias_package_shell_test_package_a \
	ias_package_shell_test_package_basic \
	ias_package_shell_test_fresh_package \
	ias_package_shell_package_division_test

.PHONY: ias_package_shell_package_division_test
ias_package_shell_package_division_test:
	cd "$(MAKEFILE_PATH)/ias_package_shell_package_division_test" \
	&& make -f artifacts/ias-package-shell-package-division-test/package_shell.gmk artifact_release \
	&& fakeroot make package-deb \
	&& fakeroot make package-rpm 

.PHONY: ias_package_shell_test_package_basic
ias_package_shell_test_package_basic:
	cd "$(MAKEFILE_PATH)/ias_package_shell_test_package_basic" \
	&& make -f artifacts/*/package_shell.gmk artifact_release \
	&& fakeroot make package-deb \
	&& fakeroot make package-rpm \
	&& make clean

.PHONY: ias_package_shell_test_package_a
ias_package_shell_test_package_a:
	cd "$(MAKEFILE_PATH)/ias_package_shell_test_package_a" \
	&& make -f artifacts/*/package_shell.gmk artifact_release \
	&& fakeroot make package-deb \
	&& fakeroot make package-rpm \
	&& make clean

.PHONY: ias_java_test_a
ias_java_test_a:
	cd "$(MAKEFILE_PATH)/ias_java_test_a" \
	&& make -f artifacts/*/package_shell.gmk artifact_release \
	&& make java-compile \
	&& make java-run \
	&& fakeroot make package-deb \
	&& fakeroot make package-rpm \
	&& make java-clean \
	&& make clean

.PHONY: ias_package_shell_test_fresh_package
ias_package_shell_test_fresh_package:
	-rm -rf ias_package_shell_test_fresh_package
	cat "$(MAKEFILE_PATH)/answers_ias_package_shell_test_fresh_package.txt" \
	| ../src/bin/ias_package_shell.pl \
	&& cd ias_package_shell_test_fresh_package \
	&& make -f artifacts/*/package_shell.gmk artifact_release \
	&& fakeroot make package-deb \
	&& fakeroot make package-rpm
