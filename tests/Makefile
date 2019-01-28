MAKEFILE_PATH = $(strip $(dir $(firstword $(MAKEFILE_LIST))))

.PHONY: package_shell_all_tests

package_shell_all_tests: \
	ias_package_shell_test_package_a \
	ias_package_shell_test_package_basic \
	ias_java_test_a

.PHONY: ias_package_shell_test_package_basic
ias_package_shell_test_package_basic:
	cd $(MAKEFILE_PATH)/ias_package_shell_test_package_basic \
	&& make clean \
	&& fakeroot make package-deb \
	&& fakeroot make package-rpm

.PHONY: ias_package_shell_test_package_a
ias_package_shell_test_package_a:
	cd $(MAKEFILE_PATH)/ias_package_shell_test_package_a \
	&& make clean \
	&& fakeroot make package-deb \
	&& fakeroot make package-rpm \

.PHONY: ias_java_test_a
ias_java_test_a:
	cd $(MAKEFILE_PATH)/ias_java_test_a \
	&& make clean \
	&& make java-compile \
	&& make java-run \
	&& fakeroot make package-deb \
	&& fakeroot make package-rpm

