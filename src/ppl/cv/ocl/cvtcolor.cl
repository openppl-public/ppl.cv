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

#include "kerneltypes.h"

/************************** BGR(RBB) <-> BGRA(RGBA) *************************/

#if defined(BGR2BGRA_U8_1D) || defined(BGR2BGRA_F32_1D) ||                     \
    defined(RGB2RGBA_U8_1D) || defined(RGB2RGBA_F32_1D) || defined(SPIR)
#define BGR2BGRATYPE_1D(Function, base_type, T, T3, T4, alpha)                 \
__kernel                                                                       \
void Function ## base_type ## Kernel0(global const T* src, int cols,           \
                                      global T* dst) {                         \
  int element_x = get_global_id(0);                                            \
  if (element_x >= cols) {                                                     \
    return;                                                                    \
  }                                                                            \
                                                                               \
  T3 input_value = vload3(element_x, src);                                     \
  T4 value = (T4)(input_value.x, input_value.y, input_value.z, alpha);         \
                                                                               \
  vstore4(value, element_x, dst);                                              \
}
#endif

#if defined(BGR2BGRA_U8_2D) || defined(BGR2BGRA_F32_2D) ||                     \
    defined(RGB2RGBA_U8_2D) || defined(RGB2RGBA_F32_2D) || defined(SPIR)
#define BGR2BGRATYPE_2D(Function, base_type, T, T3, T4, alpha)                 \
__kernel                                                                       \
void Function ## base_type ## Kernel1(global const T* src, int rows, int cols, \
                                      int src_stride, global T* dst,           \
                                      int dst_stride) {                        \
  int element_x = get_global_id(0);                                            \
  int element_y = get_global_id(1);                                            \
  if (element_y >= rows || element_x >= cols) {                                \
    return;                                                                    \
  }                                                                            \
                                                                               \
  global T* data = (global T*)((global uchar*)src + element_y * src_stride);   \
  T3 input_value = vload3(element_x, data);                                    \
  T4 value = (T4)(input_value.x, input_value.y, input_value.z, alpha);         \
                                                                               \
  data = (global T*)((global uchar*)dst + element_y * dst_stride);             \
  vstore4(value, element_x, data);                                             \
}
#endif

#if defined(BGR2BGRA_U8_1D) || defined(SPIR)
BGR2BGRATYPE_1D(BGR2BGRA, U8, uchar, uchar3, uchar4, 255)
#endif

#if defined(BGR2BGRA_U8_2D) || defined(SPIR)
BGR2BGRATYPE_2D(BGR2BGRA, U8, uchar, uchar3, uchar4, 255)
#endif

#if defined(BGR2BGRA_F32_1D) || defined(SPIR)
BGR2BGRATYPE_1D(BGR2BGRA, F32, float, float3, float4, 1.f)
#endif

#if defined(BGR2BGRA_F32_2D) || defined(SPIR)
BGR2BGRATYPE_2D(BGR2BGRA, F32, float, float3, float4, 1.f)
#endif

#if defined(RGB2RGBA_U8_1D) || defined(SPIR)
BGR2BGRATYPE_1D(RGB2RGBA, U8, uchar, uchar3, uchar4, 255)
#endif

#if defined(RGB2RGBA_U8_2D) || defined(SPIR)
BGR2BGRATYPE_2D(RGB2RGBA, U8, uchar, uchar3, uchar4, 255)
#endif

#if defined(RGB2RGBA_F32_1D) || defined(SPIR)
BGR2BGRATYPE_1D(RGB2RGBA, F32, float, float3, float4, 1.f)
#endif

#if defined(RGB2RGBA_F32_2D) || defined(SPIR)
BGR2BGRATYPE_2D(RGB2RGBA, F32, float, float3, float4, 1.f)
#endif

#if defined(BGRA2BGR_U8_1D) || defined(BGRA2BGR_F32_1D) ||                     \
    defined(RGBA2RGB_U8_1D) || defined(RGBA2RGB_F32_1D) || defined(SPIR)
#define BGRA2BGRTYPE_1D(Function, base_type, T, T3, T4)                        \
__kernel                                                                       \
void Function ## base_type ## Kernel0(global const T* src, int cols,           \
                                      global T* dst) {                         \
  int element_x = get_global_id(0);                                            \
  if (element_x >= cols) {                                                     \
    return;                                                                    \
  }                                                                            \
                                                                               \
  T4 input_value = vload4(element_x, src);                                     \
  T3 value = (T3)(input_value.x, input_value.y, input_value.z);                \
                                                                               \
  vstore3(value, element_x, dst);                                              \
}
#endif

#if defined(BGRA2BGR_U8_2D) || defined(BGRA2BGR_F32_2D) ||                     \
    defined(RGBA2RGB_U8_2D) || defined(RGBA2RGB_F32_2D) || defined(SPIR)
#define BGRA2BGRTYPE_2D(Function, base_type, T, T3, T4)                        \
__kernel                                                                       \
void Function ## base_type ## Kernel1(global const T* src, int rows, int cols, \
                                      int src_stride, global T* dst,           \
                                      int dst_stride) {                        \
  int element_x = get_global_id(0);                                            \
  int element_y = get_global_id(1);                                            \
  if (element_y >= rows || element_x >= cols) {                                \
    return;                                                                    \
  }                                                                            \
                                                                               \
  global T* data = (global T*)((global uchar*)src + element_y * src_stride);   \
  T4 input_value = vload4(element_x, data);                                    \
  T3 value = (T3)(input_value.x, input_value.y, input_value.z);                \
                                                                               \
  data = (global T*)((global uchar*)dst + element_y * dst_stride);             \
  vstore3(value, element_x, data);                                             \
}
#endif

#if defined(BGRA2BGR_U8_1D) || defined(SPIR)
BGRA2BGRTYPE_1D(BGRA2BGR, U8, uchar, uchar3, uchar4)
#endif

#if defined(BGRA2BGR_U8_2D) || defined(SPIR)
BGRA2BGRTYPE_2D(BGRA2BGR, U8, uchar, uchar3, uchar4)
#endif

#if defined(BGRA2BGR_F32_1D) || defined(SPIR)
BGRA2BGRTYPE_1D(BGRA2BGR, F32, float, float3, float4)
#endif

#if defined(BGRA2BGR_F32_2D) || defined(SPIR)
BGRA2BGRTYPE_2D(BGRA2BGR, F32, float, float3, float4)
#endif

#if defined(RGBA2RGB_U8_1D) || defined(SPIR)
BGRA2BGRTYPE_1D(RGBA2RGB, U8, uchar, uchar3, uchar4)
#endif

#if defined(RGBA2RGB_U8_2D) || defined(SPIR)
BGRA2BGRTYPE_2D(RGBA2RGB, U8, uchar, uchar3, uchar4)
#endif

#if defined(RGBA2RGB_F32_1D) || defined(SPIR)
BGRA2BGRTYPE_1D(RGBA2RGB, F32, float, float3, float4)
#endif

#if defined(RGBA2RGB_F32_2D) || defined(SPIR)
BGRA2BGRTYPE_2D(RGBA2RGB, F32, float, float3, float4)
#endif

#if defined(BGR2RGBA_U8_1D) || defined(BGR2RGBA_F32_1D) ||                     \
    defined(RGB2BGRA_U8_1D) || defined(RGB2BGRA_F32_1D) || defined(SPIR)
#define BGR2RGBATYPE_1D(Function, base_type, T, T3, T4, alpha)                 \
__kernel                                                                       \
void Function ## base_type ## Kernel0(global const T* src, int cols,           \
                                      global T* dst) {                         \
  int element_x = get_global_id(0);                                            \
  if (element_x >= cols) {                                                     \
    return;                                                                    \
  }                                                                            \
                                                                               \
  T3 input_value = vload3(element_x, src);                                     \
  T4 value = (T4)(input_value.z, input_value.y, input_value.x, alpha);         \
                                                                               \
  vstore4(value, element_x, dst);                                              \
}
#endif

#if defined(BGR2RGBA_U8_2D) || defined(BGR2RGBA_F32_2D) ||                     \
    defined(RGB2BGRA_U8_2D) || defined(RGB2BGRA_F32_2D) || defined(SPIR)
#define BGR2RGBATYPE_2D(Function, base_type, T, T3, T4, alpha)                 \
__kernel                                                                       \
void Function ## base_type ## Kernel1(global const T* src, int rows, int cols, \
                                      int src_stride, global T* dst,           \
                                      int dst_stride) {                        \
  int element_x = get_global_id(0);                                            \
  int element_y = get_global_id(1);                                            \
  if (element_y >= rows || element_x >= cols) {                                \
    return;                                                                    \
  }                                                                            \
                                                                               \
  global T* data = (global T*)((global uchar*)src + element_y * src_stride);   \
  T3 input_value = vload3(element_x, data);                                    \
  T4 value = (T4)(input_value.z, input_value.y, input_value.x, alpha);         \
                                                                               \
  data = (global T*)((global uchar*)dst + element_y * dst_stride);             \
  vstore4(value, element_x, data);                                             \
}
#endif

#if defined(BGR2RGBA_U8_1D) || defined(SPIR)
BGR2RGBATYPE_1D(BGR2RGBA, U8, uchar, uchar3, uchar4, 255)
#endif

#if defined(BGR2RGBA_U8_2D) || defined(SPIR)
BGR2RGBATYPE_2D(BGR2RGBA, U8, uchar, uchar3, uchar4, 255)
#endif

#if defined(BGR2RGBA_F32_1D) || defined(SPIR)
BGR2RGBATYPE_1D(BGR2RGBA, F32, float, float3, float4, 1.f)
#endif

#if defined(BGR2RGBA_F32_2D) || defined(SPIR)
BGR2RGBATYPE_2D(BGR2RGBA, F32, float, float3, float4, 1.f)
#endif

#if defined(RGB2BGRA_U8_1D) || defined(SPIR)
BGR2RGBATYPE_1D(RGB2BGRA, U8, uchar, uchar3, uchar4, 255)
#endif

#if defined(RGB2BGRA_U8_2D) || defined(SPIR)
BGR2RGBATYPE_2D(RGB2BGRA, U8, uchar, uchar3, uchar4, 255)
#endif

#if defined(RGB2BGRA_F32_1D) || defined(SPIR)
BGR2RGBATYPE_1D(RGB2BGRA, F32, float, float3, float4, 1.f)
#endif

#if defined(RGB2BGRA_F32_2D) || defined(SPIR)
BGR2RGBATYPE_2D(RGB2BGRA, F32, float, float3, float4, 1.f)
#endif

#if defined(RGBA2BGR_U8_1D) || defined(RGBA2BGR_F32_1D) ||                     \
    defined(BGRA2RGB_U8_1D) || defined(BGRA2RGB_F32_1D) || defined(SPIR)
#define RGBA2BGRTYPE_1D(Function, base_type, T, T3, T4)                        \
__kernel                                                                       \
void Function ## base_type ## Kernel0(global const T* src, int cols,           \
                                      global T* dst) {                         \
  int element_x = get_global_id(0);                                            \
  if (element_x >= cols) {                                                     \
    return;                                                                    \
  }                                                                            \
                                                                               \
  T4 input_value = vload4(element_x, src);                                     \
  T3 value = (T3)(input_value.z, input_value.y, input_value.x);                \
                                                                               \
  vstore3(value, element_x, dst);                                              \
}
#endif

#if defined(RGBA2BGR_U8_2D) || defined(RGBA2BGR_F32_2D) ||                     \
    defined(BGRA2RGB_U8_2D) || defined(BGRA2RGB_F32_2D) || defined(SPIR)
#define RGBA2BGRTYPE_2D(Function, base_type, T, T3, T4)                        \
__kernel                                                                       \
void Function ## base_type ## Kernel1(global const T* src, int rows, int cols, \
                                      int src_stride, global T* dst,           \
                                      int dst_stride) {                        \
  int element_x = get_global_id(0);                                            \
  int element_y = get_global_id(1);                                            \
  if (element_y >= rows || element_x >= cols) {                                \
    return;                                                                    \
  }                                                                            \
                                                                               \
  global T* data = (global T*)((global uchar*)src + element_y * src_stride);   \
  T4 input_value = vload4(element_x, data);                                    \
  T3 value = (T3)(input_value.z, input_value.y, input_value.x);                \
                                                                               \
  data = (global T*)((global uchar*)dst + element_y * dst_stride);             \
  vstore3(value, element_x, data);                                             \
}
#endif

#if defined(RGBA2BGR_U8_1D) || defined(SPIR)
RGBA2BGRTYPE_1D(RGBA2BGR, U8, uchar, uchar3, uchar4)
#endif

#if defined(RGBA2BGR_U8_2D) || defined(SPIR)
RGBA2BGRTYPE_2D(RGBA2BGR, U8, uchar, uchar3, uchar4)
#endif

#if defined(RGBA2BGR_F32_1D) || defined(SPIR)
RGBA2BGRTYPE_1D(RGBA2BGR, F32, float, float3, float4)
#endif

#if defined(RGBA2BGR_F32_2D) || defined(SPIR)
RGBA2BGRTYPE_2D(RGBA2BGR, F32, float, float3, float4)
#endif

#if defined(BGRA2RGB_U8_1D) || defined(SPIR)
RGBA2BGRTYPE_1D(BGRA2RGB, U8, uchar, uchar3, uchar4)
#endif

#if defined(BGRA2RGB_U8_2D) || defined(SPIR)
RGBA2BGRTYPE_2D(BGRA2RGB, U8, uchar, uchar3, uchar4)
#endif

#if defined(BGRA2RGB_F32_1D) || defined(SPIR)
RGBA2BGRTYPE_1D(BGRA2RGB, F32, float, float3, float4)
#endif

#if defined(BGRA2RGB_F32_2D) || defined(SPIR)
RGBA2BGRTYPE_2D(BGRA2RGB, F32, float, float3, float4)
#endif

/******************************* BGR <-> RGB ******************************/

#if defined(RGB2BGR_U8_1D) || defined(RGB2BGR_F32_1D) ||                       \
    defined(BGR2RGB_U8_1D) || defined(BGR2RGB_F32_1D) || defined(SPIR)
#define RGB2BGRTYPE_1D(Function, base_type, T, T3)                             \
__kernel                                                                       \
void Function ## base_type ## Kernel0(global const T* src, int cols,           \
                                      global T* dst) {                         \
  int element_x = get_global_id(0);                                            \
  if (element_x >= cols) {                                                     \
    return;                                                                    \
  }                                                                            \
                                                                               \
  T3 input_value = vload3(element_x, src);                                     \
  T3 value = (T3)(input_value.z, input_value.y, input_value.x);                \
                                                                               \
  vstore3(value, element_x, dst);                                              \
}
#endif

#if defined(RGB2BGR_U8_2D) || defined(RGB2BGR_F32_2D) ||                       \
    defined(BGR2RGB_U8_2D) || defined(BGR2RGB_F32_2D) || defined(SPIR)
#define RGB2BGRTYPE_2D(Function, base_type, T, T3)                             \
__kernel                                                                       \
void Function ## base_type ## Kernel1(global const T* src, int rows, int cols, \
                                      int src_stride, global T* dst,           \
                                      int dst_stride) {                        \
  int element_x = get_global_id(0);                                            \
  int element_y = get_global_id(1);                                            \
  if (element_y >= rows || element_x >= cols) {                                \
    return;                                                                    \
  }                                                                            \
                                                                               \
  global T* data = (global T*)((global uchar*)src + element_y * src_stride);   \
  T3 input_value = vload3(element_x, data);                                    \
  T3 value = (T3)(input_value.z, input_value.y, input_value.x);                \
                                                                               \
  data = (global T*)((global uchar*)dst + element_y * dst_stride);             \
  vstore3(value, element_x, data);                                             \
}
#endif

#if defined(BGR2RGB_U8_1D) || defined(SPIR)
RGB2BGRTYPE_1D(BGR2RGB, U8, uchar, uchar3)
#endif

#if defined(BGR2RGB_U8_2D) || defined(SPIR)
RGB2BGRTYPE_2D(BGR2RGB, U8, uchar, uchar3)
#endif

#if defined(BGR2RGB_F32_1D) || defined(SPIR)
RGB2BGRTYPE_1D(BGR2RGB, F32, float, float3)
#endif

#if defined(BGR2RGB_F32_2D) || defined(SPIR)
RGB2BGRTYPE_2D(BGR2RGB, F32, float, float3)
#endif

#if defined(RGB2BGR_U8_1D) || defined(SPIR)
RGB2BGRTYPE_1D(RGB2BGR, U8, uchar, uchar3)
#endif

#if defined(RGB2BGR_U8_2D) || defined(SPIR)
RGB2BGRTYPE_2D(RGB2BGR, U8, uchar, uchar3)
#endif

#if defined(RGB2BGR_F32_1D) || defined(SPIR)
RGB2BGRTYPE_1D(RGB2BGR, F32, float, float3)
#endif

#if defined(RGB2BGR_F32_2D) || defined(SPIR)
RGB2BGRTYPE_2D(RGB2BGR, F32, float, float3)
#endif

/******************************* BGRA <-> RGBA ******************************/

#if defined(BGRA2RGBA_U8_1D) || defined(BGRA2RGBA_F32_1D) ||                   \
    defined(RGBA2BGRA_U8_1D) || defined(RGBA2BGRA_F32_1D) || defined(SPIR)
#define BGRA2RGBATYPE_1D(Function, base_type, T, T4)                           \
__kernel                                                                       \
void Function ## base_type ## Kernel0(global const T* src, int cols,           \
                                      global T* dst) {                         \
  int element_x = get_global_id(0);                                            \
  if (element_x >= cols) {                                                     \
    return;                                                                    \
  }                                                                            \
                                                                               \
  T4 input_value = vload4(element_x, src);                                     \
  T4 value = (T4)(input_value.z, input_value.y, input_value.x, input_value.w); \
                                                                               \
  vstore4(value, element_x, dst);                                              \
}
#endif

#if defined(BGRA2RGBA_U8_2D) || defined(BGRA2RGBA_F32_2D) ||                   \
    defined(RGBA2BGRA_U8_2D) || defined(RGBA2BGRA_F32_2D) || defined(SPIR)
#define BGRA2RGBATYPE_2D(Function, base_type, T, T4)                           \
__kernel                                                                       \
void Function ## base_type ## Kernel1(global const T* src, int rows, int cols, \
                                      int src_stride, global T* dst,           \
                                      int dst_stride) {                        \
  int element_x = get_global_id(0);                                            \
  int element_y = get_global_id(1);                                            \
  if (element_y >= rows || element_x >= cols) {                                \
    return;                                                                    \
  }                                                                            \
                                                                               \
  global T* data = (global T*)((global uchar*)src + element_y * src_stride);   \
  T4 input_value = vload4(element_x, data);                                    \
  T4 value = (T4)(input_value.z, input_value.y, input_value.x, input_value.w); \
                                                                               \
  data = (global T*)((global uchar*)dst + element_y * dst_stride);             \
  vstore4(value, element_x, data);                                             \
}
#endif

#if defined(BGRA2RGBA_U8_1D) || defined(SPIR)
BGRA2RGBATYPE_1D(BGRA2RGBA, U8, uchar, uchar4)
#endif

#if defined(BGRA2RGBA_U8_2D) || defined(SPIR)
BGRA2RGBATYPE_2D(BGRA2RGBA, U8, uchar, uchar4)
#endif

#if defined(BGRA2RGBA_F32_1D) || defined(SPIR)
BGRA2RGBATYPE_1D(BGRA2RGBA, F32, float, float4)
#endif

#if defined(BGRA2RGBA_F32_2D) || defined(SPIR)
BGRA2RGBATYPE_2D(BGRA2RGBA, F32, float, float4)
#endif

#if defined(RGBA2BGRA_U8_1D) || defined(SPIR)
BGRA2RGBATYPE_1D(RGBA2BGRA, U8, uchar, uchar4)
#endif

#if defined(RGBA2BGRA_U8_2D) || defined(SPIR)
BGRA2RGBATYPE_2D(RGBA2BGRA, U8, uchar, uchar4)
#endif

#if defined(RGBA2BGRA_F32_1D) || defined(SPIR)
BGRA2RGBATYPE_1D(RGBA2BGRA, F32, float, float4)
#endif

#if defined(RGBA2BGRA_F32_2D) || defined(SPIR)
BGRA2RGBATYPE_2D(RGBA2BGRA, F32, float, float4)
#endif

/*********************** BGR/RGB/BGRA/RGBA <-> Gray ************************/

enum Bgr2GrayCoefficients {
  kB2Y15    = 3735,
  kG2Y15    = 19235,
  kR2Y15    = 9798,
  kRgbShift = 15,
};

/* #if defined(BGR2GRAY_U8_1D) || defined(BGR2GRAY_F32_1D) ||                     \
    defined(RGB2GRAY_U8_1D) || defined(RGB2GRAY_F32_1D) || defined(SPIR)
#define BGR2GRAYTYPE_1D(Function, base_type, T, T3)                 \
__kernel                                                                       \
void Function ## base_type ## Kernel0(global const T* src, int cols,           \
                                      global T* dst) {                         \
  int element_x = get_global_id(0);                                            \
  int index_x = element_x << 1;                                            \
  if (index_x >= cols) {                                                     \
    return;                                                                    \
  }                                                                            \
                                                                               \
  T3 input_value0 = vload3(index_x, src);                                     \
  T3 input_value1 = vload3(index_x + 1, src);                                     \
  T value0 = Function ## Compute(input_value0);                                  \
  T value1 = Function ## Compute(input_value1);                                  \
                                                                               \
  dst[index_x] = value0;                                              \
  dst[index_x + 1] = value1;                                              \
}
#endif */

#if defined(BGR2GRAY_U8_1D) || defined(BGR2GRAY_F32_1D) ||                     \
    defined(RGB2GRAY_U8_1D) || defined(RGB2GRAY_F32_1D) || defined(SPIR)
#define BGR2GRAYTYPE_1D(Function, base_type, T, T3)                            \
__kernel                                                                       \
void Function ## base_type ## Kernel0(global const T* src, int cols,           \
                                      global T* dst) {                         \
  int element_x = get_global_id(0);                                            \
  if (element_x >= cols) {                                                     \
    return;                                                                    \
  }                                                                            \
                                                                               \
  T3 input_value = vload3(element_x, src);                                     \
  T value = Function ## Compute(input_value);                                  \
                                                                               \
  dst[element_x] = value;                                                      \
}
#endif

#if defined(BGR2GRAY_U8_2D) || defined(BGR2GRAY_F32_2D) ||                     \
    defined(RGB2GRAY_U8_2D) || defined(RGB2GRAY_F32_2D) || defined(SPIR)
#define BGR2GRAYTYPE_2D(Function, base_type, T, T3)                            \
__kernel                                                                       \
void Function ## base_type ## Kernel1(global const T* src, int rows, int cols, \
                                      int src_stride, global T* dst,           \
                                      int dst_stride) {                        \
  int element_x = get_global_id(0);                                            \
  int element_y = get_global_id(1);                                            \
  if (element_y >= rows || element_x >= cols) {                                \
    return;                                                                    \
  }                                                                            \
                                                                               \
  global T* data = (global T*)((global uchar*)src + element_y * src_stride);   \
  T3 input_value = vload3(element_x, data);                                    \
  T value = Function ## Compute(input_value);                                  \
                                                                               \
  data = (global T*)((global uchar*)dst + element_y * dst_stride);             \
  data[element_x] = value;                                                     \
}
#endif

#if defined(BGR2GRAY_U8_1D) || defined(BGR2GRAY_U8_2D) || defined(SPIR)
uchar BGR2GRAYCompute(const uchar3 src) {
  int b = src.x;
  int g = src.y;
  int r = src.z;
  uchar dst = divideUp(b * kB2Y15 + g * kG2Y15 + r * kR2Y15, kRgbShift);

  return dst;
}
#endif

#if defined(BGR2GRAY_F32_1D) || defined(BGR2GRAY_F32_2D) || defined(SPIR)
float BGR2GRAYCompute(const float3 src) {
  float b = src.x;
  float g = src.y;
  float r = src.z;
  float dst = b * 0.114f + g * 0.587f + r * 0.299f;

  return dst;
}
#endif

#if defined(RGB2GRAY_U8_1D) || defined(RGB2GRAY_U8_2D) || defined(SPIR)
uchar RGB2GRAYCompute(const uchar3 src) {
  int r = src.x;
  int g = src.y;
  int b = src.z;
  uchar dst = divideUp(r * kR2Y15 + g * kG2Y15 + b * kB2Y15, kRgbShift);

  return dst;
}
#endif

#if defined(RGB2GRAY_F32_1D) || defined(RGB2GRAY_F32_2D) || defined(SPIR)
float RGB2GRAYCompute(const float3 src) {
  float r = src.x;
  float g = src.y;
  float b = src.z;
  float dst = r * 0.299f + g * 0.587f + b * 0.114f;

  return dst;
}
#endif

#if defined(BGR2GRAY_U8_1D) || defined(SPIR)
BGR2GRAYTYPE_1D(BGR2GRAY, U8, uchar, uchar3)
#endif

#if defined(BGR2GRAY_U8_2D) || defined(SPIR)
BGR2GRAYTYPE_2D(BGR2GRAY, U8, uchar, uchar3)
#endif

#if defined(BGR2GRAY_F32_1D) || defined(SPIR)
BGR2GRAYTYPE_1D(BGR2GRAY, F32, float, float3)
#endif

#if defined(BGR2GRAY_F32_2D) || defined(SPIR)
BGR2GRAYTYPE_2D(BGR2GRAY, F32, float, float3)
#endif

#if defined(RGB2GRAY_U8_1D) || defined(SPIR)
BGR2GRAYTYPE_1D(RGB2GRAY, U8, uchar, uchar3)
#endif

#if defined(RGB2GRAY_U8_2D) || defined(SPIR)
BGR2GRAYTYPE_2D(RGB2GRAY, U8, uchar, uchar3)
#endif

#if defined(RGB2GRAY_F32_1D) || defined(SPIR)
BGR2GRAYTYPE_1D(RGB2GRAY, F32, float, float3)
#endif

#if defined(RGB2GRAY_F32_2D) || defined(SPIR)
BGR2GRAYTYPE_2D(RGB2GRAY, F32, float, float3)
#endif

/* #if defined(BGRA2GRAY_U8_1D) || defined(BGRA2GRAY_F32_1D) ||                   \
    defined(RGBA2GRAY_U8_1D) || defined(RGBA2GRAY_F32_1D) || defined(SPIR)
#define BGRA2GRAYTYPE_1D(Function, base_type, T, T4)                           \
__kernel                                                                       \
void Function ## base_type ## Kernel0(global const T* src, int cols,           \
                                      global T* dst) {                         \
  int element_x = get_global_id(0);                                            \
  int index_x = element_x << 1;                                            \
  if (index_x >= cols) {                                                     \
    return;                                                                    \
  }                                                                            \
                                                                               \
  T4 input_value0 = vload4(index_x, src);                                     \
  T4 input_value1 = vload4(index_x + 1, src);                                     \
  T value0 = Function ## Compute(input_value0);                                  \
  T value1 = Function ## Compute(input_value1);                                  \
                                                                               \
  dst[index_x] = value0;                                              \
  dst[index_x + 1] = value1;                                              \
}
#endif */

#if defined(BGRA2GRAY_U8_1D) || defined(BGRA2GRAY_F32_1D) ||                   \
    defined(RGBA2GRAY_U8_1D) || defined(RGBA2GRAY_F32_1D) || defined(SPIR)
#define BGRA2GRAYTYPE_1D(Function, base_type, T, T4)                           \
__kernel                                                                       \
void Function ## base_type ## Kernel0(global const T* src, int cols,           \
                                      global T* dst) {                         \
  int element_x = get_global_id(0);                                            \
  if (element_x >= cols) {                                                     \
    return;                                                                    \
  }                                                                            \
                                                                               \
  T4 input_value = vload4(element_x, src);                                     \
  T value = Function ## Compute(input_value);                                  \
                                                                               \
  dst[element_x] = value;                                                      \
}
#endif

#if defined(BGRA2GRAY_U8_2D) || defined(BGRA2GRAY_F32_2D) ||                   \
    defined(RGBA2GRAY_U8_2D) || defined(RGBA2GRAY_F32_2D) || defined(SPIR)
#define BGRA2GRAYTYPE_2D(Function, base_type, T, T4)                           \
__kernel                                                                       \
void Function ## base_type ## Kernel1(global const T* src, int rows, int cols, \
                                      int src_stride, global T* dst,           \
                                      int dst_stride) {                        \
  int element_x = get_global_id(0);                                            \
  int element_y = get_global_id(1);                                            \
  if (element_y >= rows || element_x >= cols) {                                \
    return;                                                                    \
  }                                                                            \
                                                                               \
  global T* data = (global T*)((global uchar*)src + element_y * src_stride);   \
  T4 input_value = vload4(element_x, data);                                    \
  T value = Function ## Compute(input_value);                                  \
                                                                               \
  data = (global T*)((global uchar*)dst + element_y * dst_stride);             \
  data[element_x] = value;                                                     \
}
#endif

#if defined(BGRA2GRAY_U8_1D) || defined(BGRA2GRAY_U8_2D) || defined(SPIR)
uchar BGRA2GRAYCompute(const uchar4 src) {
  int b = src.x;
  int g = src.y;
  int r = src.z;
  uchar dst = divideUp(b * kB2Y15 + g * kG2Y15 + r * kR2Y15, kRgbShift);

  return dst;
}
#endif

#if defined(BGRA2GRAY_F32_1D) || defined(BGRA2GRAY_F32_2D) || defined(SPIR)
float BGRA2GRAYCompute(const float4 src) {
  float b = src.x;
  float g = src.y;
  float r = src.z;
  float dst = b * 0.114f + g * 0.587f + r * 0.299f;

  return dst;
}
#endif

#if defined(RGBA2GRAY_U8_1D) || defined(RGBA2GRAY_U8_2D) || defined(SPIR)
uchar RGBA2GRAYCompute(const uchar4 src) {
  int r = src.x;
  int g = src.y;
  int b = src.z;
  uchar dst = divideUp(r * kR2Y15 + g * kG2Y15 + b * kB2Y15, kRgbShift);

  return dst;
}
#endif

#if defined(RGBA2GRAY_F32_1D) || defined(RGBA2GRAY_F32_2D) || defined(SPIR)
float RGBA2GRAYCompute(const float4 src) {
  float r = src.x;
  float g = src.y;
  float b = src.z;
  float dst = r * 0.299f + g * 0.587f + b * 0.114f;

  return dst;
}
#endif

#if defined(BGRA2GRAY_U8_1D) || defined(SPIR)
BGRA2GRAYTYPE_1D(BGRA2GRAY, U8, uchar, uchar4)
#endif

#if defined(BGRA2GRAY_U8_2D) || defined(SPIR)
BGRA2GRAYTYPE_2D(BGRA2GRAY, U8, uchar, uchar4)
#endif

#if defined(BGRA2GRAY_F32_1D) || defined(SPIR)
BGRA2GRAYTYPE_1D(BGRA2GRAY, F32, float, float4)
#endif

#if defined(BGRA2GRAY_F32_2D) || defined(SPIR)
BGRA2GRAYTYPE_2D(BGRA2GRAY, F32, float, float4)
#endif

#if defined(RGBA2GRAY_U8_1D) || defined(SPIR)
BGRA2GRAYTYPE_1D(RGBA2GRAY, U8, uchar, uchar4)
#endif

#if defined(RGBA2GRAY_U8_2D) || defined(SPIR)
BGRA2GRAYTYPE_2D(RGBA2GRAY, U8, uchar, uchar4)
#endif

#if defined(RGBA2GRAY_F32_1D) || defined(SPIR)
BGRA2GRAYTYPE_1D(RGBA2GRAY, F32, float, float4)
#endif

#if defined(RGBA2GRAY_F32_2D) || defined(SPIR)
BGRA2GRAYTYPE_2D(RGBA2GRAY, F32, float, float4)
#endif

/* #if defined(GRAY2BGR_U8_1D) || defined(GRAY2BGR_F32_1D) ||                   \
    defined(GRAY2RGB_U8_1D) || defined(GRAY2RGB_F32_1D) || defined(SPIR)
#define GRAY2BGRTYPE_1D(Function, base_type, T, T3)                           \
__kernel                                                                       \
void Function ## base_type ## Kernel0(global const T* src, int cols,           \
                                      global T* dst) {                         \
  int element_x = get_global_id(0);                                            \
  int index_x = element_x << 1;                                            \
  if (index_x >= cols) {                                                     \
    return;                                                                    \
  }                                                                            \
                                                                               \
  T input_value0 = src[index_x];                                     \
  T input_value1 = src[index_x + 1];                                     \
  T3 value0 = Function ## Compute(input_value0);                                  \
  T3 value1 = Function ## Compute(input_value1);                                  \
                                                                               \
  vstore3(value0, index_x, dst);                                              \
  vstore3(value1, index_x + 1, dst);                                              \
}
#endif */

#if defined(GRAY2BGR_U8_1D) || defined(GRAY2BGR_F32_1D) ||                     \
    defined(GRAY2RGB_U8_1D) || defined(GRAY2RGB_F32_1D) || defined(SPIR)
#define GRAY2BGRTYPE_1D(Function, base_type, T, T3)                            \
__kernel                                                                       \
void Function ## base_type ## Kernel0(global const T* src, int cols,           \
                                      global T* dst) {                         \
  int element_x = get_global_id(0);                                            \
  if (element_x >= cols) {                                                     \
    return;                                                                    \
  }                                                                            \
                                                                               \
  T input_value = src[element_x];                                              \
  T3 value = Function ## Compute(input_value);                                 \
                                                                               \
  vstore3(value, element_x, dst);                                              \
}
#endif

#if defined(GRAY2BGR_U8_2D) || defined(GRAY2BGR_F32_2D) ||                     \
    defined(GRAY2RGB_U8_2D) || defined(GRAY2RGB_F32_2D) || defined(SPIR)
#define GRAY2BGRTYPE_2D(Function, base_type, T, T3)                            \
__kernel                                                                       \
void Function ## base_type ## Kernel1(global const T* src, int rows, int cols, \
                                      int src_stride, global T* dst,           \
                                      int dst_stride) {                        \
  int element_x = get_global_id(0);                                            \
  int element_y = get_global_id(1);                                            \
  if (element_y >= rows || element_x >= cols) {                                \
    return;                                                                    \
  }                                                                            \
                                                                               \
  global T* data = (global T*)((global uchar*)src + element_y * src_stride);   \
  T input_value = data[element_x];                                             \
  T3 value = Function ## Compute(input_value);                                 \
                                                                               \
  data = (global T*)((global uchar*)dst + element_y * dst_stride);             \
  vstore3(value, element_x, data);                                             \
}
#endif

#if defined(GRAY2BGR_U8_1D) || defined(GRAY2BGR_U8_2D) || defined(SPIR)
uchar3 GRAY2BGRCompute(const uchar src) {
  uchar3 dst;
  dst.x = src;
  dst.y = src;
  dst.z = src;

  return dst;
}
#endif

#if defined(GRAY2BGR_F32_1D) || defined(GRAY2BGR_F32_2D) || defined(SPIR)
float3 GRAY2BGRCompute(const float src) {
  float3 dst;
  dst.x = src;
  dst.y = src;
  dst.z = src;

  return dst;
}
#endif

#if defined(GRAY2RGB_U8_1D) || defined(GRAY2RGB_U8_2D) || defined(SPIR)
uchar3 GRAY2RGBCompute(const uchar src) {
  uchar3 dst;
  dst.x = src;
  dst.y = src;
  dst.z = src;

  return dst;
}
#endif

#if defined(GRAY2RGB_F32_1D) || defined(GRAY2RGB_F32_2D) || defined(SPIR)
float3 GRAY2RGBCompute(const float src) {
  float3 dst;
  dst.x = src;
  dst.y = src;
  dst.z = src;

  return dst;
}
#endif

#if defined(GRAY2BGR_U8_1D) || defined(SPIR)
GRAY2BGRTYPE_1D(GRAY2BGR, U8, uchar, uchar3)
#endif

#if defined(GRAY2BGR_U8_2D) || defined(SPIR)
GRAY2BGRTYPE_2D(GRAY2BGR, U8, uchar, uchar3)
#endif

#if defined(GRAY2BGR_F32_1D) || defined(SPIR)
GRAY2BGRTYPE_1D(GRAY2BGR, F32, float, float3)
#endif

#if defined(GRAY2BGR_F32_2D) || defined(SPIR)
GRAY2BGRTYPE_2D(GRAY2BGR, F32, float, float3)
#endif

#if defined(GRAY2RGB_U8_1D) || defined(SPIR)
GRAY2BGRTYPE_1D(GRAY2RGB, U8, uchar, uchar3)
#endif

#if defined(GRAY2RGB_U8_2D) || defined(SPIR)
GRAY2BGRTYPE_2D(GRAY2RGB, U8, uchar, uchar3)
#endif

#if defined(GRAY2RGB_F32_1D) || defined(SPIR)
GRAY2BGRTYPE_1D(GRAY2RGB, F32, float, float3)
#endif

#if defined(GRAY2RGB_F32_2D) || defined(SPIR)
GRAY2BGRTYPE_2D(GRAY2RGB, F32, float, float3)
#endif

#if defined(GRAY2BGRA_U8_1D) || defined(GRAY2BGRA_F32_1D) ||                   \
    defined(GRAY2RGBA_U8_1D) || defined(GRAY2RGBA_F32_1D) || defined(SPIR)
#define GRAY2BGRATYPE_1D(Function, base_type, T, T4)                           \
__kernel                                                                       \
void Function ## base_type ## Kernel0(global const T* src, int cols,           \
                                      global T* dst) {                         \
  int element_x = get_global_id(0);                                            \
  if (element_x >= cols) {                                                     \
    return;                                                                    \
  }                                                                            \
                                                                               \
  T input_value = src[element_x];                                              \
  T4 value = Function ## Compute(input_value);                                 \
                                                                               \
  vstore4(value, element_x, dst);                                              \
}
#endif

#if defined(GRAY2BGRA_U8_2D) || defined(GRAY2BGRA_F32_2D) ||                   \
    defined(GRAY2RGBA_U8_2D) || defined(GRAY2RGBA_F32_2D) || defined(SPIR)
#define GRAY2BGRATYPE_2D(Function, base_type, T, T4)                           \
__kernel                                                                       \
void Function ## base_type ## Kernel1(global const T* src, int rows, int cols, \
                                      int src_stride, global T* dst,           \
                                      int dst_stride) {                        \
  int element_x = get_global_id(0);                                            \
  int element_y = get_global_id(1);                                            \
  if (element_y >= rows || element_x >= cols) {                                \
    return;                                                                    \
  }                                                                            \
                                                                               \
  global T* data = (global T*)((global uchar*)src + element_y * src_stride);   \
  T input_value = data[element_x];                                             \
  T4 value = Function ## Compute(input_value);                                 \
                                                                               \
  data = (global T*)((global uchar*)dst + element_y * dst_stride);             \
  vstore4(value, element_x, data);                                             \
}
#endif

#if defined(GRAY2BGRA_U8_1D) || defined(GRAY2BGRA_U8_2D) || defined(SPIR)
uchar4 GRAY2BGRACompute(const uchar src) {
  uchar4 dst;
  dst.x = src;
  dst.y = src;
  dst.z = src;
  dst.w = 255;

  return dst;
}
#endif

#if defined(GRAY2BGRA_F32_1D) || defined(GRAY2BGRA_F32_2D) || defined(SPIR)
float4 GRAY2BGRACompute(const float src) {
  float4 dst;
  dst.x = src;
  dst.y = src;
  dst.z = src;
  dst.w = 1.0f;

  return dst;
}
#endif

#if defined(GRAY2RGBA_U8_1D) || defined(GRAY2RGBA_U8_2D) || defined(SPIR)
uchar4 GRAY2RGBACompute(const uchar src) {
  uchar4 dst;
  dst.x = src;
  dst.y = src;
  dst.z = src;
  dst.w = 255;

  return dst;
}
#endif

#if defined(GRAY2RGBA_F32_1D) || defined(GRAY2RGBA_F32_2D) || defined(SPIR)
float4 GRAY2RGBACompute(const float src) {
  float4 dst;
  dst.x = src;
  dst.y = src;
  dst.z = src;
  dst.w = 1.0f;

  return dst;
}
#endif

#if defined(GRAY2BGRA_U8_1D) || defined(SPIR)
GRAY2BGRATYPE_1D(GRAY2BGRA, U8, uchar, uchar4)
#endif

#if defined(GRAY2BGRA_U8_2D) || defined(SPIR)
GRAY2BGRATYPE_2D(GRAY2BGRA, U8, uchar, uchar4)
#endif

#if defined(GRAY2BGRA_F32_1D) || defined(SPIR)
GRAY2BGRATYPE_1D(GRAY2BGRA, F32, float, float4)
#endif

#if defined(GRAY2BGRA_F32_2D) || defined(SPIR)
GRAY2BGRATYPE_2D(GRAY2BGRA, F32, float, float4)
#endif

#if defined(GRAY2RGBA_U8_1D) || defined(SPIR)
GRAY2BGRATYPE_1D(GRAY2RGBA, U8, uchar, uchar4)
#endif

#if defined(GRAY2RGBA_U8_2D) || defined(SPIR)
GRAY2BGRATYPE_2D(GRAY2RGBA, U8, uchar, uchar4)
#endif

#if defined(GRAY2RGBA_F32_1D) || defined(SPIR)
GRAY2BGRATYPE_1D(GRAY2RGBA, F32, float, float4)
#endif

#if defined(GRAY2RGBA_F32_2D) || defined(SPIR)
GRAY2BGRATYPE_2D(GRAY2RGBA, F32, float, float4)
#endif

/*********************** BGR/RGB/BGRA/RGBA <-> YCrCb ************************/

#define R2Y_FLOAT_COEFF 0.299f
#define G2Y_FLOAT_COEFF 0.587f
#define B2Y_FLOAT_COEFF 0.114f
#define CR_FLOAT_COEFF 0.713f
#define CB_FLOAT_COEFF 0.564f
#define YCRCB_UCHAR_DELTA 128
#define YCRCB_FLOAT_DELTA 0.5f
#define CR2R_FLOAT_COEFF 1.403f
#define CB2R_FLOAT_COEFF 1.773f
#define Y2G_CR_FLOAT_COEFF -0.714f
#define Y2G_CB_FLOAT_COEFF -0.344f

enum YCrCbIntegerCoefficients1 {
  kB2YCoeff = 1868,
  kG2YCoeff = 9617,
  kR2YCoeff = 4899,
  kCRCoeff  = 11682,
  kCBCoeff  = 9241,
};

enum YCrCbIntegerCoefficients2 {
  kCr2RCoeff  = 22987,
  kCb2BCoeff  = 29049,
  kY2GCrCoeff = -11698,
  kY2GCbCoeff = -5636,
};

enum YCrCbShifts {
  kYCrCbShift   = 14,
  kShift14Delta = 2097152,
};

#if defined(BGR2YCrCb_U8_1D) || defined(BGR2YCrCb_F32_1D) ||                   \
    defined(RGB2YCrCb_U8_1D) || defined(RGB2YCrCb_F32_1D) ||                   \
    defined(YCrCb2BGR_U8_1D) || defined(YCrCb2BGR_F32_1D) ||                   \
    defined(YCrCb2RGB_U8_1D) || defined(YCrCb2RGB_F32_1D) ||                   \
    defined(BGR2HSV_U8_1D) || defined(BGR2HSV_F32_1D) ||                       \
    defined(RGB2HSV_U8_1D) || defined(RGB2HSV_F32_1D) ||                       \
    defined(HSV2BGR_U8_1D) || defined(HSV2BGR_F32_1D) ||                       \
    defined(HSV2RGB_U8_1D) || defined(HSV2RGB_F32_1D) ||                       \
    defined(BGR2LAB_U8_1D) || defined(BGR2LAB_F32_1D) ||                       \
    defined(RGB2LAB_U8_1D) || defined(RGB2LAB_F32_1D) ||                       \
    defined(LAB2BGR_U8_1D) || defined(LAB2BGR_F32_1D) ||                       \
    defined(LAB2RGB_U8_1D) || defined(LAB2RGB_F32_1D) || defined(SPIR)
#define Convert3To3_1D(Function, base_type, T, T3)                             \
__kernel                                                                       \
void Function ## base_type ## Kernel0(global const T* src, int cols,           \
                                      global T* dst) {                         \
  int element_x = get_global_id(0);                                            \
  if (element_x >= cols) {                                                     \
    return;                                                                    \
  }                                                                            \
                                                                               \
  T3 input_value = vload3(element_x, src);                                     \
  T3 value = Function ## Compute(input_value);                                 \
                                                                               \
  vstore3(value, element_x, dst);                                              \
}
#endif

#if defined(BGR2YCrCb_U8_2D) || defined(BGR2YCrCb_F32_2D) ||                   \
    defined(RGB2YCrCb_U8_2D) || defined(RGB2YCrCb_F32_2D) ||                   \
    defined(YCrCb2BGR_U8_2D) || defined(YCrCb2BGR_F32_2D) ||                   \
    defined(YCrCb2RGB_U8_2D) || defined(YCrCb2RGB_F32_2D) ||                   \
    defined(BGR2HSV_U8_2D) || defined(BGR2HSV_F32_2D) ||                       \
    defined(RGB2HSV_U8_2D) || defined(RGB2HSV_F32_2D) ||                       \
    defined(HSV2BGR_U8_2D) || defined(HSV2BGR_F32_2D) ||                       \
    defined(HSV2RGB_U8_2D) || defined(HSV2RGB_F32_2D) ||                       \
    defined(BGR2LAB_U8_2D) || defined(BGR2LAB_F32_2D) ||                       \
    defined(RGB2LAB_U8_2D) || defined(RGB2LAB_F32_2D) ||                       \
    defined(LAB2BGR_U8_2D) || defined(LAB2BGR_F32_2D) ||                       \
    defined(LAB2RGB_U8_2D) || defined(LAB2RGB_F32_2D) || defined(SPIR)
#define Convert3To3_2D(Function, base_type, T, T3)                             \
__kernel                                                                       \
void Function ## base_type ## Kernel1(global const T* src, int rows, int cols, \
                                      int src_stride, global T* dst,           \
                                      int dst_stride) {                        \
  int element_x = get_global_id(0);                                            \
  int element_y = get_global_id(1);                                            \
  if (element_y >= rows || element_x >= cols) {                                \
    return;                                                                    \
  }                                                                            \
                                                                               \
  global T* data = (global T*)((global uchar*)src + element_y * src_stride);   \
  T3 input_value = vload3(element_x, data);                                    \
  T3 value = Function ## Compute(input_value);                                 \
                                                                               \
  data = (global T*)((global uchar*)dst + element_y * dst_stride);             \
  vstore3(value, element_x, data);                                             \
}
#endif

#if defined(BGR2YCrCb_U8_1D) || defined(BGR2YCrCb_U8_2D) || defined(SPIR)
uchar3 BGR2YCrCbCompute(const uchar3 src) {
  int3 value;
  value.x = divideUp(src.z * kR2YCoeff + src.y * kG2YCoeff + src.x * kB2YCoeff,
                     kYCrCbShift);
  value.y = divideUp((src.z - value.x) * kCRCoeff + kShift14Delta, kYCrCbShift);
  value.z = divideUp((src.x - value.x) * kCBCoeff + kShift14Delta, kYCrCbShift);

  uchar3 dst = convert_uchar3_sat(value);

  return dst;
}
#endif

#if defined(BGR2YCrCb_F32_1D) || defined(BGR2YCrCb_F32_2D) || defined(SPIR)
float3 BGR2YCrCbCompute(const float3 src) {
  float3 dst;
  dst.x = src.z * R2Y_FLOAT_COEFF + src.y * G2Y_FLOAT_COEFF +
          src.x * B2Y_FLOAT_COEFF;
  dst.y = (src.z - dst.x) * CR_FLOAT_COEFF + YCRCB_FLOAT_DELTA;
  dst.z = (src.x - dst.x) * CB_FLOAT_COEFF + YCRCB_FLOAT_DELTA;

  return dst;
}
#endif

#if defined(RGB2YCrCb_U8_1D) || defined(RGB2YCrCb_U8_2D) || defined(SPIR)
uchar3 RGB2YCrCbCompute(const uchar3 src) {
  int3 value;
  value.x = divideUp(src.x * kR2YCoeff + src.y * kG2YCoeff + src.z * kB2YCoeff,
                     kYCrCbShift);
  value.y = divideUp((src.x - value.x) * kCRCoeff + kShift14Delta, kYCrCbShift);
  value.z = divideUp((src.z - value.x) * kCBCoeff + kShift14Delta, kYCrCbShift);

  uchar3 dst = convert_uchar3_sat(value);

  return dst;
}
#endif

#if defined(RGB2YCrCb_F32_1D) || defined(RGB2YCrCb_F32_2D) || defined(SPIR)
float3 RGB2YCrCbCompute(const float3 src) {
  float3 dst;
  dst.x = src.x * R2Y_FLOAT_COEFF + src.y * G2Y_FLOAT_COEFF +
          src.z * B2Y_FLOAT_COEFF;
  dst.y = (src.x - dst.x) * CR_FLOAT_COEFF + YCRCB_FLOAT_DELTA;
  dst.z = (src.z - dst.x) * CB_FLOAT_COEFF + YCRCB_FLOAT_DELTA;

  return dst;
}
#endif

#if defined(BGR2YCrCb_U8_1D) || defined(SPIR)
Convert3To3_1D(BGR2YCrCb, U8, uchar, uchar3)
#endif

#if defined(BGR2YCrCb_U8_2D) || defined(SPIR)
Convert3To3_2D(BGR2YCrCb, U8, uchar, uchar3)
#endif

#if defined(BGR2YCrCb_F32_1D) || defined(SPIR)
Convert3To3_1D(BGR2YCrCb, F32, float, float3)
#endif

#if defined(BGR2YCrCb_F32_2D) || defined(SPIR)
Convert3To3_2D(BGR2YCrCb, F32, float, float3)
#endif

#if defined(RGB2YCrCb_U8_1D) || defined(SPIR)
Convert3To3_1D(RGB2YCrCb, U8, uchar, uchar3)
#endif

#if defined(RGB2YCrCb_U8_2D) || defined(SPIR)
Convert3To3_2D(RGB2YCrCb, U8, uchar, uchar3)
#endif

#if defined(RGB2YCrCb_F32_1D) || defined(SPIR)
Convert3To3_1D(RGB2YCrCb, F32, float, float3)
#endif

#if defined(RGB2YCrCb_F32_2D) || defined(SPIR)
Convert3To3_2D(RGB2YCrCb, F32, float, float3)
#endif


#if defined(BGRA2YCrCb_U8_1D) || defined(BGRA2YCrCb_F32_1D) ||                 \
    defined(RGBA2YCrCb_U8_1D) || defined(RGBA2YCrCb_F32_1D) ||                 \
    defined(BGRA2HSV_U8_1D) || defined(BGRA2HSV_F32_1D) ||                     \
    defined(RGBA2HSV_U8_1D) || defined(RGBA2HSV_F32_1D) ||                     \
    defined(BGRA2LAB_U8_1D) || defined(BGRA2LAB_F32_1D) ||                     \
    defined(RGBA2LAB_U8_1D) || defined(RGBA2LAB_F32_1D) || defined(SPIR)
#define Convert4To3_1D(Function, base_type, T, T4, T3)                         \
__kernel                                                                       \
void Function ## base_type ## Kernel0(global const T* src, int cols,           \
                                      global T* dst) {                         \
  int element_x = get_global_id(0);                                            \
  if (element_x >= cols) {                                                     \
    return;                                                                    \
  }                                                                            \
                                                                               \
  T4 input_value = vload4(element_x, src);                                     \
  T3 value = Function ## Compute(input_value);                                 \
                                                                               \
  vstore3(value, element_x, dst);                                              \
}
#endif

#if defined(BGRA2YCrCb_U8_2D) || defined(BGRA2YCrCb_F32_2D) ||                 \
    defined(RGBA2YCrCb_U8_2D) || defined(RGBA2YCrCb_F32_2D) ||                 \
    defined(BGRA2YHSV_U8_2D) || defined(BGRA2YHSV_F32_2D) ||                   \
    defined(RGBA2YHSV_U8_2D) || defined(RGBA2YHSV_F32_2D) ||                   \
    defined(BGRA2YLAB_U8_2D) || defined(BGRA2YLAB_F32_2D) ||                   \
    defined(RGBA2YLAB_U8_2D) || defined(RGBA2YLAB_F32_2D) || defined(SPIR)
#define Convert4To3_2D(Function, base_type, T, T4, T3)                         \
__kernel                                                                       \
void Function ## base_type ## Kernel1(global const T* src, int rows, int cols, \
                                      int src_stride, global T* dst,           \
                                      int dst_stride) {                        \
  int element_x = get_global_id(0);                                            \
  int element_y = get_global_id(1);                                            \
  if (element_y >= rows || element_x >= cols) {                                \
    return;                                                                    \
  }                                                                            \
                                                                               \
  global T* data = (global T*)((global uchar*)src + element_y * src_stride);   \
  T4 input_value = vload4(element_x, data);                                    \
  T3 value = Function ## Compute(input_value);                                 \
                                                                               \
  data = (global T*)((global uchar*)dst + element_y * dst_stride);             \
  vstore3(value, element_x, data);                                             \
}
#endif

#if defined(BGRA2YCrCb_U8_1D) || defined(BGRA2YCrCb_U8_2D) || defined(SPIR)
uchar3 BGRA2YCrCbCompute(const uchar4 src) {
  int3 value;
  value.x = divideUp(src.z * kR2YCoeff + src.y * kG2YCoeff + src.x * kB2YCoeff,
                     kYCrCbShift);
  value.y = divideUp((src.z - value.x) * kCRCoeff + kShift14Delta, kYCrCbShift);
  value.z = divideUp((src.x - value.x) * kCBCoeff + kShift14Delta, kYCrCbShift);

  uchar3 dst = convert_uchar3_sat(value);

  return dst;
}
#endif

#if defined(BGRA2YCrCb_F32_1D) || defined(BGRA2YCrCb_F32_2D) || defined(SPIR)
float3 BGRA2YCrCbCompute(const float4 src) {
  float3 dst;
  dst.x = src.z * R2Y_FLOAT_COEFF + src.y * G2Y_FLOAT_COEFF +
          src.x * B2Y_FLOAT_COEFF;
  dst.y = (src.z - dst.x) * CR_FLOAT_COEFF + YCRCB_FLOAT_DELTA;
  dst.z = (src.x - dst.x) * CB_FLOAT_COEFF + YCRCB_FLOAT_DELTA;

  return dst;
}
#endif

#if defined(RGBA2YCrCb_U8_1D) || defined(RGBA2YCrCb_U8_2D) || defined(SPIR)
uchar3 RGBA2YCrCbCompute(const uchar4 src) {
  int3 value;
  value.x = divideUp(src.x * kR2YCoeff + src.y * kG2YCoeff + src.z * kB2YCoeff,
                     kYCrCbShift);
  value.y = divideUp((src.x - value.x) * kCRCoeff + kShift14Delta, kYCrCbShift);
  value.z = divideUp((src.z - value.x) * kCBCoeff + kShift14Delta, kYCrCbShift);

  uchar3 dst = convert_uchar3_sat(value);

  return dst;
}
#endif

#if defined(RGBA2YCrCb_F32_1D) || defined(RGBA2YCrCb_F32_2D) || defined(SPIR)
float3 RGBA2YCrCbCompute(const float4 src) {
  float3 dst;
  dst.x = src.x * R2Y_FLOAT_COEFF + src.y * G2Y_FLOAT_COEFF +
          src.z * B2Y_FLOAT_COEFF;
  dst.y = (src.x - dst.x) * CR_FLOAT_COEFF + YCRCB_FLOAT_DELTA;
  dst.z = (src.z - dst.x) * CB_FLOAT_COEFF + YCRCB_FLOAT_DELTA;

  return dst;
}
#endif

#if defined(BGRA2YCrCb_U8_1D) || defined(SPIR)
Convert4To3_1D(BGRA2YCrCb, U8, uchar, uchar4, uchar3)
#endif

#if defined(BGRA2YCrCb_U8_2D) || defined(SPIR)
Convert4To3_2D(BGRA2YCrCb, U8, uchar, uchar4, uchar3)
#endif

#if defined(BGRA2YCrCb_F32_1D) || defined(SPIR)
Convert4To3_1D(BGRA2YCrCb, F32, float, float4, float3)
#endif

#if defined(BGRA2YCrCb_F32_2D) || defined(SPIR)
Convert4To3_2D(BGRA2YCrCb, F32, float, float4, float3)
#endif

#if defined(RGBA2YCrCb_U8_1D) || defined(SPIR)
Convert4To3_1D(RGBA2YCrCb, U8, uchar, uchar4, uchar3)
#endif

#if defined(RGBA2YCrCb_U8_2D) || defined(SPIR)
Convert4To3_2D(RGBA2YCrCb, U8, uchar, uchar4, uchar3)
#endif

#if defined(RGBA2YCrCb_F32_1D) || defined(SPIR)
Convert4To3_1D(RGBA2YCrCb, F32, float, float4, float3)
#endif

#if defined(RGBA2YCrCb_F32_2D) || defined(SPIR)
Convert4To3_2D(RGBA2YCrCb, F32, float, float4, float3)
#endif


#if defined(YCrCb2BGR_U8_1D) || defined(YCrCb2BGR_U8_2D) || defined(SPIR)
uchar3 YCrCb2BGRCompute(const uchar3 src) {
  int y  = src.x;
  int cr = src.y - YCRCB_UCHAR_DELTA;
  int cb = src.z - YCRCB_UCHAR_DELTA;

  int3 value;
  value.x = y + divideUp(cb * kCb2BCoeff, kYCrCbShift);
  value.y = y + divideUp(cr * kY2GCrCoeff + cb * kY2GCbCoeff, kYCrCbShift);
  value.z = y + divideUp(cr * kCr2RCoeff, kYCrCbShift);

  uchar3 dst = convert_uchar3_sat(value);

  return dst;
}
#endif

#if defined(YCrCb2BGR_F32_1D) || defined(YCrCb2BGR_F32_2D) || defined(SPIR)
float3 YCrCb2BGRCompute(const float3 src) {
  float y  = src.x;
  float cr = src.y - YCRCB_FLOAT_DELTA;
  float cb = src.z - YCRCB_FLOAT_DELTA;

  float3 dst;
  dst.x = y + cb * CB2R_FLOAT_COEFF;
  dst.y = y + cr * Y2G_CR_FLOAT_COEFF + cb * Y2G_CB_FLOAT_COEFF;
  dst.z = y + cr * CR2R_FLOAT_COEFF;

  return dst;
}
#endif

#if defined(YCrCb2RGB_U8_1D) || defined(YCrCb2RGB_U8_2D) || defined(SPIR)
uchar3 YCrCb2RGBCompute(const uchar3 src) {
  int y  = src.x;
  int cr = src.y - YCRCB_UCHAR_DELTA;
  int cb = src.z - YCRCB_UCHAR_DELTA;

  int3 value;
  value.x = y + divideUp(cr * kCr2RCoeff, kYCrCbShift);
  value.y = y + divideUp(cr * kY2GCrCoeff + cb * kY2GCbCoeff, kYCrCbShift);
  value.z = y + divideUp(cb * kCb2BCoeff, kYCrCbShift);

  uchar3 dst = convert_uchar3_sat(value);

  return dst;
}
#endif

#if defined(YCrCb2RGB_F32_1D) || defined(YCrCb2RGB_F32_2D) || defined(SPIR)
float3 YCrCb2RGBCompute(const float3 src) {
  float y  = src.x;
  float cr = src.y - YCRCB_FLOAT_DELTA;
  float cb = src.z - YCRCB_FLOAT_DELTA;

  float3 dst;
  dst.x = y + cr * CR2R_FLOAT_COEFF;
  dst.y = y + cr * Y2G_CR_FLOAT_COEFF + cb * Y2G_CB_FLOAT_COEFF;
  dst.z = y + cb * CB2R_FLOAT_COEFF;

  return dst;
}
#endif

#if defined(YCrCb2BGR_U8_1D) || defined(SPIR)
Convert3To3_1D(YCrCb2BGR, U8, uchar, uchar3)
#endif

#if defined(YCrCb2BGR_U8_2D) || defined(SPIR)
Convert3To3_2D(YCrCb2BGR, U8, uchar, uchar3)
#endif

#if defined(YCrCb2BGR_F32_1D) || defined(SPIR)
Convert3To3_1D(YCrCb2BGR, F32, float, float3)
#endif

#if defined(YCrCb2BGR_F32_2D) || defined(SPIR)
Convert3To3_2D(YCrCb2BGR, F32, float, float3)
#endif

#if defined(YCrCb2RGB_U8_1D) || defined(SPIR)
Convert3To3_1D(YCrCb2RGB, U8, uchar, uchar3)
#endif

#if defined(YCrCb2RGB_U8_2D) || defined(SPIR)
Convert3To3_2D(YCrCb2RGB, U8, uchar, uchar3)
#endif

#if defined(YCrCb2RGB_F32_1D) || defined(SPIR)
Convert3To3_1D(YCrCb2RGB, F32, float, float3)
#endif

#if defined(YCrCb2RGB_F32_2D) || defined(SPIR)
Convert3To3_2D(YCrCb2RGB, F32, float, float3)
#endif


#if defined(YCrCb2BGRA_U8_1D) || defined(YCrCb2BGRA_F32_1D) ||                 \
    defined(YCrCb2RGBA_U8_1D) || defined(YCrCb2RGBA_F32_1D) ||                 \
    defined(HSV2BGRA_U8_1D) || defined(HSV2BGRA_F32_1D) ||                     \
    defined(HSV2RGBA_U8_1D) || defined(HSV2RGBA_F32_1D) ||                     \
    defined(LAB2BGRA_U8_1D) || defined(LAB2BGRA_F32_1D) ||                     \
    defined(LAB2RGBA_U8_1D) || defined(LAB2RGBA_F32_1D) || defined(SPIR)
#define Convert3To4_1D(Function, base_type, T, T3, T4)                         \
__kernel                                                                       \
void Function ## base_type ## Kernel0(global const T* src, int cols,           \
                                      global T* dst) {                         \
  int element_x = get_global_id(0);                                            \
  if (element_x >= cols) {                                                     \
    return;                                                                    \
  }                                                                            \
                                                                               \
  T3 input_value = vload3(element_x, src);                                     \
  T4 value = Function ## Compute(input_value);                                 \
                                                                               \
  vstore4(value, element_x, dst);                                              \
}
#endif

#if defined(YCrCb2BGRA_U8_2D) || defined(YCrCb2BGRA_F32_2D) ||                 \
    defined(YCrCb2RGBA_U8_2D) || defined(YCrCb2RGBA_F32_2D) ||                 \
    defined(HSV2BGRA_U8_2D) || defined(HSV2BGRA_F32_2D) ||                     \
    defined(HSV2RGBA_U8_2D) || defined(HSV2RGBA_F32_2D) ||                     \
    defined(LAB2BGRA_U8_2D) || defined(LAB2BGRA_F32_2D) ||                     \
    defined(LAB2RGBA_U8_2D) || defined(LAB2RGBA_F32_2D) || defined(SPIR)
#define Convert3To4_2D(Function, base_type, T, T3, T4)                         \
__kernel                                                                       \
void Function ## base_type ## Kernel1(global const T* src, int rows, int cols, \
                                      int src_stride, global T* dst,           \
                                      int dst_stride) {                        \
  int element_x = get_global_id(0);                                            \
  int element_y = get_global_id(1);                                            \
  if (element_y >= rows || element_x >= cols) {                                \
    return;                                                                    \
  }                                                                            \
                                                                               \
  global T* data = (global T*)((global uchar*)src + element_y * src_stride);   \
  T3 input_value = vload3(element_x, data);                                    \
  T4 value = Function ## Compute(input_value);                                 \
                                                                               \
  data = (global T*)((global uchar*)dst + element_y * dst_stride);             \
  vstore4(value, element_x, data);                                             \
}
#endif

#if defined(YCrCb2BGRA_U8_1D) || defined(YCrCb2BGRA_U8_2D) || defined(SPIR)
uchar4 YCrCb2BGRACompute(const uchar3 src) {
  int y  = src.x;
  int cr = src.y - YCRCB_UCHAR_DELTA;
  int cb = src.z - YCRCB_UCHAR_DELTA;

  int4 value;
  value.x = y + divideUp(cb * kCb2BCoeff, kYCrCbShift);
  value.y = y + divideUp(cr * kY2GCrCoeff + cb * kY2GCbCoeff, kYCrCbShift);
  value.z = y + divideUp(cr * kCr2RCoeff, kYCrCbShift);
  value.w = 255.f;

  uchar4 dst = convert_uchar4_sat(value);

  return dst;
}
#endif

#if defined(YCrCb2BGRA_F32_1D) || defined(YCrCb2BGRA_F32_2D) || defined(SPIR)
float4 YCrCb2BGRACompute(const float3 src) {
  float y  = src.x;
  float cr = src.y - YCRCB_FLOAT_DELTA;
  float cb = src.z - YCRCB_FLOAT_DELTA;

  float4 dst;
  dst.x = y + cb * CB2R_FLOAT_COEFF;
  dst.y = y + cr * Y2G_CR_FLOAT_COEFF + cb * Y2G_CB_FLOAT_COEFF;
  dst.z = y + cr * CR2R_FLOAT_COEFF;
  dst.w = 1.0f;

  return dst;
}
#endif

#if defined(YCrCb2RGBA_U8_1D) || defined(YCrCb2RGBA_U8_2D) || defined(SPIR)
uchar4 YCrCb2RGBACompute(const uchar3 src) {
  int y  = src.x;
  int cr = src.y - YCRCB_UCHAR_DELTA;
  int cb = src.z - YCRCB_UCHAR_DELTA;

  int4 value;
  value.x = y + divideUp(cr * kCr2RCoeff, kYCrCbShift);
  value.y = y + divideUp(cr * kY2GCrCoeff + cb * kY2GCbCoeff, kYCrCbShift);
  value.z = y + divideUp(cb * kCb2BCoeff, kYCrCbShift);
  value.w = 255.f;

  uchar4 dst = convert_uchar4_sat(value);

  return dst;
}
#endif

#if defined(YCrCb2RGBA_F32_1D) || defined(YCrCb2RGBA_F32_2D) || defined(SPIR)
float4 YCrCb2RGBACompute(const float3 src) {
  float y  = src.x;
  float cr = src.y - YCRCB_FLOAT_DELTA;
  float cb = src.z - YCRCB_FLOAT_DELTA;

  float4 dst;
  dst.x = y + cr * CR2R_FLOAT_COEFF;
  dst.y = y + cr * Y2G_CR_FLOAT_COEFF + cb * Y2G_CB_FLOAT_COEFF;
  dst.z = y + cb * CB2R_FLOAT_COEFF;
  dst.w = 1.0f;

  return dst;
}
#endif

#if defined(YCrCb2BGRA_U8_1D) || defined(SPIR)
Convert3To4_1D(YCrCb2BGRA, U8, uchar, uchar3, uchar4)
#endif

#if defined(YCrCb2BGRA_U8_2D) || defined(SPIR)
Convert3To4_2D(YCrCb2BGRA, U8, uchar, uchar3, uchar4)
#endif

#if defined(YCrCb2BGRA_F32_1D) || defined(SPIR)
Convert3To4_1D(YCrCb2BGRA, F32, float, float3, float4)
#endif

#if defined(YCrCb2BGRA_F32_2D) || defined(SPIR)
Convert3To4_2D(YCrCb2BGRA, F32, float, float3, float4)
#endif

#if defined(YCrCb2RGBA_U8_1D) || defined(SPIR)
Convert3To4_1D(YCrCb2RGBA, U8, uchar, uchar3, uchar4)
#endif

#if defined(YCrCb2RGBA_U8_2D) || defined(SPIR)
Convert3To4_2D(YCrCb2RGBA, U8, uchar, uchar3, uchar4)
#endif

#if defined(YCrCb2RGBA_F32_1D) || defined(SPIR)
Convert3To4_1D(YCrCb2RGBA, F32, float, float3, float4)
#endif

#if defined(YCrCb2RGBA_F32_2D) || defined(SPIR)
Convert3To4_2D(YCrCb2RGBA, F32, float, float3, float4)
#endif

/*********************** BGR/RGB/BGRA/RGBA <-> HSV ************************/

#if defined(BGR2HSV_U8_1D) || defined(BGR2HSV_U8_2D) || defined(SPIR)
uchar3 BGR2HSVCompute(const uchar3 src) {
  int h, v, s;
  v = max(max(src.x, src.y), src.z);
  s = min(min(src.x, src.y), src.z);
  uchar diff = convert_uchar_sat(v - s);
  if (v == 0) {
    s = 0;
  }
  else {
    s = (diff * ((255 << 12) / v) + (1 << 11)) >> 12;
  }

  if (diff == 0) {
    h = 0;
  }
  else {
    int value = convert_int_sat_rte((180 << 12) / (6.f * diff));
    if (v == src.z) {
      h = ((src.y - src.x) * value + (1 << 11)) >> 12;
    }
    if (v == src.y) {
      h = ((src.x - src.z + 2 * diff) * value + (1 << 11)) >> 12;
    }
    if (v == src.x) {
      h = ((src.z - src.y + 4 * diff) * value + (1 << 11)) >> 12;
    }
  }
  if (h < 0) {
    h += 180;
  }

  uchar3 dst = convert_uchar3_sat((int3)(h, s, v));

  return dst;
}
#endif

#if defined(BGR2HSV_F32_1D) || defined(BGR2HSV_F32_2D) || defined(SPIR)
float3 BGR2HSVCompute(const float3 src) {
  float diff;
  float3 dst;

  dst.z = max(max(src.z, src.y), src.x);
  diff = dst.z - min(min(src.z, src.y), src.x);
  dst.y = diff / (float)(dst.z + FLT_EPSILON);

  diff = (float)(60.0f / (diff + FLT_EPSILON));
  if (dst.z == src.z) {
    dst.x = (src.y - src.x) * diff;
  }
  if (dst.z == src.y) {
    dst.x = (src.x - src.z) * diff + 120.0f;
  }
  if (dst.z == src.x) {
    dst.x = (src.z - src.y) * diff + 240.0f;
  }
  if (dst.x < 0.0f) {
    dst.x += 360.0f;
  }

  return dst;
}
#endif

#if defined(RGB2HSV_U8_1D) || defined(RGB2HSV_U8_2D) || defined(SPIR)
uchar3 RGB2HSVCompute(const uchar3 src) {
  int h, v, s;
  v = max(max(src.z, src.y), src.x);
  s = min(min(src.z, src.y), src.x);
  uchar diff = convert_uchar_sat(v - s);
  if (v == 0) {
    s = 0;
  }
  else {
    s = (diff * ((255 << 12) / v) + (1 << 11)) >> 12;
  }

  if (diff == 0) {
    h = 0;
  }
  else {
    int value = convert_int_sat_rte((180 << 12) / (6.f * diff));
    if (v == src.x) {
      h = ((src.y - src.z) * value + (1 << 11)) >> 12;
    }
    if (v == src.y) {
      h = ((src.z - src.x + 2 * diff) * value + (1 << 11)) >> 12;
    }
    if (v == src.z) {
      h = ((src.x - src.y + 4 * diff) * value + (1 << 11)) >> 12;
    }
  }
  if (h < 0) {
    h += 180;
  }

  uchar3 dst = convert_uchar3_sat((int3)(h, s, v));

  return dst;
}
#endif

#if defined(RGB2HSV_F32_1D) || defined(RGB2HSV_F32_2D) || defined(SPIR)
float3 RGB2HSVCompute(const float3 src) {
  float diff;
  float3 dst;

  dst.z = max(max(src.x, src.y), src.z);
  diff = dst.z - min(min(src.x, src.y), src.z);
  dst.y = diff / (float)(dst.z + FLT_EPSILON);

  diff = (float)(60.0f / (diff + FLT_EPSILON));
  if (dst.z == src.x) {
    dst.x = (src.y - src.z) * diff;
  }
  if (dst.z == src.y) {
    dst.x = (src.z - src.x) * diff + 120.0f;
  }
  if (dst.z == src.z) {
    dst.x = (src.x - src.y) * diff + 240.0f;
  }
  if (dst.x < 0.0f) {
    dst.x += 360.0f;
  }

  return dst;
}
#endif

#if defined(BGR2HSV_U8_1D) || defined(SPIR)
Convert3To3_1D(BGR2HSV, U8, uchar, uchar3)
#endif

#if defined(BGR2HSV_U8_2D) || defined(SPIR)
Convert3To3_2D(BGR2HSV, U8, uchar, uchar3)
#endif

#if defined(BGR2HSV_F32_1D) || defined(SPIR)
Convert3To3_1D(BGR2HSV, F32, float, float3)
#endif

#if defined(BGR2HSV_F32_2D) || defined(SPIR)
Convert3To3_2D(BGR2HSV, F32, float, float3)
#endif

#if defined(RGB2HSV_U8_1D) || defined(SPIR)
Convert3To3_1D(RGB2HSV, U8, uchar, uchar3)
#endif

#if defined(RGB2HSV_U8_2D) || defined(SPIR)
Convert3To3_2D(RGB2HSV, U8, uchar, uchar3)
#endif

#if defined(RGB2HSV_F32_1D) || defined(SPIR)
Convert3To3_1D(RGB2HSV, F32, float, float3)
#endif

#if defined(RGB2HSV_F32_2D) || defined(SPIR)
Convert3To3_2D(RGB2HSV, F32, float, float3)
#endif


#if defined(BGRA2HSV_U8_1D) || defined(BGRA2HSV_U8_2D) || defined(SPIR)
uchar3 BGRA2HSVCompute(const uchar4 src) {
  int h, v, s;
  v = max(max(src.x, src.y), src.z);
  s = min(min(src.x, src.y), src.z);
  uchar diff = convert_uchar_sat(v - s);
  if (v == 0) {
    s = 0;
  }
  else {
    s = (diff * ((255 << 12) / v) + (1 << 11)) >> 12;
  }

  if (diff == 0) {
    h = 0;
  }
  else {
    int value = convert_int_sat_rte((180 << 12) / (6.f * diff));
    if (v == src.z) {
      h = ((src.y - src.x) * value + (1 << 11)) >> 12;
    }
    if (v == src.y) {
      h = ((src.x - src.z + 2 * diff) * value + (1 << 11)) >> 12;
    }
    if (v == src.x) {
      h = ((src.z - src.y + 4 * diff) * value + (1 << 11)) >> 12;
    }
  }
  if (h < 0) {
    h += 180;
  }

  uchar3 dst = convert_uchar3_sat((int3)(h, s, v));

  return dst;
}
#endif

#if defined(BGRA2HSV_F32_1D) || defined(BGRA2HSV_F32_2D) || defined(SPIR)
float3 BGRA2HSVCompute(const float4 src) {
  float diff;
  float3 dst;

  dst.z = max(max(src.z, src.y), src.x);
  diff = dst.z - min(min(src.z, src.y), src.x);
  dst.y = diff / (float)(dst.z + FLT_EPSILON);

  diff = (float)(60.0f / (diff + FLT_EPSILON));
  if (dst.z == src.z) {
    dst.x = (src.y - src.x) * diff;
  }
  if (dst.z == src.y) {
    dst.x = (src.x - src.z) * diff + 120.0f;
  }
  if (dst.z == src.x) {
    dst.x = (src.z - src.y) * diff + 240.0f;
  }
  if (dst.x < 0.0f) {
    dst.x += 360.0f;
  }

  return dst;
}
#endif

#if defined(RGBA2HSV_U8_1D) || defined(RGBA2HSV_U8_2D) || defined(SPIR)
uchar3 RGBA2HSVCompute(const uchar4 src) {
  int h, v, s;
  v = max(max(src.z, src.y), src.x);
  s = min(min(src.z, src.y), src.x);
  uchar diff = convert_uchar_sat(v - s);
  if (v == 0) {
    s = 0;
  }
  else {
    s = (diff * ((255 << 12) / v) + (1 << 11)) >> 12;
  }

  if (diff == 0) {
    h = 0;
  }
  else {
    int value = convert_int_sat_rte((180 << 12) / (6.f * diff));
    if (v == src.x) {
      h = ((src.y - src.z) * value + (1 << 11)) >> 12;
    }
    if (v == src.y) {
      h = ((src.z - src.x + 2 * diff) * value + (1 << 11)) >> 12;
    }
    if (v == src.z) {
      h = ((src.x - src.y + 4 * diff) * value + (1 << 11)) >> 12;
    }
  }
  if (h < 0) {
    h += 180;
  }

  uchar3 dst = convert_uchar3_sat((int3)(h, s, v));

  return dst;
}
#endif

#if defined(RGBA2HSV_F32_1D) || defined(RGBA2HSV_F32_2D) || defined(SPIR)
float3 RGBA2HSVCompute(const float4 src) {
  float diff;
  float3 dst;

  dst.z = max(max(src.x, src.y), src.z);
  diff = dst.z - min(min(src.x, src.y), src.z);
  dst.y = diff / (float)(dst.z + FLT_EPSILON);

  diff = (float)(60.0f / (diff + FLT_EPSILON));
  if (dst.z == src.x) {
    dst.x = (src.y - src.z) * diff;
  }
  if (dst.z == src.y) {
    dst.x = (src.z - src.x) * diff + 120.0f;
  }
  if (dst.z == src.z) {
    dst.x = (src.x - src.y) * diff + 240.0f;
  }
  if (dst.x < 0.0f) {
    dst.x += 360.0f;
  }

  return dst;
}
#endif

#if defined(BGRA2HSV_U8_1D) || defined(SPIR)
Convert4To3_1D(BGRA2HSV, U8, uchar, uchar4, uchar3)
#endif

#if defined(BGRA2HSV_U8_2D) || defined(SPIR)
Convert4To3_2D(BGRA2HSV, U8, uchar, uchar4, uchar3)
#endif

#if defined(BGRA2HSV_F32_1D) || defined(SPIR)
Convert4To3_1D(BGRA2HSV, F32, float, float4, float3)
#endif

#if defined(BGRA2HSV_F32_2D) || defined(SPIR)
Convert4To3_2D(BGRA2HSV, F32, float, float4, float3)
#endif

#if defined(RGBA2HSV_U8_1D) || defined(SPIR)
Convert4To3_1D(RGBA2HSV, U8, uchar, uchar4, uchar3)
#endif

#if defined(RGBA2HSV_U8_2D) || defined(SPIR)
Convert4To3_2D(RGBA2HSV, U8, uchar, uchar4, uchar3)
#endif

#if defined(RGBA2HSV_F32_1D) || defined(SPIR)
Convert4To3_1D(RGBA2HSV, F32, float, float4, float3)
#endif

#if defined(RGBA2HSV_F32_2D) || defined(SPIR)
Convert4To3_2D(RGBA2HSV, F32, float, float4, float3)
#endif


#if defined(HSV2BGR_U8_1D) || defined(HSV2BGR_U8_2D) || defined(SPIR)
uchar3 HSV2BGRCompute(const uchar3 src) {
  float h = src.x;
  float s = src.y;
  float v = src.z;

  float b, g, r;
  float hscale = 0.03333333f;  /* 6.f / 180; */
  float div_norm = 0.003921569f;  /* 1.0f / 255; */
  s *= div_norm;
  v *= div_norm;
  if (s == 0) {
    b = g = r = v;
  }
  else {
    h *= hscale;
    if (h < 0) {
      do {
        h += 6;
      } while (h < 0);
    }
    else if (h >= 6) {
      do {
        h -= 6;
      } while (h >= 6);
    }
    int sector = convert_int_rtn(h);
    h -= sector;
    if ((unsigned)sector >= 6u) {
      sector = 0;
      h = 0.f;
    }
    float x, y, z, w;
    x = v;
    y = v * (1.f - s);
    z = v * (1.f - s * h);
    w = v * (1.f - s * (1.f - h));
    if (sector == 0) {
      b = y;
      g = w;
      r = x;
    }
    else if (sector == 1) {
      b = y;
      g = x;
      r = z;
    }
    else if (sector == 2) {
      b = w;
      g = x;
      r = y;
    }
    else if (sector == 3) {
      b = x;
      g = z;
      r = y;
    }
    else if (sector == 4) {
      b = x;
      g = y;
      r = w;
    }
    else if (sector == 5) {
      b = z;
      g = y;
      r = x;
    }
  }
  b *= 255;
  g *= 255;
  r *= 255;

  uchar3 dst = convert_uchar3_sat_rte((float3)(b, g, r));

  return dst;
}
#endif

#if defined(HSV2BGR_F32_1D) || defined(HSV2BGR_F32_2D) || defined(SPIR)
float3 HSV2BGRCompute(const float3 src) {
  float _1_60 = 0.016666667f;  /* 1.f / 60.f; */
  float diff = src.y * src.z;
  float min = src.z - diff;
  float h = src.x * _1_60;

  float3 dst;
  dst.x = src.z;
  float value = diff * (h - 4);
  bool mask0 = h < 4;
  dst.z = mask0 ? min : (min + value);
  dst.y = mask0 ? (min - value) : min;

  value = diff * (h - 2);
  mask0 = h < 2;
  bool mask1 = h < 3;
  dst.y = mask1 ? src.z : dst.y;
  mask1 = ~mask0 & mask1;
  dst.x = mask0 ? min : dst.x;
  dst.x = mask1 ? (min + value) : dst.x;
  dst.z = mask0 ? (min - value) : dst.z;
  dst.z = mask1 ? min : dst.z;

  mask0 = h < 1;
  value = diff * h;
  dst.z = mask0 ? src.z : dst.z;
  dst.x = mask0 ? min : dst.x;
  dst.y = mask0 ? (min + value) : dst.y;

  mask0 = h >= 5;
  value = diff * (h - 6);
  dst.z = mask0 ? src.z : dst.z;
  dst.y = mask0 ? min : dst.y;
  dst.x = mask0 ? (min - value) : dst.x;

  return dst;
}
#endif

#if defined(HSV2RGB_U8_1D) || defined(HSV2RGB_U8_2D) || defined(SPIR)
uchar3 HSV2RGBCompute(const uchar3 src) {
  float h = src.x;
  float s = src.y;
  float v = src.z;

  float r, g, b;
  float hscale = 0.03333333f;  /* 6.f / 180; */
  float div_norm = 0.003921569f;  /* 1.0f / 255; */
  s *= div_norm;
  v *= div_norm;
  if (s == 0) {
    b = g = r = v;
  }
  else {
    h *= hscale;
    if (h < 0) {
      do {
        h += 6;
      } while (h < 0);
    }
    else if (h >= 6) {
      do {
        h -= 6;
      } while (h >= 6);
    }
    int sector = convert_int_rtn(h);
    h -= sector;
    if ((unsigned)sector >= 6u) {
      sector = 0;
      h = 0.f;
    }
    float x, y, z, w;
    x = v;
    y = v * (1.f - s);
    z = v * (1.f - s * h);
    w = v * (1.f - s * (1.f - h));
    if (sector == 0) {
      r = x;
      g = w;
      b = y;
    }
    else if (sector == 1) {
      r = z;
      g = x;
      b = y;
    }
    else if (sector == 2) {
      r = y;
      g = x;
      b = w;
    }
    else if (sector == 3) {
      r = y;
      g = z;
      b = x;
    }
    else if (sector == 4) {
      r = w;
      g = y;
      b = x;
    }
    else if (sector == 5) {
      r = x;
      g = y;
      b = z;
    }
  }
  r *= 255;
  g *= 255;
  b *= 255;

  uchar3 dst = convert_uchar3_sat_rte((float3)(r, g, b));

  return dst;
}
#endif

#if defined(HSV2RGB_F32_1D) || defined(HSV2RGB_F32_2D) || defined(SPIR)
float3 HSV2RGBCompute(const float3 src) {
  float _1_60 = 0.016666667f;  /* 1.f / 60.f; */
  float diff = src.y * src.z;
  float min = src.z - diff;
  float h = src.x * _1_60;

  float3 dst;
  dst.z = src.z;
  float value = diff * (h - 4);
  bool mask0 = h < 4;
  dst.x = mask0 ? min : (min + value);
  dst.y = mask0 ? (min - value) : min;

  value = diff * (h - 2);
  mask0 = h < 2;
  bool mask1 = h < 3;
  dst.y = mask1 ? src.z : dst.y;
  mask1 = ~mask0 & mask1;
  dst.z = mask0 ? min : dst.z;
  dst.z = mask1 ? (min + value) : dst.z;
  dst.x = mask0 ? (min - value) : dst.x;
  dst.x = mask1 ? min : dst.x;

  mask0 = h < 1;
  value = diff * h;
  dst.x = mask0 ? src.z : dst.x;
  dst.z = mask0 ? min : dst.z;
  dst.y = mask0 ? (min + value) : dst.y;

  mask0 = h >= 5;
  value = diff * (h - 6);
  dst.x = mask0 ? src.z : dst.x;
  dst.y = mask0 ? min : dst.y;
  dst.z = mask0 ? (min - value) : dst.z;

  return dst;
}
#endif

#if defined(HSV2BGR_U8_1D) || defined(SPIR)
Convert3To3_1D(HSV2BGR, U8, uchar, uchar3)
#endif

#if defined(HSV2BGR_U8_2D) || defined(SPIR)
Convert3To3_2D(HSV2BGR, U8, uchar, uchar3)
#endif

#if defined(HSV2BGR_F32_1D) || defined(SPIR)
Convert3To3_1D(HSV2BGR, F32, float, float3)
#endif

#if defined(HSV2BGR_F32_2D) || defined(SPIR)
Convert3To3_2D(HSV2BGR, F32, float, float3)
#endif

#if defined(HSV2RGB_U8_1D) || defined(SPIR)
Convert3To3_1D(HSV2RGB, U8, uchar, uchar3)
#endif

#if defined(HSV2RGB_U8_2D) || defined(SPIR)
Convert3To3_2D(HSV2RGB, U8, uchar, uchar3)
#endif

#if defined(HSV2RGB_F32_1D) || defined(SPIR)
Convert3To3_1D(HSV2RGB, F32, float, float3)
#endif

#if defined(HSV2RGB_F32_2D) || defined(SPIR)
Convert3To3_2D(HSV2RGB, F32, float, float3)
#endif


#if defined(HSV2BGRA_U8_1D) || defined(HSV2BGRA_U8_2D) || defined(SPIR)
uchar4 HSV2BGRACompute(const uchar3 src) {
  float h = src.x;
  float s = src.y;
  float v = src.z;

  float b, g, r;
  float hscale = 0.03333333f;  /* 6.f / 180; */
  float div_norm = 0.003921569f;  /* 1.0f / 255; */
  s *= div_norm;
  v *= div_norm;
  if (s == 0) {
    b = g = r = v;
  }
  else {
    h *= hscale;
    if (h < 0) {
      do {
        h += 6;
      } while (h < 0);
    }
    else if (h >= 6) {
      do {
        h -= 6;
      } while (h >= 6);
    }
    int sector = convert_int_rtn(h);
    h -= sector;
    if ((unsigned)sector >= 6u) {
      sector = 0;
      h = 0.f;
    }
    float x, y, z, w;
    x = v;
    y = v * (1.f - s);
    z = v * (1.f - s * h);
    w = v * (1.f - s * (1.f - h));
    if (sector == 0) {
      b = y;
      g = w;
      r = x;
    }
    else if (sector == 1) {
      b = y;
      g = x;
      r = z;
    }
    else if (sector == 2) {
      b = w;
      g = x;
      r = y;
    }
    else if (sector == 3) {
      b = x;
      g = z;
      r = y;
    }
    else if (sector == 4) {
      b = x;
      g = y;
      r = w;
    }
    else if (sector == 5) {
      b = z;
      g = y;
      r = x;
    }
  }
  b *= 255;
  g *= 255;
  r *= 255;

  uchar4 dst=convert_uchar4_sat_rte((float4)(b, g, r, 255.f));

  return dst;
}
#endif

#if defined(HSV2BGRA_F32_1D) || defined(HSV2BGRA_F32_2D) || defined(SPIR)
float4 HSV2BGRACompute(const float3 src) {
  float _1_60 = 0.016666667f;  /* 1.f / 60.f; */
  float diff = src.y * src.z;
  float min = src.z - diff;
  float h = src.x * _1_60;

  float4 dst;
  dst.x = src.z;
  float value = diff * (h - 4);
  bool mask0 = h < 4;
  dst.z = mask0 ? min : (min + value);
  dst.y = mask0 ? (min - value) : min;

  value = diff * (h - 2);
  mask0 = h < 2;
  bool mask1 = h < 3;
  dst.y = mask1 ? src.z : dst.y;
  mask1 = ~mask0 & mask1;
  dst.x = mask0 ? min : dst.x;
  dst.x = mask1 ? (min + value) : dst.x;
  dst.z = mask0 ? (min - value) : dst.z;
  dst.z = mask1 ? min : dst.z;

  mask0 = h < 1;
  value = diff * h;
  dst.z = mask0 ? src.z : dst.z;
  dst.x = mask0 ? min : dst.x;
  dst.y = mask0 ? (min + value) : dst.y;

  mask0 = h >= 5;
  value = diff * (h - 6);
  dst.z = mask0 ? src.z : dst.z;
  dst.y = mask0 ? min : dst.y;
  dst.x = mask0 ? (min - value) : dst.x;
  dst.w = 1.f;

  return dst;
}
#endif

#if defined(HSV2RGBA_U8_1D) || defined(HSV2RGBA_U8_2D) || defined(SPIR)
uchar4 HSV2RGBACompute(const uchar3 src) {
  float h = src.x;
  float s = src.y;
  float v = src.z;

  float r, g, b;
  float hscale = 0.03333333f;  /* 6.f / 180; */
  float div_norm = 0.003921569f;  /* 1.0f / 255; */
  s *= div_norm;
  v *= div_norm;
  if (s == 0) {
    b = g = r = v;
  }
  else {
    h *= hscale;
    if (h < 0) {
      do {
        h += 6;
      } while (h < 0);
    }
    else if (h >= 6) {
      do {
        h -= 6;
      } while (h >= 6);
    }
    int sector = convert_int_rtn(h);
    h -= sector;
    if ((unsigned)sector >= 6u) {
      sector = 0;
      h = 0.f;
    }
    float x, y, z, w;
    x = v;
    y = v * (1.f - s);
    z = v * (1.f - s * h);
    w = v * (1.f - s * (1.f - h));
    if (sector == 0) {
      r = x;
      g = w;
      b = y;
    }
    else if (sector == 1) {
      r = z;
      g = x;
      b = y;
    }
    else if (sector == 2) {
      r = y;
      g = x;
      b = w;
    }
    else if (sector == 3) {
      r = y;
      g = z;
      b = x;
    }
    else if (sector == 4) {
      r = w;
      g = y;
      b = x;
    }
    else if (sector == 5) {
      r = x;
      g = y;
      b = z;
    }
  }
  r *= 255;
  g *= 255;
  b *= 255;

  uchar4 dst=convert_uchar4_sat_rte((float4)(r, g, b, 255.f));

  return dst;
}
#endif

#if defined(HSV2RGBA_F32_1D) || defined(HSV2RGBA_F32_2D) || defined(SPIR)
float4 HSV2RGBACompute(const float3 src) {
  float _1_60 = 0.016666667f;  /* 1.f / 60.f; */
  float diff = src.y * src.z;
  float min = src.z - diff;
  float h = src.x * _1_60;

  float4 dst;
  dst.z = src.z;
  float value = diff * (h - 4);
  bool mask0 = h < 4;
  dst.x = mask0 ? min : (min + value);
  dst.y = mask0 ? (min - value) : min;

  value = diff * (h - 2);
  mask0 = h < 2;
  bool mask1 = h < 3;
  dst.y = mask1 ? src.z : dst.y;
  mask1 = ~mask0 & mask1;
  dst.z = mask0 ? min : dst.z;
  dst.z = mask1 ? (min + value) : dst.z;
  dst.x = mask0 ? (min - value) : dst.x;
  dst.x = mask1 ? min : dst.x;

  mask0 = h < 1;
  value = diff * h;
  dst.x = mask0 ? src.z : dst.x;
  dst.z = mask0 ? min : dst.z;
  dst.y = mask0 ? (min + value) : dst.y;

  mask0 = h >= 5;
  value = diff * (h - 6);
  dst.x = mask0 ? src.z : dst.x;
  dst.y = mask0 ? min : dst.y;
  dst.z = mask0 ? (min - value) : dst.z;
  dst.w = 1.f;

  return dst;
}
#endif

#if defined(HSV2BGRA_U8_1D) || defined(SPIR)
Convert3To4_1D(HSV2BGRA, U8, uchar, uchar3, uchar4)
#endif

#if defined(HSV2BGRA_U8_2D) || defined(SPIR)
Convert3To4_2D(HSV2BGRA, U8, uchar, uchar3, uchar4)
#endif

#if defined(HSV2BGRA_F32_1D) || defined(SPIR)
Convert3To4_1D(HSV2BGRA, F32, float, float3, float4)
#endif

#if defined(HSV2BGRA_F32_2D) || defined(SPIR)
Convert3To4_2D(HSV2BGRA, F32, float, float3, float4)
#endif

#if defined(HSV2RGBA_U8_1D) || defined(SPIR)
Convert3To4_1D(HSV2RGBA, U8, uchar, uchar3, uchar4)
#endif

#if defined(HSV2RGBA_U8_2D) || defined(SPIR)
Convert3To4_2D(HSV2RGBA, U8, uchar, uchar3, uchar4)
#endif

#if defined(HSV2RGBA_F32_1D) || defined(SPIR)
Convert3To4_1D(HSV2RGBA, F32, float, float3, float4)
#endif

#if defined(HSV2RGBA_F32_2D) || defined(SPIR)
Convert3To4_2D(HSV2RGBA, F32, float, float3, float4)
#endif


/*********************** BGR/RGB/BGRA/RGBA <-> LAB ************************/

enum LABShifts {
  kLabShift   = 12,
  kGammaShift = 3,
  kLabShift2  = (kLabShift + kGammaShift),
};

int gamma(float x) {
    float value = x > 0.04045f ? pow((x + 0.055f) / 1.055f, 2.4f) : x / 12.92f;
    return convert_int_rte(value * 2040);
}
int labCbrt_b(int i) {
  float x = i * (1.f / (255.f * (1 << kGammaShift)));
  float value = x < 0.008856f ? x * 7.787f + 0.13793103448275862f :
                pow(x,0.3333333333333f);

  return (1 << kLabShift2) * value;
}

#if defined(BGR2LAB_U8_1D) || defined(BGR2LAB_U8_2D) || defined(SPIR)
uchar3 BGR2LABCompute(const uchar3 src) {
  int Lscale = 296;  /* (116 * 255 + 50) / 100; */
  int Lshift = -1336935;  /* -((16 * 255 * (1 << kLabShift2) + 50) / 100); */

  int B = gamma(src.x / 255.f);
  int G = gamma(src.y / 255.f);
  int R = gamma(src.z / 255.f);

  int L = divideUp1(B * 778 + G * 1541 + R * 1777, kLabShift);
  int a = divideUp1(B * 296 + G * 2929 + R * 871, kLabShift);
  int b = divideUp1(B * 3575 + G * 448 + R * 73, kLabShift);

  int fX = labCbrt_b(L);
  int fY = labCbrt_b(a);
  int fZ = labCbrt_b(b);

  B = Lscale * fY + Lshift;
  G = 500 * (fX - fY) + 128 * (1 << kLabShift2);
  R = 200 * (fY - fZ) + 128 * (1 << kLabShift2);

  L = divideUp1(B, kLabShift2);
  a = divideUp1(G, kLabShift2);
  b = divideUp1(R, kLabShift2);

  uchar3 dst = convert_uchar3_sat((int3)(L, a, b));

  return dst;
}
#endif

#if defined(BGR2LAB_F32_1D) || defined(BGR2LAB_F32_2D) || defined(SPIR)
float3 BGR2LABCompute(float3 src) {
  float div_1_3     = 0.333333f;
  float div_16_116  = 0.137931f;

  src.x = (src.x > 0.04045f) ? pow((src.x + 0.055f) / 1.055f, 2.4f) :
           src.x / 12.92f;
  src.y = (src.y > 0.04045f) ? pow((src.y + 0.055f) / 1.055f, 2.4f) :
           src.y / 12.92f;
  src.z = (src.z > 0.04045f) ? pow((src.z + 0.055f) / 1.055f, 2.4f) :
           src.z / 12.92f;

  float3 dst;
  dst.x = src.x * 0.189828f + src.y * 0.376219f + src.z * 0.433953f;
  dst.y = src.x * 0.072169f + src.y * 0.715160f + src.z * 0.212671f;
  dst.z = src.x * 0.872766f + src.y * 0.109477f + src.z * 0.017758f;

  float pow_y = pow(dst.y, div_1_3);
  float FX = dst.x > 0.008856f ? pow(dst.x, div_1_3) : (7.787f * dst.x +
             div_16_116);
  float FY = dst.y > 0.008856f ? pow_y : (7.787f * dst.y + div_16_116);
  float FZ = dst.z > 0.008856f ? pow(dst.z, div_1_3) : (7.787f * dst.z +
             div_16_116);

  dst.x = dst.y > 0.008856f ? (116.f * pow_y - 16.f) : (903.3f * dst.y);
  dst.y = 500.f * (FX - FY);
  dst.z = 200.f * (FY - FZ);

  return dst;
}
#endif

#if defined(RGB2LAB_U8_1D) || defined(RGB2LAB_U8_2D) || defined(SPIR)
uchar3 RGB2LABCompute(const uchar3 src) {
  int Lscale = 296;  /* (116 * 255 + 50) / 100; */
  int Lshift = -1336935;  /* -((16 * 255 * (1 << kLabShift2) + 50) / 100); */

  int B = gamma(src.z / 255.f);
  int G = gamma(src.y / 255.f);
  int R = gamma(src.x / 255.f);

  int L = divideUp1(B * 778 + G * 1541 + R * 1777, kLabShift);
  int a = divideUp1(B * 296 + G * 2929 + R * 871, kLabShift);
  int b = divideUp1(B * 3575 + G * 448 + R * 73, kLabShift);

  int fX = labCbrt_b(L);
  int fY = labCbrt_b(a);
  int fZ = labCbrt_b(b);

  B = Lscale * fY + Lshift;
  G = 500 * (fX - fY) + 128 * (1 << kLabShift2);
  R = 200 * (fY - fZ) + 128 * (1 << kLabShift2);

  L = divideUp1(B, kLabShift2);
  a = divideUp1(G, kLabShift2);
  b = divideUp1(R, kLabShift2);

  uchar3 dst = convert_uchar3_sat((int3)(L, a, b));

  return dst;
}
#endif

#if defined(RGB2LAB_F32_1D) || defined(RGB2LAB_F32_2D) || defined(SPIR)
float3 RGB2LABCompute(float3 src) {
  float div_1_3     = 0.333333f;
  float div_16_116  = 0.137931f;

  src.x = (src.x > 0.04045f) ? pow((src.x + 0.055f) / 1.055f, 2.4f) :
           src.x / 12.92f;
  src.y = (src.y > 0.04045f) ? pow((src.y + 0.055f) / 1.055f, 2.4f) :
           src.y / 12.92f;
  src.z = (src.z > 0.04045f) ? pow((src.z + 0.055f) / 1.055f, 2.4f) :
           src.z / 12.92f;

  float3 dst;
  dst.x = src.z * 0.189828f + src.y * 0.376219f + src.x * 0.433953f;
  dst.y = src.z * 0.072169f + src.y * 0.715160f + src.x * 0.212671f;
  dst.z = src.z * 0.872766f + src.y * 0.109477f + src.x * 0.017758f;

  float pow_y = pow(dst.y, div_1_3);
  float FX = dst.x > 0.008856f ? pow(dst.x, div_1_3) : (7.787f * dst.x +
             div_16_116);
  float FY = dst.y > 0.008856f ? pow_y : (7.787f * dst.y + div_16_116);
  float FZ = dst.z > 0.008856f ? pow(dst.z, div_1_3) : (7.787f * dst.z +
             div_16_116);

  dst.x = dst.y > 0.008856f ? (116.f * pow_y - 16.f) : (903.3f * dst.y);
  dst.y = 500.f * (FX - FY);
  dst.z = 200.f * (FY - FZ);

  return dst;
}
#endif

#if defined(BGR2LAB_U8_1D) || defined(SPIR)
Convert3To3_1D(BGR2LAB, U8, uchar, uchar3)
#endif

#if defined(BGR2LAB_U8_2D) || defined(SPIR)
Convert3To3_2D(BGR2LAB, U8, uchar, uchar3)
#endif

#if defined(BGR2LAB_F32_1D) || defined(SPIR)
Convert3To3_1D(BGR2LAB, F32, float, float3)
#endif

#if defined(BGR2LAB_F32_2D) || defined(SPIR)
Convert3To3_2D(BGR2LAB, F32, float, float3)
#endif

#if defined(RGB2LAB_U8_1D) || defined(SPIR)
Convert3To3_1D(RGB2LAB, U8, uchar, uchar3)
#endif

#if defined(RGB2LAB_U8_2D) || defined(SPIR)
Convert3To3_2D(RGB2LAB, U8, uchar, uchar3)
#endif

#if defined(RGB2LAB_F32_1D) || defined(SPIR)
Convert3To3_1D(RGB2LAB, F32, float, float3)
#endif

#if defined(RGB2LAB_F32_2D) || defined(SPIR)
Convert3To3_2D(RGB2LAB, F32, float, float3)
#endif


#if defined(BGRA2LAB_U8_1D) || defined(BGRA2LAB_U8_2D) || defined(SPIR)
uchar3 BGRA2LABCompute(const uchar4 src) {
  int Lscale = 296;  /* (116 * 255 + 50) / 100; */
  int Lshift = -1336935;  /* -((16 * 255 * (1 << kLabShift2) + 50) / 100); */

  int B = gamma(src.x / 255.f);
  int G = gamma(src.y / 255.f);
  int R = gamma(src.z / 255.f);

  int L = divideUp1(B * 778 + G * 1541 + R * 1777, kLabShift);
  int a = divideUp1(B * 296 + G * 2929 + R * 871, kLabShift);
  int b = divideUp1(B * 3575 + G * 448 + R * 73, kLabShift);

  int fX = labCbrt_b(L);
  int fY = labCbrt_b(a);
  int fZ = labCbrt_b(b);

  B = Lscale * fY + Lshift;
  G = 500 * (fX - fY) + 128 * (1 << kLabShift2);
  R = 200 * (fY - fZ) + 128 * (1 << kLabShift2);

  L = divideUp1(B, kLabShift2);
  a = divideUp1(G, kLabShift2);
  b = divideUp1(R, kLabShift2);

  uchar3 dst = convert_uchar3_sat((int3)(L, a, b));

  return dst;
}
#endif

#if defined(BGRA2LAB_F32_1D) || defined(BGRA2LAB_F32_2D) || defined(SPIR)
float3 BGRA2LABCompute(float4 src) {
  float div_1_3     = 0.333333f;
  float div_16_116  = 0.137931f;

  src.x = (src.x > 0.04045f) ? pow((src.x + 0.055f) / 1.055f, 2.4f) :
           src.x / 12.92f;
  src.y = (src.y > 0.04045f) ? pow((src.y + 0.055f) / 1.055f, 2.4f) :
           src.y / 12.92f;
  src.z = (src.z > 0.04045f) ? pow((src.z + 0.055f) / 1.055f, 2.4f) :
           src.z / 12.92f;

  float3 dst;
  dst.x = src.x * 0.189828f + src.y * 0.376219f + src.z * 0.433953f;
  dst.y = src.x * 0.072169f + src.y * 0.715160f + src.z * 0.212671f;
  dst.z = src.x * 0.872766f + src.y * 0.109477f + src.z * 0.017758f;

  float pow_y = pow(dst.y, div_1_3);
  float FX = dst.x > 0.008856f ? pow(dst.x, div_1_3) : (7.787f * dst.x +
             div_16_116);
  float FY = dst.y > 0.008856f ? pow_y : (7.787f * dst.y + div_16_116);
  float FZ = dst.z > 0.008856f ? pow(dst.z, div_1_3) : (7.787f * dst.z +
             div_16_116);

  dst.x = dst.y > 0.008856f ? (116.f * pow_y - 16.f) : (903.3f * dst.y);
  dst.y = 500.f * (FX - FY);
  dst.z = 200.f * (FY - FZ);

  return dst;
}
#endif

#if defined(RGBA2LAB_U8_1D) || defined(RGBA2LAB_U8_2D) || defined(SPIR)
uchar3 RGBA2LABCompute(const uchar4 src) {
  int Lscale = 296;  /* (116 * 255 + 50) / 100; */
  int Lshift = -1336935;  /* -((16 * 255 * (1 << kLabShift2) + 50) / 100); */

  int B = gamma(src.z / 255.f);
  int G = gamma(src.y / 255.f);
  int R = gamma(src.x / 255.f);

  int L = divideUp1(B * 778 + G * 1541 + R * 1777, kLabShift);
  int a = divideUp1(B * 296 + G * 2929 + R * 871, kLabShift);
  int b = divideUp1(B * 3575 + G * 448 + R * 73, kLabShift);

  int fX = labCbrt_b(L);
  int fY = labCbrt_b(a);
  int fZ = labCbrt_b(b);

  B = Lscale * fY + Lshift;
  G = 500 * (fX - fY) + 128 * (1 << kLabShift2);
  R = 200 * (fY - fZ) + 128 * (1 << kLabShift2);

  L = divideUp1(B, kLabShift2);
  a = divideUp1(G, kLabShift2);
  b = divideUp1(R, kLabShift2);

  uchar3 dst = convert_uchar3_sat((int3)(L, a, b));

  return dst;
}
#endif

#if defined(RGBA2LAB_F32_1D) || defined(RGBA2LAB_F32_2D) || defined(SPIR)
float3 RGBA2LABCompute(float4 src) {
  float div_1_3     = 0.333333f;
  float div_16_116  = 0.137931f;

  src.x = (src.x > 0.04045f) ? pow((src.x + 0.055f) / 1.055f, 2.4f) :
           src.x / 12.92f;
  src.y = (src.y > 0.04045f) ? pow((src.y + 0.055f) / 1.055f, 2.4f) :
           src.y / 12.92f;
  src.z = (src.z > 0.04045f) ? pow((src.z + 0.055f) / 1.055f, 2.4f) :
           src.z / 12.92f;

  float3 dst;
  dst.x = src.z * 0.189828f + src.y * 0.376219f + src.x * 0.433953f;
  dst.y = src.z * 0.072169f + src.y * 0.715160f + src.x * 0.212671f;
  dst.z = src.z * 0.872766f + src.y * 0.109477f + src.x * 0.017758f;

  float pow_y = pow(dst.y, div_1_3);
  float FX = dst.x > 0.008856f ? pow(dst.x, div_1_3) : (7.787f * dst.x +
             div_16_116);
  float FY = dst.y > 0.008856f ? pow_y : (7.787f * dst.y + div_16_116);
  float FZ = dst.z > 0.008856f ? pow(dst.z, div_1_3) : (7.787f * dst.z +
             div_16_116);

  dst.x = dst.y > 0.008856f ? (116.f * pow_y - 16.f) : (903.3f * dst.y);
  dst.y = 500.f * (FX - FY);
  dst.z = 200.f * (FY - FZ);

  return dst;
}
#endif

#if defined(BGRA2LAB_U8_1D) || defined(SPIR)
Convert4To3_1D(BGRA2LAB, U8, uchar, uchar4, uchar3)
#endif

#if defined(BGRA2LAB_U8_2D) || defined(SPIR)
Convert4To3_2D(BGRA2LAB, U8, uchar, uchar4, uchar3)
#endif

#if defined(BGRA2LAB_F32_1D) || defined(SPIR)
Convert4To3_1D(BGRA2LAB, F32, float, float4, float3)
#endif

#if defined(BGRA2LAB_F32_2D) || defined(SPIR)
Convert4To3_2D(BGRA2LAB, F32, float, float4, float3)
#endif

#if defined(RGBA2LAB_U8_1D) || defined(SPIR)
Convert4To3_1D(RGBA2LAB, U8, uchar, uchar4, uchar3)
#endif

#if defined(RGBA2LAB_U8_2D) || defined(SPIR)
Convert4To3_2D(RGBA2LAB, U8, uchar, uchar4, uchar3)
#endif

#if defined(RGBA2LAB_F32_1D) || defined(SPIR)
Convert4To3_1D(RGBA2LAB, F32, float, float4, float3)
#endif

#if defined(RGBA2LAB_F32_2D) || defined(SPIR)
Convert4To3_2D(RGBA2LAB, F32, float, float4, float3)
#endif


#if defined(LAB2BGR_U8_1D) || defined(LAB2BGR_U8_2D) || defined(SPIR)
uchar3 LAB2BGRCompute(const uchar3 src) {
  float _16_116 = 0.137931034f;  // 16.0f / 116.0f;
  float lThresh = 7.9996248f;    // 0.008856f * 903.3f;
  float fThresh = 0.206892706f;  // 0.008856f * 7.787f + _16_116;

  float B = src.x * 0.392156863f;   // (100.f / 255.f);
  float G = src.y - 128;
  float R = src.z - 128;

  float Y, fy;

  if (B <= lThresh) {
    Y = B / 903.3f;
    fy = 7.787f * Y + _16_116;
  }
  else {
    fy = (B + 16.0f) / 116.0f;
    Y = fy * fy * fy;
  }

  float X = G / 500.0f + fy;
  float Z = fy - R / 200.0f;

  if (X <= fThresh) {
    X = (X - _16_116) / 7.787f;
  }
  else {
    X = X * X * X;
  }

  if (Z <= fThresh) {
    Z = (Z - _16_116) / 7.787f;
  }
  else {
    Z = Z * Z * Z;
  }

  B = 0.052891f * X - 0.204043f * Y + 1.151152f * Z;
  G = -0.921235f * X + 1.875991f * Y + 0.045244f * Z;
  R = 3.079933f * X - 1.537150f * Y - 0.542782f * Z;

  B = (B > 0.00304f) ? (1.055f * pow(B, 0.41667f) - 0.055f) : 12.92f * B;
  G = (G > 0.00304f) ? (1.055f * pow(G, 0.41667f) - 0.055f) : 12.92f * G;
  R = (R > 0.00304f) ? (1.055f * pow(R, 0.41667f) - 0.055f) : 12.92f * R;

  B = B * 255.f;
  G = G * 255.f;
  R = R * 255.f;

  uchar3 dst = convert_uchar3_sat_rte((float3)(B, G, R));

  return dst;
}
#endif

#if defined(LAB2BGR_F32_1D) || defined(LAB2BGR_F32_2D) || defined(SPIR)
float3 LAB2BGRCompute(const float3 src) {
  float _16_116 = 0.137931034f;  // 16.0f / 116.0f;
  float lThresh = 7.9996248f;    // 0.008856f * 903.3f;
  float fThresh = 0.206892706f;  // 0.008856f * 7.787f + _16_116;

  float Y, fy;

  if (src.x <= lThresh) {
    Y = src.x / 903.3f;
    fy = 7.787f * Y + _16_116;
  }
  else {
    fy = (src.x + 16.0f) / 116.0f;
    Y = fy * fy * fy;
  }

  float X = src.y / 500.0f + fy;
  float Z = fy - src.z / 200.0f;

  if (X <= fThresh) {
    X = (X - _16_116) / 7.787f;
  }
  else {
    X = X * X * X;
  }

  if (Z <= fThresh) {
    Z = (Z - _16_116) / 7.787f;
  }
  else {
    Z = Z * Z * Z;
  }

  float3 dst;
  dst.x = 0.052891f * X - 0.204043f * Y + 1.151152f * Z;
  dst.y = -0.921235f * X + 1.875991f * Y + 0.045244f * Z;
  dst.z = 3.079933f * X - 1.537150f * Y - 0.542782f * Z;

  dst.x = (dst.x > 0.00304f) ? (1.055f * pow(dst.x, 0.41667f) - 0.055f) :
          12.92f * dst.x;
  dst.y = (dst.y > 0.00304f) ? (1.055f * pow(dst.y, 0.41667f) - 0.055f) :
          12.92f * dst.y;
  dst.z = (dst.z > 0.00304f) ? (1.055f * pow(dst.z, 0.41667f) - 0.055f) :
          12.92f * dst.z;

  return dst;
}
#endif

#if defined(LAB2RGB_U8_1D) || defined(LAB2RGB_U8_2D) || defined(SPIR)
uchar3 LAB2RGBCompute(const uchar3 src) {
  float _16_116 = 0.137931034f;  // 16.0f / 116.0f;
  float lThresh = 7.9996248f;    // 0.008856f * 903.3f;
  float fThresh = 0.206892706f;  // 0.008856f * 7.787f + _16_116;

  float B = src.x * 0.392156863f;   // (100.f / 255.f);
  float G = src.y - 128;
  float R = src.z - 128;

  float Y, fy;

  if (B <= lThresh) {
    Y = B / 903.3f;
    fy = 7.787f * Y + _16_116;
  }
  else {
    fy = (B + 16.0f) / 116.0f;
    Y = fy * fy * fy;
  }

  float X = G / 500.0f + fy;
  float Z = fy - R / 200.0f;

  if (X <= fThresh) {
    X = (X - _16_116) / 7.787f;
  }
  else {
    X = X * X * X;
  }

  if (Z <= fThresh) {
    Z = (Z - _16_116) / 7.787f;
  }
  else {
    Z = Z * Z * Z;
  }

  B = 0.052891f * X - 0.204043f * Y + 1.151152f * Z;
  G = -0.921235f * X + 1.875991f * Y + 0.045244f * Z;
  R = 3.079933f * X - 1.537150f * Y - 0.542782f * Z;

  B = (B > 0.00304f) ? (1.055f * pow(B, 0.41667f) - 0.055f) : 12.92f * B;
  G = (G > 0.00304f) ? (1.055f * pow(G, 0.41667f) - 0.055f) : 12.92f * G;
  R = (R > 0.00304f) ? (1.055f * pow(R, 0.41667f) - 0.055f) : 12.92f * R;

  B = B * 255.f;
  G = G * 255.f;
  R = R * 255.f;

  uchar3 dst = convert_uchar3_sat_rte((float3)(R, G, B));

  return dst;
}
#endif

#if defined(LAB2RGB_F32_1D) || defined(LAB2RGB_F32_2D) || defined(SPIR)
float3 LAB2RGBCompute(const float3 src) {
  float _16_116 = 0.137931034f;  // 16.0f / 116.0f;
  float lThresh = 7.9996248f;    // 0.008856f * 903.3f;
  float fThresh = 0.206892706f;  // 0.008856f * 7.787f + _16_116;

  float Y, fy;

  if (src.x <= lThresh) {
    Y = src.x / 903.3f;
    fy = 7.787f * Y + _16_116;
  }
  else {
    fy = (src.x + 16.0f) / 116.0f;
    Y = fy * fy * fy;
  }

  float X = src.y / 500.0f + fy;
  float Z = fy - src.z / 200.0f;

  if (X <= fThresh) {
    X = (X - _16_116) / 7.787f;
  }
  else {
    X = X * X * X;
  }

  if (Z <= fThresh) {
    Z = (Z - _16_116) / 7.787f;
  }
  else {
    Z = Z * Z * Z;
  }

  float3 dst;
  dst.x = 3.079933f * X - 1.537150f * Y - 0.542782f * Z;
  dst.y = -0.921235f * X + 1.875991f * Y + 0.045244f * Z;
  dst.z = 0.052891f * X - 0.204043f * Y + 1.151152f * Z;

  dst.x = (dst.x > 0.00304f) ? (1.055f * pow(dst.x, 0.41667f) - 0.055f) :
          12.92f * dst.x;
  dst.y = (dst.y > 0.00304f) ? (1.055f * pow(dst.y, 0.41667f) - 0.055f) :
          12.92f * dst.y;
  dst.z = (dst.z > 0.00304f) ? (1.055f * pow(dst.z, 0.41667f) - 0.055f) :
          12.92f * dst.z;

  return dst;
}
#endif

#if defined(LAB2BGR_U8_1D) || defined(SPIR)
Convert3To3_1D(LAB2BGR, U8, uchar, uchar3)
#endif

#if defined(LAB2BGR_U8_2D) || defined(SPIR)
Convert3To3_2D(LAB2BGR, U8, uchar, uchar3)
#endif

#if defined(LAB2BGR_F32_1D) || defined(SPIR)
Convert3To3_1D(LAB2BGR, F32, float, float3)
#endif

#if defined(LAB2BGR_F32_2D) || defined(SPIR)
Convert3To3_2D(LAB2BGR, F32, float, float3)
#endif

#if defined(LAB2RGB_U8_1D) || defined(SPIR)
Convert3To3_1D(LAB2RGB, U8, uchar, uchar3)
#endif

#if defined(LAB2RGB_U8_2D) || defined(SPIR)
Convert3To3_2D(LAB2RGB, U8, uchar, uchar3)
#endif

#if defined(LAB2RGB_F32_1D) || defined(SPIR)
Convert3To3_1D(LAB2RGB, F32, float, float3)
#endif

#if defined(LAB2RGB_F32_2D) || defined(SPIR)
Convert3To3_2D(LAB2RGB, F32, float, float3)
#endif


#if defined(LAB2BGRA_U8_1D) || defined(LAB2BGRA_U8_2D) || defined(SPIR)
uchar4 LAB2BGRACompute(const uchar3 src) {
  float _16_116 = 0.137931034f;  // 16.0f / 116.0f;
  float lThresh = 7.9996248f;    // 0.008856f * 903.3f;
  float fThresh = 0.206892706f;  // 0.008856f * 7.787f + _16_116;

  float B = src.x * 0.392156863f;   // (100.f / 255.f);
  float G = src.y - 128;
  float R = src.z - 128;

  float Y, fy;

  if (B <= lThresh) {
    Y = B / 903.3f;
    fy = 7.787f * Y + _16_116;
  }
  else {
    fy = (B + 16.0f) / 116.0f;
    Y = fy * fy * fy;
  }

  float X = G / 500.0f + fy;
  float Z = fy - R / 200.0f;

  if (X <= fThresh) {
    X = (X - _16_116) / 7.787f;
  }
  else {
    X = X * X * X;
  }

  if (Z <= fThresh) {
    Z = (Z - _16_116) / 7.787f;
  }
  else {
    Z = Z * Z * Z;
  }

  B = 0.052891f * X - 0.204043f * Y + 1.151152f * Z;
  G = -0.921235f * X + 1.875991f * Y + 0.045244f * Z;
  R = 3.079933f * X - 1.537150f * Y - 0.542782f * Z;

  B = (B > 0.00304f) ? (1.055f * pow(B, 0.41667f) - 0.055f) : 12.92f * B;
  G = (G > 0.00304f) ? (1.055f * pow(G, 0.41667f) - 0.055f) : 12.92f * G;
  R = (R > 0.00304f) ? (1.055f * pow(R, 0.41667f) - 0.055f) : 12.92f * R;

  B = B * 255.f;
  G = G * 255.f;
  R = R * 255.f;

  uchar4 dst=convert_uchar4_sat_rte((float4)(B, G, R, 255.f));

  return dst;
}
#endif

#if defined(LAB2BGRA_F32_1D) || defined(LAB2BGRA_F32_2D) || defined(SPIR)
float4 LAB2BGRACompute(const float3 src) {
  float _16_116 = 0.137931034f;  // 16.0f / 116.0f;
  float lThresh = 7.9996248f;    // 0.008856f * 903.3f;
  float fThresh = 0.206892706f;  // 0.008856f * 7.787f + _16_116;

  float Y, fy;

  if (src.x <= lThresh) {
    Y = src.x / 903.3f;
    fy = 7.787f * Y + _16_116;
  }
  else {
    fy = (src.x + 16.0f) / 116.0f;
    Y = fy * fy * fy;
  }

  float X = src.y / 500.0f + fy;
  float Z = fy - src.z / 200.0f;

  if (X <= fThresh) {
    X = (X - _16_116) / 7.787f;
  }
  else {
    X = X * X * X;
  }

  if (Z <= fThresh) {
    Z = (Z - _16_116) / 7.787f;
  }
  else {
    Z = Z * Z * Z;
  }

  float4 dst;
  dst.x = 0.052891f * X - 0.204043f * Y + 1.151152f * Z;
  dst.y = -0.921235f * X + 1.875991f * Y + 0.045244f * Z;
  dst.z = 3.079933f * X - 1.537150f * Y - 0.542782f * Z;

  dst.x = (dst.x > 0.00304f) ? (1.055f * pow(dst.x, 0.41667f) - 0.055f) :
          12.92f * dst.x;
  dst.y = (dst.y > 0.00304f) ? (1.055f * pow(dst.y, 0.41667f) - 0.055f) :
          12.92f * dst.y;
  dst.z = (dst.z > 0.00304f) ? (1.055f * pow(dst.z, 0.41667f) - 0.055f) :
          12.92f * dst.z;
  dst.w = 1.f;

  return dst;
}
#endif

#if defined(LAB2RGBA_U8_1D) || defined(LAB2RGBA_U8_2D) || defined(SPIR)
uchar4 LAB2RGBACompute(const uchar3 src) {
  float _16_116 = 0.137931034f;  // 16.0f / 116.0f;
  float lThresh = 7.9996248f;    // 0.008856f * 903.3f;
  float fThresh = 0.206892706f;  // 0.008856f * 7.787f + _16_116;

  float B = src.x * 0.392156863f;   // (100.f / 255.f);
  float G = src.y - 128;
  float R = src.z - 128;

  float Y, fy;

  if (B <= lThresh) {
    Y = B / 903.3f;
    fy = 7.787f * Y + _16_116;
  }
  else {
    fy = (B + 16.0f) / 116.0f;
    Y = fy * fy * fy;
  }

  float X = G / 500.0f + fy;
  float Z = fy - R / 200.0f;

  if (X <= fThresh) {
    X = (X - _16_116) / 7.787f;
  }
  else {
    X = X * X * X;
  }

  if (Z <= fThresh) {
    Z = (Z - _16_116) / 7.787f;
  }
  else {
    Z = Z * Z * Z;
  }

  B = 0.052891f * X - 0.204043f * Y + 1.151152f * Z;
  G = -0.921235f * X + 1.875991f * Y + 0.045244f * Z;
  R = 3.079933f * X - 1.537150f * Y - 0.542782f * Z;

  B = (B > 0.00304f) ? (1.055f * pow(B, 0.41667f) - 0.055f) : 12.92f * B;
  G = (G > 0.00304f) ? (1.055f * pow(G, 0.41667f) - 0.055f) : 12.92f * G;
  R = (R > 0.00304f) ? (1.055f * pow(R, 0.41667f) - 0.055f) : 12.92f * R;

  B = B * 255.f;
  G = G * 255.f;
  R = R * 255.f;

  uchar4 dst=convert_uchar4_sat_rte((float4)(R, G, B, 255.f));

  return dst;
}
#endif

#if defined(LAB2RGBA_F32_1D) || defined(LAB2RGBA_F32_2D) || defined(SPIR)
float4 LAB2RGBACompute(const float3 src) {
  float _16_116 = 0.137931034f;  // 16.0f / 116.0f;
  float lThresh = 7.9996248f;    // 0.008856f * 903.3f;
  float fThresh = 0.206892706f;  // 0.008856f * 7.787f + _16_116;

  float Y, fy;

  if (src.x <= lThresh) {
    Y = src.x / 903.3f;
    fy = 7.787f * Y + _16_116;
  }
  else {
    fy = (src.x + 16.0f) / 116.0f;
    Y = fy * fy * fy;
  }

  float X = src.y / 500.0f + fy;
  float Z = fy - src.z / 200.0f;

  if (X <= fThresh) {
    X = (X - _16_116) / 7.787f;
  }
  else {
    X = X * X * X;
  }

  if (Z <= fThresh) {
    Z = (Z - _16_116) / 7.787f;
  }
  else {
    Z = Z * Z * Z;
  }

  float4 dst;
  dst.x = 3.079933f * X - 1.537150f * Y - 0.542782f * Z;
  dst.y = -0.921235f * X + 1.875991f * Y + 0.045244f * Z;
  dst.z = 0.052891f * X - 0.204043f * Y + 1.151152f * Z;

  dst.x = (dst.x > 0.00304f) ? (1.055f * pow(dst.x, 0.41667f) - 0.055f) :
          12.92f * dst.x;
  dst.y = (dst.y > 0.00304f) ? (1.055f * pow(dst.y, 0.41667f) - 0.055f) :
          12.92f * dst.y;
  dst.z = (dst.z > 0.00304f) ? (1.055f * pow(dst.z, 0.41667f) - 0.055f) :
          12.92f * dst.z;
  dst.w = 1.f;

  return dst;
}
#endif

#if defined(LAB2BGRA_U8_1D) || defined(SPIR)
Convert3To4_1D(LAB2BGRA, U8, uchar, uchar3, uchar4)
#endif

#if defined(LAB2BGRA_U8_2D) || defined(SPIR)
Convert3To4_2D(LAB2BGRA, U8, uchar, uchar3, uchar4)
#endif

#if defined(LAB2BGRA_F32_1D) || defined(SPIR)
Convert3To4_1D(LAB2BGRA, F32, float, float3, float4)
#endif

#if defined(LAB2BGRA_F32_2D) || defined(SPIR)
Convert3To4_2D(LAB2BGRA, F32, float, float3, float4)
#endif

#if defined(LAB2RGBA_U8_1D) || defined(SPIR)
Convert3To4_1D(LAB2RGBA, U8, uchar, uchar3, uchar4)
#endif

#if defined(LAB2RGBA_U8_2D) || defined(SPIR)
Convert3To4_2D(LAB2RGBA, U8, uchar, uchar3, uchar4)
#endif

#if defined(LAB2RGBA_F32_1D) || defined(SPIR)
Convert3To4_1D(LAB2RGBA, F32, float, float3, float4)
#endif

#if defined(LAB2RGBA_F32_2D) || defined(SPIR)
Convert3To4_2D(LAB2RGBA, F32, float, float3, float4)
#endif
