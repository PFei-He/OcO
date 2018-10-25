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

// 应用接口
var Application = 'Application'

// 定义方法名
var Method = {
  debugMode: 'debug_mode',
  load: 'load_information',
  changeLanguage: 'change_language'
}

// endregion

// region Private Variable

// 应用语言
var currentLanguage = ''

// 应用版本
var currentVersion = ''

// endregion

/* eslint-disable no-undef */
export default {
  // region Public Methods

  /**
   * 应用语言
   * @returns {string}
   */
  currentLanguage () {
    return currentLanguage
  },

  /**
   * 应用版本
   * @returns {string}
   */
  currentVersion () {
    return currentVersion
  },

  // endregion

  // region Cordova Plugin Methods (Web -> Native)

  /**
   * 调试模式
   * @param openOrNot 是否打开
   */
  debugMode (openOrNot) {
    cordova.exec(null, null, Application, Method.debugMode, [openOrNot])
  },

  /**
   * 加载应用信息
   * @param callback 回调
   */
  load (callback) {
    cordova.exec(function (info) {
      currentLanguage = info.currentLanguage
      currentVersion = info.currentVersion
      callback()
    }, null, Application, Method.load, [])
  },

  /**
   * 更改语言环境
   * @param language 语言
   */
  changeLanguage (language) {
    currentLanguage = language
    cordova.exec(null, null, Application, Method.changeLanguage, [language])
  }

  // endregion

  // region Cordova Plugin Methods (Native -> Web)
  // endregion
}
