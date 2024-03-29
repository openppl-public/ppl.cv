// Licensed to the Apache Software Foundation (ASF) under one
// or more contributor license agreements.  See the NOTICE file
// distributed with this work for additional information
// regarding copyright ownership.  The ASF licenses this file
// to you under the Apache License, Version 2.0 (the
// "License"); you may not use this file except in compliance
// with the License.  You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

#ifndef __ST_HPC_PPL_CV_AARCH64_INTEGRAL_H_
#define __ST_HPC_PPL_CV_AARCH64_INTEGRAL_H_

#include "ppl/common/retcode.h"

namespace ppl {
namespace cv {
namespace arm {

/**
 * @brief Calculates the Integral of an image.
 * @tparam T The data type of input image, currently only \a float are supported.
 * @tparam channels The number of channels of input image, 1, 3 and 4 are supported.
 * @param inHeight          input image's height
 * @param inWidth           input image's width need to be processed
 * @param inWidthStride     input image's width stride, usually it equals to `width * channels`
 * @param in                input image data
 * @param outHeight         output image's height
 * @param outWidth          output image's width need to be processed
 * @param outWidthStride    the width stride of output image, usually it equals to `width * channels`
 * @param out               output image data
 * @warning All input parameters must be valid, or undefined behaviour may occur.
 * @note 1 There are 2 implementation, in version 1 the input&output have the 
 *         same size; in version 2 outHeight = inHeight + 1 && outWidth = 
 *         inWidth + 1. Version 2 is compatible with integral() in OpenCV 4.1.
 * @remark The fllowing table show which data type and channels are supported.
 * <table>
 * <tr><th>TSrc type<th>TDst type<th>channels
 * <tr><td>float<td>float<td>1
 * <tr><td>float<td>float<td>3
 * <tr><td>float<td>float<td>4
 * <tr><td>uint8_t<td>int32_t<td>1
 * <tr><td>uint8_t<td>int32_t<td>3
 * <tr><td>uint8_t<td>int32_t<td>4
 * </table>
 * <table>
 * <caption align="left">Requirements</caption>
 * <tr><td>arm platforms supported<td> All
 * <tr><td>Header files<td> #include &lt;ppl/cv/arm/integral.h&gt;
 * <tr><td>Project<td> ppl.cv
 * @since ppl.cv-v1.0.0
 * ###Example 1 (input size equal to output size)
 * @code{.cpp}
 * #include <ppl/cv/arm/integral.h>
 * int32_t main(int32_t argc, char** argv) {
 *     const int32_t W = 640;
 *     const int32_t H = 480;
 *     const int32_t C = 3;
 *     float* dev_iImage = (float*)malloc(W * H * C * sizeof(float));
 *     float* dev_oImage = (float*)malloc(W * H * C * sizeof(float));
 *
 *     ppl::cv::arm::Integral<float, float, 3>(H, W, W * C, dev_iImage, H, W, W * C, dev_oImage);
 *
 *     free(dev_iImage);
 *     free(dev_oImage);
 *     return 0;
 * }
 * @endcode
 * ###Example 2 (opencv mode)
 * @code{.cpp}
 * #include <ppl/cv/arm/integral.h>
 * int32_t main(int32_t argc, char** argv) {
 *     const int32_t inW = 640;
 *     const int32_t inH = 480;
 *     const int32_t outW = outW + 1;
 *     const int32_t outH = outH + 1;
 *     const int32_t C = 3;
 *     float* dev_iImage = (float*)malloc(inW * inH * C * sizeof(float));
 *     float* dev_oImage = (float*)malloc(outW * outH * C * sizeof(float));
 *
 *     ppl::cv::arm::Integral<float, float, 3>(inH, inW, inW * C, dev_iImage, outH, outW, outW * C, dev_oImage);
 *
 *     free(dev_iImage);
 *     free(dev_oImage);
 *     return 0;
 * }
 * @endcode
 ***************************************************************************************************/

template <typename TSrc, typename TDst, int32_t channels>
::ppl::common::RetCode Integral(
    int32_t inHeight,
    int32_t inWidth,
    int32_t inWidthStride,
    const TSrc *inData,
    int32_t outHeight,
    int32_t outWidth,
    int32_t outWidthStride,
    TDst *outData);

}
}
} // namespace ppl::cv::arm
#endif //! __ST_HPC_PPL_CV_AARCH64_INTEGRAL_H_
