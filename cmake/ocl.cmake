list(APPEND PPLCV_COMPILE_DEFINITIONS PPLCV_USE_OPENCL)

file(GLOB_RECURSE __PPLCV_OCL_SRC__ src/ppl/cv/ocl/*.cpp)
list(APPEND PPLCV_SRC ${__PPLCV_OCL_SRC__})
unset(__PPLCV_OCL_SRC__)

list(APPEND PPLCV_LINK_LIBRARIES OpenCL)

file(GLOB KERNEL_FILES src/ppl/cv/ocl/*.cl)
# message("kernel files: ${KERNEL_FILES}")
foreach(KERNEL_FILE IN ITEMS ${KERNEL_FILES})
    # message("kernel file: ${KERNEL_FILE}")
    string(REGEX MATCH "[0-9A-Za-z]*.cl$" TMP1 ${KERNEL_FILE})
    # message("tmp1 file: ${TMP1}")
    string(REGEX REPLACE ".cl" ".ocl" TMP2 ${TMP1})
    # message("tmp2 file: ${TMP2}")
    file(STRINGS ${KERNEL_FILE} KERNEL_CONTENT)
    set(KERNEL_STRING "static const char* source_string = \"${KERNEL_CONTENT}\"\;")
    file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/${TMP2} ${KERNEL_STRING})
endforeach()

file(GLOB __OCL_UNITTEST_SRC__ "src/ppl/cv/ocl/*_unittest.cpp")
list(APPEND PPLCV_UNITTEST_SRC ${__OCL_UNITTEST_SRC__})
unset(__OCL_UNITTEST_SRC__)

file(GLOB __OCL_BENCHMARK_SRC__ "src/ppl/cv/ocl/*_benchmark.cpp")
list(APPEND PPLCV_BENCHMARK_SRC ${__OCL_BENCHMARK_SRC__})
unset(__OCL_BENCHMARK_SRC__)

if(PPLCV_INSTALL)
    file(GLOB __OCL_HEADERS__ src/ppl/cv/ocl/*.h)
    install(FILES ${__OCL_HEADERS__} DESTINATION include/ppl/cv/ocl)
    unset(__OCL_HEADERS__)
endif()
