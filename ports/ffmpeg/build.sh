# Copyright (c) 2012 The Native Client Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

#EXECUTABLES="ffmpeg ffmpeg_g ffprobe ffprobe_g"

# needed for RLIMIT_CPU
EnableGlibcCompat

ConfigureStep() {

  SetupCrossEnvironment

  local extra_args=""
  if [ "${TOOLCHAIN}" = "pnacl" ]; then
    extra_args="--cc=pnacl-clang"
  elif [ "${TOOLCHAIN}" = "clang-newlib" ]; then
    extra_args="--cc=${CC}"
  fi

  if [ "${NACL_ARCH}" = "pnacl" ]; then
    extra_args+=" --arch=pnacl"
  elif [ "${NACL_ARCH}" = "arm" ]; then
    extra_args+=" --arch=arm"
  else
    extra_args+=" --arch=x86"
  fi

  FILTERS="copy,null,anull,scale,resample,movie,amovie,crop,pad,apad,atrim,\
    trim,sine,setpts,asetpts,volume,aevalsrc,aeval,aresample,aformat,format,\
    amix,overlay"

  LogExecute ${SRC_DIR}/configure \
    --cross-prefix=${NACL_CROSS_PREFIX}- \
    --target-os=linux \
    --disable-everything \
    --enable-muxer=webm \
    --enable-encoder=libvpx_vp8,libvorbis \
    --enable-filter="${FILTERS}" \
    --disable-yasm \
    --disable-asm \
    --enable-static \
    --enable-cross-compile \
    --enable-protocol=file \
    --enable-libvorbis \
    --enable-libvpx \
    --disable-programs \
    --prefix=${PREFIX} \
    ${extra_args}
}

TestStep() {
  SetupCrossPaths
  #### Tests fails, missing flags?
  #LogExecute make testprogs
}
