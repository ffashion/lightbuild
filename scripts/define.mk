# SPDX-License-Identifier: GPL-2.0
# ==========================================================================
# System define
# ==========================================================================

########################################
# Build toolchain                      #
########################################

#
# Gcc toolchain
AS			:= $(CROSS_COMPILE)as
LD			:= $(CROSS_COMPILE)ld
CC			:= $(CROSS_COMPILE)gcc
CPP			:= $(CROSS_COMPILE)gcc -E
AR			:= $(CROSS_COMPILE)ar
NM			:= $(CROSS_COMPILE)nm
STRIP		:= $(CROSS_COMPILE)strip
OBJCOPY		:= $(CROSS_COMPILE)objcopy
OBJDUMP		:= $(CROSS_COMPILE)objdump

#
# clang toolchain



#
# NASM toolchain
NASM		:= nasm


#
# Rust toolchain

#
# Gcc toolchain
CUST_AS			:= $(CROSS_COMPILE)as
CUST_LD			:= $(CROSS_COMPILE)ld
CUST_CC			:= $(CROSS_COMPILE)gcc
CUST_CPP			:= $(CROSS_COMPILE)gcc -E
CUST_AR			:= $(CROSS_COMPILE)ar
CUST_NM			:= $(CROSS_COMPILE)nm
CUST_STRIP		:= $(CROSS_COMPILE)strip
CUST_OBJCOPY		:= $(CROSS_COMPILE)objcopy
CUST_OBJDUMP		:= $(CROSS_COMPILE)objdump



AS_FLAGS 		:= 
LD_FLAGS 		:= 
CC_FLAGS 		:= 
CPP_FLAGS 		:= 
AR_FLAGS 		:= 
NM_FLAGS 		:= 
STRIP_FLAGS 	:= 
OBJCOPY_FLAGS	:= 
OBJDUMP_FLAGS	:= 
NASM_FLAGS		:=

#
# Host toolchain
HOSTCC		 := gcc
HOSTCXX      := c++
HOSTCFLAGS   := -Wall -Wmissing-prototypes -Wstrict-prototypes -O2 -fomit-frame-pointer
HOSTCXXFLAGS := -O2

########################################
# CMD tool                             #
########################################

#
# CMD tool
MKDIR			:= mkdir -p
RMDIR			:= rmdir -p
CP				:= cp -af
RM				:= rm -rf
CD				:= cd
MV				:= mv
FIND			:= find
ECHO			:= echo -e
PERL			:= perl
CONFIG_SHELL	:= $(shell if [ -x "$$BASH" ]; then echo $$BASH; \
	  else if [ -x /bin/bash ]; then echo /bin/bash; \
	  else echo sh; fi ; fi)

########################################
# Echo tips                            #
########################################

ECHO_CPP		:= \e[32mCPP\e[0m
ECHO_CC			:= \e[32mCC\e[0m
ECHO_CXX		:= \e[32mCXX\e[0m
ECHO_AS			:= \e[32mAS\e[0m
ECHO_AR			:= \e[32mAR\e[0m
ECHO_LD			:= \e[35mLD\e[0m

ECHO_CUSTAS		:= \e[32mCUSTCC\e[0m
ECHO_CUSTCC		:= \e[32mCUSTCC\e[0m
ECHO_CUSTCXX	:= \e[32mCUSTCXX\e[0m
ECHO_CUSTLD		:= \e[35mCUSTLD\e[0m

ECHO_NASM		:= \e[35mNASM\e[0m

ECHO_BIN		:= \e[35mBIN\e[0m

ECHO_HOSTCC		:= \e[32mHOSTCC\e[0m
ECHO_HOSTCXX	:= \e[32mHOSTCXX\e[0m
ECHO_HOSTLD		:= \e[35mHOSTLD\e[0m
ECHO_HOSTLLD	:= \e[35mHOSTLLD\e[0m

ECHO_RM			:= \e[33mRM\e[0m
ECHO_CLEAN		:= \e[33mCLEAN\e[0m

ECHO_DONE		:= \e[34mDONE\e[0m
ECHO_OUTPUT		:= \e[34mOUTPUT\e[0m

########################################
# Build tool define                    #
########################################

# Shorthand for $(Q)$(MAKE) -f scripts/remake.mk obj=
# Usage:
# $(Q)$(MAKE) $(build)=dir
remake		:= -f $(BUILD_HOME)/remake.mk obj

# Shorthand for $(Q)$(MAKE) -f scripts/init_build.mk obj=
# Usage:
# $(Q)$(MAKE) $(build)=dir
init		:= -f $(BUILD_HOME)/init_build.mk obj

# Shorthand for $(Q)$(MAKE) -f scripts/build.mk obj=
# Usage:
# $(Q)$(MAKE) $(build)=dir
build		:= -f $(BUILD_HOME)/build.mk obj

###
# Shorthand for $(Q)$(MAKE) -f scripts/clean.mk obj=
# Usage:
# $(Q)$(MAKE) $(clean)=dir
clean		:= -f $(BUILD_HOME)/clean.mk obj

########################################
# Build option                         #
########################################

# as-option
# Usage: cflags-y += $(call as-option,-Wa$(comma)-isa=foo,)
as-option = $(call try-run,\
	$(CC) $(BUILD_CFLAGS) $(1) -c -x assembler /dev/null -o "$$TMP",$(1),$(2))

# as-instr
# Usage: cflags-y += $(call as-instr,instr,option1,option2)
as-instr = $(call try-run,\
	printf "%b\n" "$(1)" | $(CC) $(BUILD_AFLAGS) -c -x assembler -o "$$TMP" -,$(2),$(3))

# cc-option
# Usage: cflags-y += $(call cc-option,-march=winchip-c6,-march=i586)
cc-option = $(call try-run,\
	$(CC) $(KBUILD_CPPFLAGS) $(BUILD_CFLAGS) $(1) -c -xc /dev/null -o "$$TMP",$(1),$(2))

# cc-option-yn
# Usage: flag := $(call cc-option-yn,-march=winchip-c6)
cc-option-yn = $(call try-run,\
	$(CC) $(KBUILD_CPPFLAGS) $(BUILD_CFLAGS) $(1) -c -xc /dev/null -o "$$TMP",y,n)

# cc-option-align
# Prefix align with either -falign or -malign
cc-option-align = $(subst -functions=0,,\
	$(call cc-option,-falign-functions=0,-malign-functions=0))

# cc-disable-warning
# Usage: cflags-y += $(call cc-disable-warning,unused-but-set-variable)
cc-disable-warning = $(call try-run,\
	$(CC) $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) -W$(strip $(1)) -c -xc /dev/null -o "$$TMP",-Wno-$(strip $(1)))

# cc-version
# Usage gcc-ver := $(call cc-version)
cc-version = $(shell $(CONFIG_SHELL) $(BUILD_HOME)/gcc-version.sh $(CC))

# cc-ifversion
# Usage:  EXTRA_CFLAGS += $(call cc-ifversion, -lt, 0402, -O1)
cc-ifversion = $(shell [ $(call cc-version, $(CC)) $(1) $(2) ] && echo $(3))

# cc-ldoption
# Usage: ldflags += $(call cc-ldoption, -Wl$(comma)--hash-style=both)
cc-ldoption = $(call try-run,\
	$(CC) $(1) -nostdlib -xc /dev/null -o "$$TMP",$(1),$(2))

# hostcc-option
# Usage: cflags-y += $(call hostcc-option,-march=winchip-c6,-march=i586)
hostcc-option = $(call __cc-option, $(HOSTCC),\
	$(HOSTCFLAGS) $(HOST_EXTRACFLAGS),$(1),$(2))

########################################
# conifg definitions                   #
########################################

# Convenient variables
comma   := ,
quote   := "
squote  := '
empty   :=
space   := $(empty) $(empty)
space_escape := _-_SPACE_-_
pound := \#

###
# Name of target with a '.' as filename prefix. foo/bar.o => foo/.bar.o
dot-target = $(dir $@).$(notdir $@)

###
# The temporary file to save gcc -MD generated dependencies must not
# contain a comma
depfile = $(subst $(comma),_,$(dot-target).d)

###
# filename of target with directory and extension stripped
basetarget = $(basename $(notdir $@))

###
# filename of first prerequisite with directory and extension stripped
baseprereq = $(basename $(notdir $<))

###
# Escape single quote for use in echo statements
escsq = $(subst $(squote),'\$(squote)',$1)

# Find all -I options and call addtree
flags = $(foreach o,$($(1)),$(if $(filter -I%,$(o)),$(call addtree,$(o)),$(o)))

###
# Easy method for doing a status message
       kecho := :
 quiet_kecho := echo
silent_kecho := :
kecho := $($(quiet)kecho)

########################################
# try-run                              #
########################################

# Usage: option = $(call try-run, $(CC)...-o "$$TMP",option-ok,otherwise)
# Exit code chooses option. "$$TMP" is can be used as temporary file and
# is automatically cleaned up.
try-run = $(shell set -e;		\
	TMP="$(TMPOUT).$$$$.tmp";	\
	TMPO="$(TMPOUT).$$$$.o";	\
	if ($(1)) >/dev/null 2>&1;	\
	then echo "$(2)";		\
	else echo "$(3)";		\
	fi;				\
	rm -f "$$TMP" "$$TMPO")
	
#######################################
# filechk is used to check if the content of a generated file is updated.
# Sample usage:
# define filechk_sample
#	echo $KERNELRELEASE
# endef
# version.h : Makefile
#	$(call filechk,sample)
# The rule defined shall write to stdout the content of the new file.
# The existing file will be compared with the new one.
# - If no file exist it is created
# - If the content differ the new file is used
# - If they are equal no change, and no timestamp update
# - stdin is piped in from the first prerequisite ($<) so one has
#   to specify a valid file as first prerequisite (often the kbuild file)
define filechk
	$(Q)set -e;								\
	$(kecho) '  CHK     $@';				\
	mkdir -p $(dir $@);						\
	$(filechk_$(1)) < $< > $@.tmp;			\
	if [ -r $@ ] && cmp -s $@ $@.tmp; then	\
		rm -f $@.tmp;						\
	else									\
		$(kecho) '  UPD     $@';			\
		mv -f $@.tmp $@;					\
	fi
endef

########################################
# Auxiliary tool                       #
########################################

# Useful for describing the dependency of composite objects
# Usage:
#   $(call multi_depend, multi_used_targets, suffix_to_remove, suffix_to_add)
define multi_depend
$(foreach m, $(notdir $1), \
	$(eval $(obj)/$m: \
	$(addprefix $(obj)/, $(foreach s, $3, $($(m:%$(strip $2)=%$(s)))))))
endef

# echo command.
# Short version is used, if $(quiet) equals `quiet_', otherwise full one.
echo-cmd = $(if $($(quiet)cmd_$(1)),\
	$(ECHO) '  $(call escsq,$($(quiet)cmd_$(1)))$(echo-why)';)

# printing commands
cmd = $(Q)$(echo-cmd) $(cmd_$(1))

# output directory for tests below
TMPOUT := $(if $(KBUILD_EXTMOD),$(firstword $(KBUILD_EXTMOD))/)

########################################
# Check changed                        #
########################################

# Check if both commands are the same including their order. Result is empty
# string if equal. User may override this check using make KBUILD_NOCMDDEP=1
ifneq ($(KBUILD_NOCMDDEP),1)
cmd-check = $(filter-out $(subst $(space),$(space_escape),$(strip $(cmd_$@))), \
                         $(subst $(space),$(space_escape),$(strip $(cmd_$1))))
else
cmd-check = $(if $(strip $(cmd_$@)),,1)
endif

# Find any prerequisites that are newer than target or that do not exist.
# (This is not true for now; $? should contain any non-existent prerequisites,
# but it does not work as expected when .SECONDARY is present. This seems a bug
# of GNU Make.)
# PHONY targets skipped in both cases.
newer-prereqs = $(filter-out $(PHONY),$?)

# Replace >$< with >$$< to preserve $ when reloading the .cmd file
# (needed for make)
# Replace >#< with >$(pound)< to avoid starting a comment in the .cmd file
# (needed for make)
# Replace >'< with >'\''< to be able to enclose the whole string in '...'
# (needed for the shell)
make-cmd = $(call escsq,$(subst $(pound),$$(pound),$(subst $$,$$$$,$(cmd_$(1)))))

#
# Execute command if command has changed or prerequisite(s) are updated.
if_changed = $(if $(strip $(newer-prereqs) $(cmd-check)),                       \
	@set -e;                                                             \
	$(echo-cmd) $(cmd_$(1));                                             \
	printf '%s\n' 'cmd_$@ := $(make-cmd)' > $(dot-target).cmd, @:)

#
# Execute the command and also postprocess generated .d dependencies file.
if_changed_dep = $(if $(strip $(newer-prereqs) $(cmd-check) ),              	\
	@set -e;                                                             	\
	$(echo-cmd) $(cmd_$(1));                                             	\
	scripts/basic/fixdep $(depfile) $@ '$(make-cmd)' > $(dot-target).tmp;	\
	rm -f $(depfile);                                                    	\
	mv -f $(dot-target).tmp $(dot-target).cmd)

# Usage: $(call if_changed_rule,foo)
# Will check if $(cmd_foo) or any of the prerequisites changed,
# and if so will execute $(rule_foo).
if_changed_rule = $(if $(strip $(newer-prereqs) $(cmd-check) ),                 \
	@set -e;                                                             \
	$(rule_$(1)), @:)

#########################################
# why - tell why a a target got build
#       enabled by make V=2
#       Output (listed in the order they are checked):
#          (1) - due to target is PHONY
#          (2) - due to target missing
#          (3) - due to: file1.h file2.h
#          (4) - due to command line change
#          (5) - due to missing .cmd file
#          (6) - due to target not in $(targets)
# (1) PHONY targets are always build
# (2) No target, so we better build it
# (3) Prerequisite is newer than target
# (4) The command line stored in the file named dir/.target.cmd
#     differed from actual command line. This happens when compiler
#     options changes
# (5) No dir/.target.cmd file (used to store command line)
# (6) No dir/.target.cmd file and target not listed in $(targets)
#     This is a good hint that there is a bug in the kbuild file
ifeq ($(KBUILD_VERBOSE),2)
why =                                                                        \
    $(if $(filter $@, $(PHONY)),- due to target is PHONY,                    \
        $(if $(wildcard $@),                                                 \
            $(if $(strip $(newer-prereqs)),- due to: $(newer-prereqs),             \
                $(if $(arg-check),                                           \
                    $(if $(cmd_$@),- due to command line change,             \
                        $(if $(filter $@, $(targets)),                       \
                            - due to missing .cmd file,                      \
                            - due to $(notdir $@) not in $$(targets)         \
                         )                                                   \
                     )                                                       \
                 )                                                           \
             ),                                                              \
             - due to target missing                                         \
         )                                                                   \
     )

echo-why = $(call escsq, $(strip $(why)))
endif