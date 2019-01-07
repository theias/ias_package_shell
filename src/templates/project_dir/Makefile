###########################
# Advanced Usage below.
###########################

# [%# 
#
# This comment is intended for whomever is editing ias_package_shell
#
# # IMPORTANT
#
# You might be viewing this file through a symbolic link.
# you are trying to edit ias_package_shell/Makefile
# instead of ias_package_shell/src/templates/project_dir/Makefile
#
# For the ias_package_shell package itself, this is NEVER to be changed
# to accomodate for the ias_package_shell program 
#
# The idea here is that ias_package_shell should 
#
# %]


###########################
# IMPORTANT
###########################

# This is a STATIC file that should not be changed

# It's not supposed to be changed by a template system
# 

MAKEFILE_PATH = $(strip $(dir $(firstword $(MAKEFILE_LIST))))

include $(MAKEFILE_PATH)/base.gmk

# The following are optional in base.gmk ,
# but must be set before the other stuff loads
ifeq ($(BASE_DIR),)
        BASE_DIR := /opt/IAS
endif


PACKAGE_SHELL_INCLUDE_PATH=$(MAKEFILE_PATH)/package_shell/make

include $(PACKAGE_SHELL_INCLUDE_PATH)/project-base_variables.gmk
include $(PACKAGE_SHELL_INCLUDE_PATH)/make-standard_phonies.gmk

ifneq ("$(wildcard $(ARTIFACT_NAME)/artifact_variables.gmk)","")
	include $(ARTIFACT_NAME)/artifact_variables.gmk
endif

ifeq ($(PROJECT_DIRECTORIES_ARE_DEFINED),)
	include $(PACKAGE_SHELL_INCLUDE_PATH)/project_directories-full_project.gmk
endif

include $(PACKAGE_SHELL_INCLUDE_PATH)/package_shell-additional.gmk
include $(PACKAGE_SHELL_INCLUDE_PATH)/source-basic_tests.gmk
include $(PACKAGE_SHELL_INCLUDE_PATH)/package_install-base_directories.gmk
include $(PACKAGE_SHELL_INCLUDE_PATH)/package_install-conditional_additions.gmk
include $(PACKAGE_SHELL_INCLUDE_PATH)/package_install-final_cleanup.gmk

include $(PACKAGE_SHELL_INCLUDE_PATH)/package_install-mapped_symbolic_links.gmk

# Supported package systems
include $(PACKAGE_SHELL_INCLUDE_PATH)/package_build-rpm.gmk
include $(PACKAGE_SHELL_INCLUDE_PATH)/package_build-deb.gmk

.PHONY: debug-ALL

debug-ALL: \
	debug-base-Makefile \
	debug-project-base_variables \
	debug-make-standard_phonies \
	debug-project_directories \
	debug-package_shell-additional \
	debug-source-basic_tests \
	debug-package_install-base_directories \
	debug-package_install-conditional_additions \
	debug-package_install-final_cleanup \
	debug-package_build-rpm \
	debug-package_build-deb \
	debug-package_install-mapped_symbolic_links

.PHONY: debug-base-Makefile

debug-base-Makefile:
	# Makefile - debug variables
	#   ARTIFACT_NAME: '$(ARTIFACT_NAME)'
	#   MAKEFILE_PATH: '$(MAKEFILE_PATH)'
	#   PACKAGE_SHELL_INCLUDE_PATH: '$(PACKAGE_SHELL_INCLUDE_PATH)'
	#
