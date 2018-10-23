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

// 设备接口
var Device = 'Device'

// 定义方法名
var Method = {
  debugMode: 'debug_mode',
  load: 'load_information',
  freeSize: 'free_size',
  storeSize: 'store_size'
}

// endregion

// region Private Variable

// 设备架构
var deviceArchitecture = ''

// 设备号
var deviceId = ''

// 系统
var deviceSystem = ''

// 版本
var deviceVersion = ''

// endregion

/* eslint-disable no-undef */
export default {
  // region Public Methods

  /**
   * 设备架构
   * @returns {string}
   */
  architecture () {
    return deviceArchitecture
  },

  /**
   * 设备号
   * @returns {string}
   */
  id () {
    return deviceId
  },

  /**
   * 设备系统
   * @returns {string}
   */
  system () {
    return deviceSystem
  },

  /**
   * 设备版本
   * @returns {string}
   */
  version () {
    return deviceVersion
  },

  // endregion

  // region Cordova Plugin Methods (Web -> Native)

  /**
   * 调试模式
   * @param openOrNot 是否打开
   */
  debugMode (openOrNot) {
    cordova.exec(null, null, Device, Method.debugMode, [openOrNot])
  },

  /**
   * 加载设备信息
   * @param callback 回调
   */
  load (callback) {
    cordova.exec(function (info) {
      deviceArchitecture = info.deviceArchitecture
      deviceId = info.deviceId
      deviceSystem = info.deviceSystem
      deviceVersion = info.deviceVersion
      callback()
    }, null, Device, Method.load, [])
  },

  /**
   * 剩余存储空间
   * @param callback 回调
   */
  freeSize (callback) {
    cordova.exec(function (size) {
      callback(size)
    }, null, Device, Method.freeSize, [])
  },

  /**
   * 总存储空间
   * @param callback 回调
   */
  storeSize (callback) {
    cordova.exec(function (size) {
      callback(size)
    }, null, Device, Method.storeSize, [])
  }

  // endregion

  // region Cordova Plugin Methods (Native -> Web)
  // endregion
}
