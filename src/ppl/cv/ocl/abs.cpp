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

#include "ppl/cv/ocl/abs.h"

#include <iostream>  // debug

#include "utility/utility.hpp"
#include "ppl/common/ocl/framechain.h"
#include "ppl/common/ocl/kernel.h"

#include "abs.ocl"

using namespace ppl::common;
using namespace ppl::common::ocl;

namespace ppl {
namespace cv {
namespace ocl {

RetCode abs_u8(const cl_mem src, int rows, int cols, int channels,
               int src_stride, cl_mem dst, int dst_stride,
               cl_command_queue queue) {
  PPL_ASSERT(src != nullptr);
  PPL_ASSERT(dst != nullptr);
  PPL_ASSERT(rows >= 1 && cols >= 1);
  PPL_ASSERT(channels == 1 || channels == 3 || channels == 4);
  PPL_ASSERT(src_stride >= cols * channels * (int)sizeof(schar));
  PPL_ASSERT(dst_stride >= cols * channels * (int)sizeof(schar));

  int columns = cols * channels;
  cols = divideUp(columns, 4, 2);
  size_t local_size[]  = {kBlockDimX0, kBlockDimY0};
  size_t global_size[] = {(size_t)cols, (size_t)rows};

  FrameChain frame_chain(queue);
  SET_PROGRAM_SOURCE(frame_chain);
  bool succeeded = compileOclKernels(frame_chain);
  if (!succeeded) {
    LOG(ERROR) << "Failed to compile the kernels of abs_u8().";
    return RC_DEVICE_RUNTIME_ERROR;
  }

  if ((src_stride & 3) == 0 && (dst_stride & 3) == 0) {
    // std::cout << "coming in absU8Kernel0" << std::endl;
    succeeded = runOclKernel(frame_chain, "absU8Kernel0", 2, global_size,
                             local_size, src, rows, cols, src_stride, dst,
                             dst_stride);
    // std::cout << "after absU8Kernel0" << std::endl;
  }
  else if (src_stride == columns && dst_stride == columns) {
    columns *= rows;
    cols = divideUp(columns, 4, 2);
    local_size[0]  = 256;
    local_size[1]  = 1;
    global_size[0] = (size_t)roundUp(cols, 256, 8);
    global_size[1] = 1;
    succeeded = runOclKernel(frame_chain, "absU8Kernel1", 2, global_size,
                             local_size, src, columns, dst);
  }
  else {
    succeeded = runOclKernel(frame_chain, "absU8Kernel2", 2, global_size,
                             local_size, src, rows, columns, src_stride, dst,
                             dst_stride);
  }
  if (!succeeded) {
    LOG(ERROR) << "Failed to run the kernel of abs_u8().";
    return RC_DEVICE_RUNTIME_ERROR;
  }

  return RC_SUCCESS;
}

RetCode abs_f32(const cl_mem src, int rows, int cols, int channels,
                int src_stride, cl_mem dst, int dst_stride,
                cl_command_queue queue) {
  PPL_ASSERT(src != nullptr);
  PPL_ASSERT(dst != nullptr);
  PPL_ASSERT(rows >= 1 && cols >= 1);
  PPL_ASSERT(channels == 1 || channels == 3 || channels == 4);
  PPL_ASSERT(src_stride >= cols * channels * (int)sizeof(float));
  PPL_ASSERT(dst_stride >= cols * channels * (int)sizeof(float));

  int columns = cols * channels;
  size_t local_size[]  = {kBlockDimX0, kBlockDimY0};
  size_t global_size[] = {(size_t)divideUp(columns, 2, 1), (size_t)rows};

  FrameChain frame_chain(queue);
  SET_PROGRAM_SOURCE(frame_chain);
  bool succeeded = compileOclKernels(frame_chain);
  if (!succeeded) {
    LOG(ERROR) << "Failed to compile the kernels of abs_f32().";
    return RC_DEVICE_RUNTIME_ERROR;
  }

  if ((src_stride & 7) == 0 && (dst_stride & 7) == 0) {
    cols = divideUp(columns, 2, 1);
    succeeded = runOclKernel(frame_chain, "absF32Kernel0", 2, global_size,
                             local_size, src, rows, cols, src_stride, dst,
                             dst_stride);
  }
  else {
    succeeded = runOclKernel(frame_chain, "absF32Kernel1", 2, global_size,
                             local_size, src, rows, columns, src_stride, dst,
                             dst_stride);
  }
  if (!succeeded) {
    LOG(ERROR) << "Failed to run the kernel of abs_f32().";
    return RC_DEVICE_RUNTIME_ERROR;
  }

  return RC_SUCCESS;
}

template <>
RetCode Abs<schar, 1>(cl_command_queue queue,
                      int height,
                      int width,
                      int inWidthStride,
                      const cl_mem inData,
                      int outWidthStride,
                      cl_mem outData) {
  RetCode code = abs_u8(inData, height, width, 1, inWidthStride, outData,
                     outWidthStride, queue);

  return code;
}

template <>
RetCode Abs<schar, 3>(cl_command_queue queue,
                      int height,
                      int width,
                      int inWidthStride,
                      const cl_mem inData,
                      int outWidthStride,
                      cl_mem outData) {
  RetCode code = abs_u8(inData, height, width, 3, inWidthStride, outData,
                     outWidthStride, queue);

  return code;
}

template <>
RetCode Abs<schar, 4>(cl_command_queue queue,
                      int height,
                      int width,
                      int inWidthStride,
                      const cl_mem inData,
                      int outWidthStride,
                      cl_mem outData) {
  RetCode code = abs_u8(inData, height, width, 4, inWidthStride, outData,
                     outWidthStride, queue);

  return code;
}

template <>
RetCode Abs<float, 1>(cl_command_queue queue,
                      int height,
                      int width,
                      int inWidthStride,
                      const cl_mem inData,
                      int outWidthStride,
                      cl_mem outData) {
  inWidthStride  *= sizeof(float);
  outWidthStride *= sizeof(float);
  RetCode code = abs_f32(inData, height, width, 1, inWidthStride, outData,
                     outWidthStride, queue);

  return code;
}

template <>
RetCode Abs<float, 3>(cl_command_queue queue,
                      int height,
                      int width,
                      int inWidthStride,
                      const cl_mem inData,
                      int outWidthStride,
                      cl_mem outData) {
  inWidthStride  *= sizeof(float);
  outWidthStride *= sizeof(float);
  RetCode code = abs_f32(inData, height, width, 3, inWidthStride, outData,
                     outWidthStride, queue);

  return code;
}

template <>
RetCode Abs<float, 4>(cl_command_queue queue,
                      int height,
                      int width,
                      int inWidthStride,
                      const cl_mem inData,
                      int outWidthStride,
                      cl_mem outData) {
  inWidthStride  *= sizeof(float);
  outWidthStride *= sizeof(float);
  RetCode code = abs_f32(inData, height, width, 4, inWidthStride, outData,
                     outWidthStride, queue);

  return code;
}

}  // namespace ocl
}  // namespace cv
}  // namespace ppl
