/**
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements. See the NOTICE file distributed with this
 * work for additional information regarding copyright ownership. The ASF
 * licenses this file to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance with the
 * License. You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0.
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations
 * under the License.
 */

#include "ppl/cv/ocl/cvtcolor.h"

#include <time.h>
#include <sys/time.h>

#include "opencv2/imgproc.hpp"
#include "benchmark/benchmark.h"

#include "ppl/common/ocl/oclcommon.h"
#include "ppl/cv/debug.h"
#include "utility/infrastructure.h"

using namespace ppl::cv::debug;

#define BENCHMARK_PPL_CV_OCL(Function)                                         \
template <typename T, int src_channels, int dst_channels>                      \
void BM_CvtColor ## Function ## _ppl_ocl(benchmark::State &state) {            \
  ppl::common::ocl::createSharedFrameChain(false);                             \
  cl_context context = ppl::common::ocl::getSharedFrameChain()->getContext();  \
  cl_command_queue queue = ppl::common::ocl::getSharedFrameChain()->getQueue();\
                                                                               \
  int width  = state.range(0);                                                 \
  int height = state.range(1);                                                 \
  cv::Mat src;                                                                 \
  src = createSourceImage(height, width, CV_MAKETYPE(cv::DataType<T>::depth,   \
                          src_channels));                                      \
  cv::Mat dst(height, width, CV_MAKETYPE(cv::DataType<T>::depth,               \
              dst_channels));                                                  \
                                                                               \
  int src_bytes = src.rows * src.step;                                         \
  int dst_bytes = dst.rows * dst.step;                                         \
  cl_int error_code = 0;                                                       \
  cl_mem gpu_src = clCreateBuffer(context,                                     \
                                  CL_MEM_READ_ONLY | CL_MEM_HOST_WRITE_ONLY,   \
                                  src_bytes, NULL, &error_code);               \
  CHECK_ERROR(error_code, clCreateBuffer);                                     \
  cl_mem gpu_dst = clCreateBuffer(context,                                     \
                                  CL_MEM_WRITE_ONLY | CL_MEM_HOST_READ_ONLY,   \
                                  dst_bytes, NULL, &error_code);               \
  CHECK_ERROR(error_code, clCreateBuffer);                                     \
  error_code = clEnqueueWriteBuffer(queue, gpu_src, CL_FALSE, 0, src_bytes,    \
                                    src.data, 0, NULL, NULL);                  \
  CHECK_ERROR(error_code, clEnqueueWriteBuffer);                               \
                                                                               \
  int iterations = 100;                                                        \
  struct timeval start, end;                                                   \
                                                                               \
  /* Warm up the GPU. */                                                       \
  for (int i = 0; i < iterations; i++) {                                       \
    ppl::cv::ocl::Function<T>(queue, src.rows, src.cols, src.step / sizeof(T), \
                              gpu_src, dst.step / sizeof(T), gpu_dst);         \
  }                                                                            \
  clFinish(queue);                                                             \
                                                                               \
  for (auto _ : state) {                                                       \
    gettimeofday(&start, NULL);                                                \
    for (int i = 0; i < iterations; i++) {                                     \
      ppl::cv::ocl::Function<T>(queue, src.rows, src.cols,                     \
                                src.step / sizeof(T), gpu_src,                 \
                                dst.step / sizeof(T), gpu_dst);                \
    }                                                                          \
    clFinish(queue);                                                           \
    gettimeofday(&end, NULL);                                                  \
    int time = ((end.tv_sec * 1000000 + end.tv_usec) -                         \
                (start.tv_sec * 1000000 + start.tv_usec)) / iterations;        \
    state.SetIterationTime(time * 1e-6);                                       \
  }                                                                            \
  state.SetItemsProcessed(state.iterations() * 1);                             \
                                                                               \
  clReleaseMemObject(gpu_src);                                                 \
  clReleaseMemObject(gpu_dst);                                                 \
}

#define BENCHMARK_OPENCV_X86(Function)                                         \
template <typename T, int src_channels, int dst_channels>                      \
void BM_CvtColor ## Function ## _opencv_ocl(benchmark::State &state) {         \
  int width  = state.range(0);                                                 \
  int height = state.range(1);                                                 \
  cv::Mat src;                                                                 \
  src = createSourceImage(height, width, CV_MAKETYPE(cv::DataType<T>::depth,   \
                          src_channels));                                      \
  cv::Mat dst(height, width, CV_MAKETYPE(cv::DataType<T>::depth,               \
              dst_channels));                                                  \
                                                                               \
  for (auto _ : state) {                                                       \
    cv::cvtColor(src, dst, cv::COLOR_ ## Function);                            \
  }                                                                            \
  state.SetItemsProcessed(state.iterations() * 1);                             \
}

#define BENCHMARK_2FUNCTIONS_DECLARATION(Function)                             \
BENCHMARK_PPL_CV_OCL(Function)                                                 \
BENCHMARK_OPENCV_X86(Function)

#define RUN_2BENCHMARKS(Function, src_channels, dst_channels, width, height)   \
BENCHMARK_TEMPLATE(BM_CvtColor ## Function ## _opencv_ocl, uchar, src_channels,\
                   dst_channels)->Args({width, height});                       \
BENCHMARK_TEMPLATE(BM_CvtColor ## Function ## _ppl_ocl, uchar, src_channels,   \
                   dst_channels)->Args({width, height})->UseManualTime()->     \
                   Iterations(10);                                             \
BENCHMARK_TEMPLATE(BM_CvtColor ## Function ## _opencv_ocl, float, src_channels,\
                   dst_channels)->Args({width, height});                       \
BENCHMARK_TEMPLATE(BM_CvtColor ## Function ## _ppl_ocl, float, src_channels,   \
                   dst_channels)->Args({width, height})->UseManualTime()->     \
                   Iterations(10);

#define RUN_BENCHMARK_COMPARISON_2FUNCTIONS(Function, src_channels,            \
                                            dst_channels)                      \
BENCHMARK_2FUNCTIONS_DECLARATION(Function)                                     \
RUN_2BENCHMARKS(Function, src_channels, dst_channels, 320, 240)                \
RUN_2BENCHMARKS(Function, src_channels, dst_channels, 640, 480)                \
RUN_2BENCHMARKS(Function, src_channels, dst_channels, 1280, 720)               \
RUN_2BENCHMARKS(Function, src_channels, dst_channels, 1920, 1080)


#define RUN_OPENCV_TYPE_FUNCTIONS(Function, type, src_channels, dst_channels)  \
BENCHMARK_TEMPLATE(BM_CvtColor ## Function ## _opencv_ocl, type, src_channels, \
                   dst_channels)->Args({320, 240});                            \
BENCHMARK_TEMPLATE(BM_CvtColor ## Function ## _opencv_ocl, type, src_channels, \
                   dst_channels)->Args({640, 480});                            \
BENCHMARK_TEMPLATE(BM_CvtColor ## Function ## _opencv_ocl, type, src_channels, \
                   dst_channels)->Args({1280, 720});                           \
BENCHMARK_TEMPLATE(BM_CvtColor ## Function ## _opencv_ocl, type, src_channels, \
                   dst_channels)->Args({1920, 1080});

#define RUN_PPL_CV_TYPE_FUNCTIONS(Function, type, src_channels, dst_channels)  \
BENCHMARK_TEMPLATE(BM_CvtColor ## Function ## _ppl_ocl, type, src_channels,    \
                   dst_channels)->Args({320, 240})->UseManualTime()->          \
                   Iterations(10);                                             \
BENCHMARK_TEMPLATE(BM_CvtColor ## Function ## _ppl_ocl, type, src_channels,    \
                   dst_channels)->Args({640, 480})->UseManualTime()->          \
                   Iterations(10);                                             \
BENCHMARK_TEMPLATE(BM_CvtColor ## Function ## _ppl_ocl, type, src_channels,    \
                   dst_channels)->Args({1280, 720})->UseManualTime()->         \
                   Iterations(10);                                             \
BENCHMARK_TEMPLATE(BM_CvtColor ## Function ## _ppl_ocl, type, src_channels,    \
                   dst_channels)->Args({1920, 1080})->UseManualTime()->        \
                   Iterations(10);

#define RUN_BENCHMARK_BATCH_2FUNCTIONS(Function, src_channels, dst_channels)   \
BENCHMARK_2FUNCTIONS_DECLARATION(Function)                                     \
RUN_OPENCV_TYPE_FUNCTIONS(Function, uchar, src_channels, dst_channels)         \
RUN_OPENCV_TYPE_FUNCTIONS(Function, float, src_channels, dst_channels)         \
RUN_PPL_CV_TYPE_FUNCTIONS(Function, uchar, src_channels, dst_channels)         \
RUN_PPL_CV_TYPE_FUNCTIONS(Function, float, src_channels, dst_channels)

// BGR(RBB) <-> BGRA(RGBA)
RUN_BENCHMARK_COMPARISON_2FUNCTIONS(BGR2BGRA, c3, c4)
RUN_BENCHMARK_COMPARISON_2FUNCTIONS(RGB2RGBA, c3, c4)
RUN_BENCHMARK_COMPARISON_2FUNCTIONS(BGRA2BGR, c4, c3)
RUN_BENCHMARK_COMPARISON_2FUNCTIONS(RGBA2RGB, c4, c3)
RUN_BENCHMARK_COMPARISON_2FUNCTIONS(BGR2RGBA, c3, c4)
RUN_BENCHMARK_COMPARISON_2FUNCTIONS(RGB2BGRA, c3, c4)
RUN_BENCHMARK_COMPARISON_2FUNCTIONS(BGRA2RGB, c4, c3)
RUN_BENCHMARK_COMPARISON_2FUNCTIONS(RGBA2BGR, c4, c3)

// BGR <-> RGB
RUN_BENCHMARK_COMPARISON_2FUNCTIONS(BGR2RGB, c4, c3)
RUN_BENCHMARK_COMPARISON_2FUNCTIONS(RGB2BGR, c4, c3)

// BGRA <-> RGBA
RUN_BENCHMARK_COMPARISON_2FUNCTIONS(BGRA2RGBA, c4, c4)
RUN_BENCHMARK_COMPARISON_2FUNCTIONS(RGBA2BGRA, c4, c4)

// RUN_BENCHMARK_BATCH_2FUNCTIONS(BGR2BGRA, c3, c4)

