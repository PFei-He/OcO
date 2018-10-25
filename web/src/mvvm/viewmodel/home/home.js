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

import NavigationBar from '../../../component/NavigationBar.vue'
import Device from '../../../vendor/plugin/device'

export default {
  // region Variable

  components: {NavigationBar}, // 添加导航栏
  name: 'home',

  // endregion

  // region View Life Cycle

  mounted () { // 页面挂载后
    // 显示 TabBar
    this.$parent.tabBarHidden = false
    if (Device.system() === Device.ios) {
      this.$refs.content.style.marginTop = '64px'
    }
  },

  destroyed () { // 页面销毁后
    // 隐藏 TabBar
    this.$parent.tabBarHidden = true
  },

  // endregion

  // region Vue Methods

  data () { // 页面数据
    return {
      msg: 'Welcome to Your Vue.js App'
    }
  },

  // endregion

  // region Custom Methods

  methods: {
    pushNext () { // 按钮 `next` 的点击事件
      this.$router.push({ // 下一页
        name: 'today' // 跳转到路径 `/today` ，则进入 `Today.vue`
      })
    }
  }

  // endregion
}
