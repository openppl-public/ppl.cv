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

#include "ppl/cv/cuda/mean.h"

#include "utility.hpp"

using namespace ppl::common;

namespace ppl {
namespace cv {
namespace cuda {

static __device__ uint count = 0;
static __device__ uint mask_count = 0;

// BLOCK_SIZE must be 512, 256, 128, 64, 32.
#define BLOCK_SIZE 128
#define BLOCK_SHIFT 7
#define MAX_BLOCKS 256

template <typename T>
__DEVICE__
void setZeroVector(T &value);

template <>
__DEVICE__
void setZeroVector(uint &value) {
  value = 0;
}

template <>
__DEVICE__
void setZeroVector(uint3 &value) {
  value.x = 0;
  value.y = 0;
  value.z = 0;
}

template <>
__DEVICE__
void setZeroVector(uint4 &value) {
  value.x = 0;
  value.y = 0;
  value.z = 0;
  value.w = 0;
}

template <>
__DEVICE__
void setZeroVector(float &value) {
  value = 0.f;
}

template <>
__DEVICE__
void setZeroVector(float3 &value) {
  value.x = 0.f;
  value.y = 0.f;
  value.z = 0.f;
}

template <>
__DEVICE__
void setZeroVector(float4 &value) {
  value.x = 0.f;
  value.y = 0.f;
  value.z = 0.f;
  value.w = 0.f;
}

template <typename T>
__DEVICE__
void atomicAddVector(float* address, T &value);

template <>
__DEVICE__
void atomicAddVector(float* address, uint &value) {
  atomicAdd(address, (float)value);
}

template <>
__DEVICE__
void atomicAddVector(float* address, uint3 &value) {
  atomicAdd(&address[0], (float)value.x);
  atomicAdd(&address[1], (float)value.y);
  atomicAdd(&address[2], (float)value.z);
}

template <>
__DEVICE__
void atomicAddVector(float* address, uint4 &value) {
  atomicAdd(&address[0], (float)value.x);
  atomicAdd(&address[1], (float)value.y);
  atomicAdd(&address[2], (float)value.z);
  atomicAdd(&address[3], (float)value.w);
}

template <>
__DEVICE__
void atomicAddVector(float* address, float &value) {
  atomicAdd(address, value);
}

template <>
__DEVICE__
void atomicAddVector(float* address, float3 &value) {
  atomicAdd(&address[0], value.x);
  atomicAdd(&address[1], value.y);
  atomicAdd(&address[2], value.z);
}

template <>
__DEVICE__
void atomicAddVector(float* address, float4 &value) {
  atomicAdd(&address[0], value.x);
  atomicAdd(&address[1], value.y);
  atomicAdd(&address[2], value.z);
  atomicAdd(&address[3], value.w);
}

template <typename Tsrc, typename Tsrcn, typename Tsumn>
__global__
void unmaskMeanKernel(const Tsrc* src, int rows, int cols, int channels,
                      int src_stride, uint blocks, float* mean_values) {
  __shared__ Tsumn partial_sums[BLOCK_SIZE];

  int threadIdx_x = threadIdx.x;
  int element_x = (blockIdx.x << BLOCK_SHIFT) + threadIdx_x;
  if (channels == 1) {
    element_x = element_x << 2;
  }
  int element_y = blockIdx.y;
  setZeroVector(partial_sums[threadIdx_x]);

  Tsrcn* input;
  Tsrcn value0, value1, value2, value3;

  for (; element_y < rows; element_y += gridDim.y) {
    if (element_x < cols) {
      input  = (Tsrcn*)((uchar*)src + element_y * src_stride);
      if (channels == 1) {
        value0 = input[element_x];
        value1 = input[element_x + 1];
        value2 = input[element_x + 2];
        value3 = input[element_x + 3];

        if (element_x < cols - 3) {
          partial_sums[threadIdx_x] += value0;
          partial_sums[threadIdx_x] += value1;
          partial_sums[threadIdx_x] += value2;
          partial_sums[threadIdx_x] += value3;
        }
        else {
          partial_sums[threadIdx_x] += value0;
          if (element_x < cols - 1) {
            partial_sums[threadIdx_x] += value1;
          }
          if (element_x < cols - 2) {
            partial_sums[threadIdx_x] += value2;
          }
        }
      }
      else {
        value0 = input[element_x];
        partial_sums[threadIdx_x] += value0;
      }
    }
  }
  __syncthreads();

#if BLOCK_SIZE == 512
  if (threadIdx_x < 256) {
    partial_sums[threadIdx_x] += partial_sums[threadIdx_x + 256];
  }
  __syncthreads();
#endif

#if BLOCK_SIZE >= 256
  if (threadIdx_x < 128) {
    partial_sums[threadIdx_x] += partial_sums[threadIdx_x + 128];
  }
  __syncthreads();
#endif

#if BLOCK_SIZE >= 128
  if (threadIdx_x < 64) {
    partial_sums[threadIdx_x] += partial_sums[threadIdx_x + 64];
  }
  __syncthreads();
#endif

  if (threadIdx_x < 32) {
    partial_sums[threadIdx_x] += partial_sums[threadIdx_x + 32];
  }
  __syncthreads();
  if (threadIdx_x < 16) {
    partial_sums[threadIdx_x] += partial_sums[threadIdx_x + 16];
  }
  __syncthreads();
  if (threadIdx_x < 8) {
    partial_sums[threadIdx_x] += partial_sums[threadIdx_x + 8];
  }
  __syncthreads();
  if (threadIdx_x < 4) {
    partial_sums[threadIdx_x] += partial_sums[threadIdx_x + 4];
  }
  __syncthreads();
  if (threadIdx_x < 2) {
    partial_sums[threadIdx_x] += partial_sums[threadIdx_x + 2];
  }
  __syncthreads();
  if (threadIdx_x < 1) {
    partial_sums[threadIdx_x] += partial_sums[threadIdx_x + 1];
  }
  __syncthreads();

  if (threadIdx_x == 0) {
    atomicAddVector(mean_values, partial_sums[0]);

    uint value = atomicInc(&count, blocks);
    bool is_last_block_done = (value == (blocks - 1));
    if (is_last_block_done) {
      int elements = rows * cols;
      float weight = 1.f / elements;
      mean_values[0] *= weight;
      if (channels > 2) {
        mean_values[1] *= weight;
        mean_values[2] *= weight;
      }
      if (channels > 3) {
        mean_values[3] *= weight;
      }
      count = 0;
      mask_count = 0;
    }
  }
}

template <typename Tsrc, typename Tsrcn, typename Tsumn>
__global__
void maskedMeanKernel(const Tsrc* src, int rows, int cols, int channels,
                      int src_stride, const uchar* mask, int mask_stride,
                      uint blocks, float* mean_values) {
  __shared__ Tsumn partial_sums[BLOCK_SIZE];
  __shared__ uint partial_counts[BLOCK_SIZE];

  int threadIdx_x = threadIdx.x;
  int element_x = (blockIdx.x << BLOCK_SHIFT) + threadIdx_x;
  if (channels == 1) {
    element_x = element_x << 2;
  }
  int element_y = blockIdx.y;
  setZeroVector(partial_sums[threadIdx_x]);
  partial_counts[threadIdx_x] = 0;

  Tsrcn* input;
  uchar* mask_row;
  Tsrcn value0, value1, value2, value3;
  uchar mvalue0, mvalue1, mvalue2, mvalue3;

  for (; element_y < rows; element_y += gridDim.y) {
    if (element_x < cols) {
      input  = (Tsrcn*)((uchar*)src + element_y * src_stride);
      mask_row = (uchar*)((uchar*)mask + element_y * mask_stride);
      if (channels == 1) {
        value0 = input[element_x];
        value1 = input[element_x + 1];
        value2 = input[element_x + 2];
        value3 = input[element_x + 3];

        mvalue0 = mask_row[element_x];
        mvalue1 = mask_row[element_x + 1];
        mvalue2 = mask_row[element_x + 2];
        mvalue3 = mask_row[element_x + 3];
        if (mvalue0 > 0) {
          partial_sums[threadIdx_x] += value0;
          partial_counts[threadIdx_x] += 1;
        }
        if (mvalue1 > 0 && element_x < cols - 1) {
          partial_sums[threadIdx_x] += value1;
          partial_counts[threadIdx_x] += 1;
        }
        if (mvalue2 > 0 && element_x < cols - 2) {
          partial_sums[threadIdx_x] += value2;
          partial_counts[threadIdx_x] += 1;
        }
        if (mvalue3 > 0 && element_x < cols - 3) {
          partial_sums[threadIdx_x] += value3;
          partial_counts[threadIdx_x] += 1;
        }
      }
      else {
        value0  = input[element_x];
        mvalue0 = mask_row[element_x];

        if (mvalue0 > 0) {
          partial_sums[threadIdx_x] += value0;
          partial_counts[threadIdx_x] += 1;
        }
      }
    }
  }
  __syncthreads();

#if BLOCK_SIZE == 512
  if (threadIdx_x < 256) {
    partial_sums[threadIdx_x]   += partial_sums[threadIdx_x + 256];
    partial_counts[threadIdx_x] += partial_counts[threadIdx_x + 256];
  }
  __syncthreads();
#endif

#if BLOCK_SIZE >= 256
  if (threadIdx_x < 128) {
    partial_sums[threadIdx_x]   += partial_sums[threadIdx_x + 128];
    partial_counts[threadIdx_x] += partial_counts[threadIdx_x + 128];
  }
  __syncthreads();
#endif

#if BLOCK_SIZE >= 128
  if (threadIdx_x < 64) {
    partial_sums[threadIdx_x]   += partial_sums[threadIdx_x + 64];
    partial_counts[threadIdx_x] += partial_counts[threadIdx_x + 64];
  }
  __syncthreads();
#endif

  if (threadIdx_x < 32) {
    partial_sums[threadIdx_x]   += partial_sums[threadIdx_x + 32];
    partial_counts[threadIdx_x] += partial_counts[threadIdx_x + 32];
  }
  __syncthreads();
  if (threadIdx_x < 16) {
    partial_sums[threadIdx_x]   += partial_sums[threadIdx_x + 16];
    partial_counts[threadIdx_x] += partial_counts[threadIdx_x + 16];
  }
  __syncthreads();
  if (threadIdx_x < 8) {
    partial_sums[threadIdx_x]   += partial_sums[threadIdx_x + 8];
    partial_counts[threadIdx_x] += partial_counts[threadIdx_x + 8];
  }
  __syncthreads();
  if (threadIdx_x < 4) {
    partial_sums[threadIdx_x]   += partial_sums[threadIdx_x + 4];
    partial_counts[threadIdx_x] += partial_counts[threadIdx_x + 4];
  }
  __syncthreads();
  if (threadIdx_x < 2) {
    partial_sums[threadIdx_x]   += partial_sums[threadIdx_x + 2];
    partial_counts[threadIdx_x] += partial_counts[threadIdx_x + 2];
  }
  __syncthreads();
  if (threadIdx_x < 1) {
    partial_sums[threadIdx_x]   += partial_sums[threadIdx_x + 1];
    partial_counts[threadIdx_x] += partial_counts[threadIdx_x + 1];
  }
  __syncthreads();

  if (threadIdx_x == 0) {
    atomicAddVector(mean_values, partial_sums[0]);
    atomicAdd(&mask_count, partial_counts[0]);

    uint value = atomicInc(&count, blocks);
    bool is_last_block_done = (value == (blocks - 1));
    if (is_last_block_done) {
      float weight = 1.f / mask_count;
      mean_values[0] *= weight;
      if (channels > 2) {
        mean_values[1] *= weight;
        mean_values[2] *= weight;
      }
      if (channels > 3) {
        mean_values[3] *= weight;
      }
      count = 0;
      mask_count = 0;
    }
  }
}

RetCode mean(const uchar* src, int rows, int cols, int channels, int src_stride,
             const uchar* mask, int mask_stride, float* mean_values,
             cudaStream_t stream) {
  PPL_ASSERT(src != nullptr);
  PPL_ASSERT(mean_values != nullptr);
  PPL_ASSERT(rows >= 1 && cols >= 1);
  PPL_ASSERT(channels == 1 || channels == 3 || channels == 4);
  PPL_ASSERT(src_stride >= cols * channels * (int)sizeof(uchar));
  if (mask != nullptr) {
    PPL_ASSERT(mask_stride >= cols * (int)sizeof(uchar));
  }

  int columns, grid_y;
  if (channels == 1) {
    columns = divideUp(cols, 4, 2);
  }
  else {
    columns = cols;
  }
  dim3 block, grid;
  block.x = BLOCK_SIZE;
  block.y = 1;
  grid.x  = divideUp(columns, BLOCK_SIZE, BLOCK_SHIFT);
  grid_y  = MAX_BLOCKS / grid.x;
  grid.y  = (grid_y < rows) ? grid_y : rows;

  int blocks = grid.x * grid.y;
  if (mask == nullptr) {
    if (channels == 1) {
      unmaskMeanKernel<uchar, uchar, uint><<<grid, block, 0, stream>>>(src,
          rows, cols, channels, src_stride, blocks, mean_values);
    }
    else if (channels == 3) {
      unmaskMeanKernel<uchar, uchar3, uint3><<<grid, block, 0, stream>>>(src,
          rows, cols, channels, src_stride, blocks, mean_values);
    }
    else {  //  channels == 4
      unmaskMeanKernel<uchar, uchar4, uint4><<<grid, block, 0, stream>>>(src,
          rows, cols, channels, src_stride, blocks, mean_values);
    }
  }
  else {
    if (channels == 1) {
      maskedMeanKernel<uchar, uchar, uint><<<grid, block, 0, stream>>>(src,
          rows, cols, channels, src_stride, mask, mask_stride, blocks,
          mean_values);
    }
    else if (channels == 3) {
      maskedMeanKernel<uchar, uchar3, uint3><<<grid, block, 0, stream>>>(src,
          rows, cols, channels, src_stride, mask, mask_stride, blocks,
          mean_values);
    }
    else {  //  channels == 4
      maskedMeanKernel<uchar, uchar4, uint4><<<grid, block, 0, stream>>>(src,
          rows, cols, channels, src_stride, mask, mask_stride, blocks,
          mean_values);
    }
  }

  cudaError_t code = cudaGetLastError();
  if (code != cudaSuccess) {
    LOG(ERROR) << "CUDA error: " << cudaGetErrorString(code);
    return RC_DEVICE_RUNTIME_ERROR;
  }

  return RC_SUCCESS;
}

RetCode mean(const float* src, int rows, int cols, int channels, int src_stride,
             const uchar* mask, int mask_stride, float* mean_values,
             cudaStream_t stream) {
  PPL_ASSERT(src != nullptr);
  PPL_ASSERT(mean_values != nullptr);
  PPL_ASSERT(rows >= 1 && cols >= 1);
  PPL_ASSERT(channels == 1 || channels == 3 || channels == 4);
  PPL_ASSERT(src_stride >= cols * channels * (int)sizeof(float));
  if (mask != nullptr) {
    PPL_ASSERT(mask_stride >= cols * (int)sizeof(uchar));
  }

  int columns, grid_y;
  if (channels == 1) {
    columns = divideUp(cols, 4, 2);
  }
  else {
    columns = cols;
  }
  dim3 block, grid;
  block.x = BLOCK_SIZE;
  block.y = 1;
  grid.x  = divideUp(columns, BLOCK_SIZE, BLOCK_SHIFT);
  grid_y  = MAX_BLOCKS / grid.x;
  grid.y  = (grid_y < rows) ? grid_y : rows;

  int blocks = grid.x * grid.y;
  if (mask == nullptr) {
    if (channels == 1) {
      unmaskMeanKernel<float, float, float><<<grid, block, 0, stream>>>(src,
          rows, cols, channels, src_stride, blocks, mean_values);
    }
    else if (channels == 3) {
      unmaskMeanKernel<float, float3, float3><<<grid, block, 0, stream>>>(src,
          rows, cols, channels, src_stride, blocks, mean_values);
    }
    else {  //  channels == 4
      unmaskMeanKernel<float, float4, float4><<<grid, block, 0, stream>>>(src,
          rows, cols, channels, src_stride, blocks, mean_values);
    }
  }
  else {
    if (channels == 1) {
      maskedMeanKernel<float, float, float><<<grid, block, 0, stream>>>(src,
          rows, cols, channels, src_stride, mask, mask_stride, blocks,
          mean_values);
    }
    else if (channels == 3) {
      maskedMeanKernel<float, float3, float3><<<grid, block, 0, stream>>>(src,
          rows, cols, channels, src_stride, mask, mask_stride, blocks,
          mean_values);
    }
    else {  //  channels == 4
      maskedMeanKernel<float, float4, float4><<<grid, block, 0, stream>>>(src,
          rows, cols, channels, src_stride, mask, mask_stride, blocks,
          mean_values);
    }
  }

  cudaError_t code = cudaGetLastError();
  if (code != cudaSuccess) {
    LOG(ERROR) << "CUDA error: " << cudaGetErrorString(code);
    return RC_DEVICE_RUNTIME_ERROR;
  }

  return RC_SUCCESS;
}

template <>
RetCode Mean<uchar, 1>(cudaStream_t stream,
                       int height,
                       int width,
                       int inWidthStride,
                       const uchar* inData,
                       float* outMean,
                       int maskWidthStride,
                       const uchar* mask) {
  RetCode code = mean(inData, height, width, 1, inWidthStride, mask,
                      maskWidthStride, outMean, stream);

  return code;
}

template <>
RetCode Mean<uchar, 3>(cudaStream_t stream,
                       int height,
                       int width,
                       int inWidthStride,
                       const uchar* inData,
                       float* outMean,
                       int maskWidthStride,
                       const uchar* mask) {
  RetCode code = mean(inData, height, width, 3, inWidthStride, mask,
                      maskWidthStride, outMean, stream);

  return code;
}

template <>
RetCode Mean<uchar, 4>(cudaStream_t stream,
                       int height,
                       int width,
                       int inWidthStride,
                       const uchar* inData,
                       float* outMean,
                       int maskWidthStride,
                       const uchar* mask) {
  RetCode code = mean(inData, height, width, 4, inWidthStride, mask,
                      maskWidthStride, outMean, stream);

  return code;
}

template <>
RetCode Mean<float, 1>(cudaStream_t stream,
                       int height,
                       int width,
                       int inWidthStride,
                       const float* inData,
                       float* outMean,
                       int maskWidthStride,
                       const uchar* mask) {
  inWidthStride *= sizeof(float);
  RetCode code = mean(inData, height, width, 1, inWidthStride, mask,
                      maskWidthStride, outMean, stream);

  return code;
}

template <>
RetCode Mean<float, 3>(cudaStream_t stream,
                       int height,
                       int width,
                       int inWidthStride,
                       const float* inData,
                       float* outMean,
                       int maskWidthStride,
                       const uchar* mask) {
  inWidthStride *= sizeof(float);
  RetCode code = mean(inData, height, width, 3, inWidthStride, mask,
                      maskWidthStride, outMean, stream);

  return code;
}

template <>
RetCode Mean<float, 4>(cudaStream_t stream,
                       int height,
                       int width,
                       int inWidthStride,
                       const float* inData,
                       float* outMean,
                       int maskWidthStride,
                       const uchar* mask) {
  inWidthStride *= sizeof(float);
  RetCode code = mean(inData, height, width, 4, inWidthStride, mask,
                      maskWidthStride, outMean, stream);

  return code;
}

}  // namespace cuda
}  // namespace cv
}  // namespace ppl
