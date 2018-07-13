/**
 *
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
 *
 */

import Vue from 'vue'
import Router from 'vue-router'

import Home from '../view/home/home.vue'
import Today from '../view/home/today.vue'

import Search from '../view/search/search.vue'

import Mine from '../view/mine/mine.vue'

// 路由则为界面跳转的流程图
// `Vue` 使用路由 `Route`
Vue.use(Router)

export default new Router({ // 导出路由表
  routes: [
    {
      path: '/', // 设置 `Home.vue` 为根路径，路由会自动寻找该路径，并设置为首页，如不设置，则会设置 `App.vue` 为根路径
      name: 'home', // 设置模板名称
      component: Home // 导入 `Home` 组件
    },
    {
      path: '/home', // 设置 `Home.vue` 的路径
      name: 'home', // 设置模板名称
      component: Home // 导入 `Home` 组件
    },
    {
      path: '/today', // 设置 `Today.vue` 的路径
      name: 'today',  // 设置模板名称
      component: Today // 导入 `Today` 组件
    },
    {
      path: '/search', // 设置 `Search.vue` 的路径
      name: 'search', // 设置模板名称
      component: Search // 导入 `Search` 组件
    },
    {
      path: '/mine', // 设置 `Mine.vue` 的路径
      name: 'mine', // 设置模板名称
      component: Mine // 导入 `Mine` 组件
    }
  ]
})
