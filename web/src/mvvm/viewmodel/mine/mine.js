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
//  import Debug from '../../../util/debug'

export default {
  // region Variable

  components: {NavigationBar}, // 添加导航栏
  name: 'mine',

  // endregion

  // region View Life Cycle

  mounted () { // 页面挂载后
    // 显示TabBar
    this.$parent.tabBarHidden = false
    if (Device.system() === Device.ios) {
      this.$refs.content.style.marginTop = '64px'
    }
  },

  destroyed () { // 页面销毁后
    // 隐藏TabBar
    this.$parent.tabBarHidden = true
  },

  // endregion

  // region Vue Methods

  data () {
    return {
      rows: ['account', 'region']
    }
  },

  // endregion

  // region Custom Methods

  methods: {
    pushNext (view) {
      this.$router.push({name: view})
    }
  }

  // endregion
}
