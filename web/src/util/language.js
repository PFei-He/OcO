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

import Application from '../plugin/application'
import Localization from '../file/localization.json'

/* eslint-disable no-unused-vars */

/**
 * 中文-大陆
 * @returns {boolean}
 */
function zhCN () {
  return Application.currentLanguage() === 'zh_CN'
}

/**
 * 中文-香港
 * @returns {boolean}
 */
function zhHK () {
  return Application.currentLanguage() === 'zh_HK'
}

/**
 * 英文
 * @returns {boolean}
 */
function en () {
  return Application.currentLanguage() === 'en'
}

export default {
  /**
   * 转换为当地语言版本
   * @param textArray 需要转换的文字数组
   * @returns {*} 转换后的文字
   */
  convert (textArray) {
    if (textArray.length === 1) {
      if (typeof textArray[0] === 'string') {
        for (var key in Localization) {
          if (key === textArray[0]) {
            if (Localization.hasOwnProperty(key)) {
              return zhCN() ? Localization[key]['zh_CN'] : zhHK() ? Localization[key]['zh_HK'] : Localization[key]['en']
            }
          }
        }
        return name
      } else {
        if (zhCN()) {
          return textArray[0]['zh_CN']
        } else if (zhHK()) {
          return textArray[0]['zh_HK']
        } else if (en()) {
          return textArray[0]['en']
        }
      }
    } else {
      if (zhCN()) {
        return textArray[0]
      } else if (zhHK()) {
        return textArray[1]
      } else if (en()) {
        return textArray[2]
      }
    }
  }
}
