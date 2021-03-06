# Copyright (c) 2013 The Native Client Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EnableGlibcCompat
EnableCliMain

EXTRA_CONFIGURE_ARGS+=" --with-curses"
EXTRA_CONFIGURE_ARGS+=" --with-installed-readline"
EXTRA_CONFIGURE_ARGS+=" --enable-readline"
NACLPORTS_CPPFLAGS+=" -DNO_MAIN_ENV_ARG"
NACLPORTS_CPPFLAGS+=" -Dpipe=nacl_spawn_pipe"

EXECUTABLES="bash${NACL_EXEEXT}"

# Configure requires this variable to be pre-set when cross compiling.
export bash_cv_getcwd_malloc=yes

if [[ ${TOOLCHAIN} == glibc ]]; then
  # Avoid conflicting gethostname declaration
  export ac_cv_func_gethostname=yes
fi

BuildStep() {
  # There is a missing dependency in the bash build system which means
  # that parallel build will sometimes fail due to lib/intl/libintl.h
  # not being generated before files that use it are compiled.
  # For example pathexp.c indirectly depends on libintl.h but compilation
  # of this file doesn't depend on the rule that generates it.
  # The fix is to explicitly build lib/intl before we build everything else.
  LogExecute make -C lib/intl
  DefaultBuildStep
}

PublishStep() {
  PublishMultiArch bash${NACL_EXEEXT} bash
}
