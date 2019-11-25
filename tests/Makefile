MAKEFILE_PATH = $(strip $(dir $(firstword $(MAKEFILE_LIST))))

.PHONY: package_shell_all_tests

package_shell_all_tests: \
	ias_package_shell_test_package_a \
	ias_package_shell_test_package_basic \
	ias_package_shell_test_fresh_package \
	ias_package_shell_package_division_test

.PHONY: ias_package_shell_package_division_test
ias_package_shell_package_division_test:
	cd $(MAKEFILE_PATH)/ias_package_shell_package_division_test \
	&& make release \
	&& fakeroot make package-deb \
	&& fakeroot make package-rpm \
	&& make clean \
	&& export ARTIFACT_NAME=ias-package-shell-package-division-test-lib \
	&& fakeroot make package-deb \
	&& fakeroot make package-rpm \
	&& make clean \
	&& export ARTIFACT_NAME=ias-package-shell-package-division-test-bin \
	&& fakeroot make package-deb \
	&& fakeroot make package-rpm \
	&& make clean \
	&& export ARTIFACT_NAME=ias-package-shell-package-division-test-cgi-bin \
	&& fakeroot make package-deb \
	&& fakeroot make package-rpm \
	&& make clean

.PHONY: ias_package_shell_test_package_basic
ias_package_shell_test_package_basic:
	cd $(MAKEFILE_PATH)/ias_package_shell_test_package_basic \
	&& make release \
	&& fakeroot make package-deb \
	&& fakeroot make package-rpm \
	&& make clean

.PHONY: ias_package_shell_test_package_a
ias_package_shell_test_package_a:
	cd $(MAKEFILE_PATH)/ias_package_shell_test_package_a \
	&& make release \
	&& fakeroot make package-deb \
	&& fakeroot make package-rpm \
	&& make clean

.PHONY: ias_java_test_a
ias_java_test_a:
	cd $(MAKEFILE_PATH)/ias_java_test_a \
	&& make release \
	&& make java-compile \
	&& make java-run \
	&& fakeroot make package-deb \
	&& fakeroot make package-rpm \
	&& make java-clean \
	&& make clean

.PHONY: ias_package_shell_test_fresh_package
ias_package_shell_test_fresh_package:
	cat "$(MAKEFILE_PATH)/answers_ias_package_shell_test_fresh_package.txt" \
	| ../src/bin/ias_package_shell.pl \
	&& chmod +x ias_package_shell_test_fresh_package/*.sh \
	&& chmod +x ias_package_shell_test_fresh_package/src/bin/*.sh \
	&& cd ias_package_shell_test_fresh_package \
	&& make release \
	&& fakeroot make package-deb \
	&& fakeroot make package-rpm
	rm -rf ias_package_shell_test_fresh_package
