/**
 * Copyright (c) 2018 faylib.top
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
 */

// region Macro Definition

// 网络接口
var Network = 'Network'

// 定义方法名
var Method = {
  debugMode: 'debug_mode',
  timeoutInterval: 'timeout_interval',
  retryTimes: 'retry_times',
  setHeaders: 'set_headers',
  requestGet: 'request_get',
  requestPost: 'request_post',
  requestDelete: 'request_delete',
  resetRequest: 'reset_request'
}

// endregion

/* eslint-disable no-undef */
export default {
  // region Cordova Plugin Methods (Web -> Native)

  /**
   * 调试模式
   * @param openOrNot 是否打开
   */
  debugMode (openOrNot) {
    cordova.exec(null, null, Network, Method.debugMode, [openOrNot])
  },

  /**
   * 设置超时时隔
   * @param millisecond 时隔（毫秒）
   */
  timeoutInterval (millisecond) {
    cordova.exec(null, null, Network, Method.timeoutInterval, [millisecond])
  },

  /**
   * 设置重试次数
   * @param count 次数
   */
  retryTimes (count) {
    cordova.exec(null, null, Network, Method.retryTimes, [count])
  },

  /**
   * 设置请求头
   * @param headers 请求头参数
   */
  setHeaders (headers) {
    cordova.exec(null, null, Network, Method.setHeaders, [headers])
  },

  /**
   * 发送 GET 请求
   * @param url 请求接口
   * @param params 请求参数
   * @param successCallback 请求成功回调
   * @param errorCallback 请求失败回调
   */
  GET (url, params, successCallback, errorCallback) {
    cordova.exec(successCallback, errorCallback, Network, Method.requestGet, [url, params])
  },

  /**
   * 发送 POST 请求
   * @param url 请求接口
   * @param params 请求参数
   * @param successCallback 请求成功回调
   * @param errorCallback 请求失败回调
   */
  POST (url, params, successCallback, errorCallback) {
    cordova.exec(successCallback, errorCallback, Network, Method.requestPost, [url, params])
  },

  /**
   * 发送 DELETE 请求
   * @param url 请求接口
   * @param params 请求参数
   * @param successCallback 请求成功回调
   * @param errorCallback 请求失败回调
   */
  DELETE (url, params, successCallback, errorCallback) {
    cordova.exec(successCallback, errorCallback, Network, Method.requestDelete, [url, params])
  },

  /**
   * 发送 download 请求
   * @param url 请求接口
   * @param filePath 文件保存路径
   * @param successCallback 请求成功回调
   * @param errorCallback 请求失败回调
   */
  download (url, filePath, successCallback, errorCallback) {
    cordova.exec(successCallback, errorCallback, Network, Method.requestDownload, [url, filePath])
  },

  /**
   * 重置请求
   */
  reset () {
    cordova.exec(null, null, Network, Method.resetRequest, [])
  }

  // endregion

  // region Cordova Plugin Methods (Native -> Web)
  // endregion
}
