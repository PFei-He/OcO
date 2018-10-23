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

// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.

import Vue from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import Device from './vendor/plugin/device'
import Network from './vendor/plugin/network'
import Application from './plugin/application'
import Language from './util/language'
import Debug from './util/debug'

Vue.config.productionTip = false

/* eslint-disable no-new */

// document.addEventListener('DOMContentLoaded', function () { // 页面的 DOM 内容加载完成后即触发,而无需等待其他资源（CSS、JS）的加载
// }, false)

// window.addEventListener('load', function () { // 其他资源加载完成后触发
// }, false)

window.document.addEventListener('deviceready', function () { // 监听设备状态，准备好时加载WebApp
  // 打开调试模式
  Debug.debugMode(true)

  // 设置超时时隔
  Network.timeoutInterval(60000)
  // 设置重试次数
  Network.retryTimes(1)

  // 加载设备信息
  Device.load(function () {
    // 加载应用信息
    Application.load(function () {
      // 创建过滤器
      // p.s. 转换为当地语言版本的文字，可传入单字符串，多字符串，对象
      Vue.filter('localize', function () {
        if (!arguments) return ''
        return Language.convert(arguments)
      })

      // 新建Vue实例
      new Vue({
        el: '#app',
        router, // 添加路由
        store, // 添加数据存储
        template: '<App/>',
        components: {App}
      })
    })
  })
}, false)
