/**
 *
 * Copyright (c) 2018 saturn.xyz
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

/* eslint-disable no-undef */
export default {
  // region Cordova Plugin Methods (JavaScript -> Java / Objective-C)
  /**
   * 调试模式
   * @param openOrNot 是否打开
   */
  debugMode (openOrNot) {
    cordova.exec(null, null, 'Network', 'debug_mode', [openOrNot])
  },
  /**
   * 发送网络请求
   * @param method 请求方法
   * @param url 请求接口
   * @param params 请求参数
   * @param successCallback 请求成功回调
   * @param errorCallback 请求失败回调
   */
  sendWithMethod (method, url, params, successCallback, errorCallback) {
    switch (method) {
      case 'GET':
        cordova.exec(successCallback, errorCallback, 'Network', 'request_get', [url, params, 60000, 1])
        break
      case 'POST':
        cordova.exec(successCallback, errorCallback, 'Network', 'request_post', [url, params, 60, 1])
        break
      case 'POST_FILE':
        cordova.exec(successCallback, errorCallback, 'Network', 'request_post_file', [url, params, 60, 1])
        break
      case 'DELETE':
        cordova.exec(successCallback, errorCallback, 'Network', 'request_delete', [url, params, 60, 1])
        break
    }
  }
  // endregion
  // region Cordova Plugin Methods (Java / Objective-C -> JavaScript)
  // endregion
}
