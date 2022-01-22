if(NOT HPCC_DEPS_DIR)
    set(HPCC_DEPS_DIR ${CMAKE_CURRENT_SOURCE_DIR}/deps)
endif()

include(FetchContent)

set(FETCHCONTENT_BASE_DIR ${HPCC_DEPS_DIR})
set(FETCHCONTENT_QUIET OFF)

if(PPLCV_HOLD_DEPS)
    set(FETCHCONTENT_UPDATES_DISCONNECTED ON)
endif()

if(PPLCV_DEPS_USE_GITEE)
    set(hpcc_repo https://github.com/openppl-public/hpcc.git)
    set(hpcc_tag fe210f0d20cc50da9ad51b29edc02bfeb7cda24a)
else()
    set(hpcc_repo https://gitee.com/openppl-public/hpcc.git)
    set(hpcc_tag 3d5a94e)
endif()

FetchContent_Declare(hpcc
    GIT_REPOSITORY ${hpcc_repo}
    #GIT_TAG fe210f0d20cc50da9ad51b29edc02bfeb7cda24a
    GIT_TAG ${hpcc_tag}
    SOURCE_DIR ${HPCC_DEPS_DIR}/hpcc
    BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR}/hpcc-build
    SUBBUILD_DIR ${HPCC_DEPS_DIR}/hpcc-subbuild)

FetchContent_GetProperties(hpcc)
if(NOT hpcc_POPULATED)
    FetchContent_Populate(hpcc)
    include(${hpcc_SOURCE_DIR}/cmake/hpcc-common.cmake)
endif()

# --------------------------------------------------------------------------- #

set(INSTALL_GTEST OFF CACHE BOOL "")
set(BUILD_SHARED_LIBS OFF CACHE BOOL "")

if(PPLCV_DEPS_USE_GITEE)
    set(googletest_repo https://gitee.com/mirrors/googletest.git)
else()
    set(googletest_repo https://github.com/google/googletest.git)
endif()
set(googletest_tag release-1.8.1) # ad6868782b5952b7476a7c1c72d5a714

# hpcc_declare_pkg_dep(googletest
#     https://github.com/google/googletest/archive/refs/tags/release-1.8.1.zip
#     ad6868782b5952b7476a7c1c72d5a714)

hpcc_declare_git_dep(googletest ${googletest_repo} ${googletest_tag})

# --------------------------------------------------------------------------- #

set(PPLCOMMON_BUILD_TESTS OFF CACHE BOOL "disable pplcommon tests")
set(PPLCOMMON_BUILD_BENCHMARK OFF CACHE BOOL "disable pplcommon benchmark")
set(PPLCOMMON_HOLD_DEPS ${PPLCV_HOLD_DEPS})

if(PPLCV_DEPS_USE_GITEE)
    #set(pplcommon_repo https://github.com/openppl-public/ppl.common.git)
    #set(pplcommon_tag b4170a465164977f19cd53bae8f00d9a6edbd804)
    set(pplcommon_repo https://gitee.com/aczz/ppl.common)
    set(pplcommon_tag 9c678348dbdd57c015260308bc60bf0c89bea8d1)
else()
    set(pplcommon_repo https://gitee.com/openppl-public/ppl.common.git)
    set(pplcommon_tag 9c678348dbdd57c015260308bc60bf0c89bea8d1)
endif()
hpcc_declare_git_dep(pplcommon ${pplcommon_repo} ${pplcommon_tag})

# --------------------------------------------------------------------------- #

set(BENCHMARK_ENABLE_TESTING OFF CACHE BOOL "disable benchmark tests")
set(BENCHMARK_ENABLE_INSTALL OFF CACHE BOOL "")

# hpcc_declare_pkg_dep(benchmark
#     https://github.com/google/benchmark/archive/refs/tags/v1.5.6.zip
#     2abe04dc31fc7f18b5f0647775b16249)
if(PPLCV_DEPS_USE_GITEE)
    set(benchmark_repo https://github.com/google/benchmark.git)
else()
    set(benchmark_repo https://github.com/google/benchmark.git)
endif()
set(benchmark_tag v1.5.6)
hpcc_declare_git_dep(benchmark ${benchmark_repo} ${benchmark_tag})

# --------------------------------------------------------------------------- #

set(BUILD_TESTS OFF CACHE BOOL "")
set(BUILD_PERF_TESTS OFF CACHE BOOL "")
set(BUILD_EXAMPLES OFF CACHE BOOL "")
set(BUILD_opencv_apps OFF CACHE BOOL "")
set(OPENCV_EXTRA_MODULES_PATH "${HPCC_DEPS_DIR}/opencv_contrib/modules" CACHE INTERNAL "")

# hpcc_declare_pkg_dep(opencv
#     https://github.com/opencv/opencv/archive/refs/tags/4.4.0.zip
#     4b00f5cdb1cf393c4a84696362c5a72a)
if(PPLCV_DEPS_USE_GITEE)
    set(opencv_repo https://gitee.com/mirrors/opencv.git)
else()
    set(opencv_repo https://github.com/opencv/opencv.git)
endif()
set(opencv_tag 4.4.0)
hpcc_declare_git_dep(opencv ${opencv_repo} ${opencv_tag})

# hpcc_declare_pkg_dep(opencv_contrib
#     https://github.com/opencv/opencv_contrib/archive/refs/tags/4.4.0.zip
#     d5fc20e0eb036f702f5b8f9b8f5531a6)
if(PPLCV_DEPS_USE_GITEE)
    set(opencv_contrib_repo https://gitee.com/mirrors/opencv_contrib.git)
else()
    set(opencv_contrib_repo https://github.com/opencv/opencv_contrib.git)
endif()
set(opencv_contrib_tag 4.4.0)
hpcc_declare_git_dep(opencv_contrib ${opencv_contrib_repo} ${opencv_contrib_tag})
