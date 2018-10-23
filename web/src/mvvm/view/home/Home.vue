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

<template>
  <div class="home">
    <navigation-bar>{{'appName' | localize}}</navigation-bar>
    <h1>{{ msg }}</h1>
    <button id="next" @click="pushNext">{{'nextPage' | localize}}</button>
  </div>
</template>

<script>
  import NavigationBar from '../../../component/NavigationBar'

  export default {
    // region Variable

    components: { NavigationBar }, // 添加导航栏
    name: 'home',

    // endregion

    // region View Life Cycle

    mounted () { // 页面挂载后
      // 显示 TabBar
      this.$parent.tabBarHidden = false
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
</script>

<style>
  .home { /* 背景样式 */
    background-color: white;
    position: fixed;
    width: 100%;
  }

  h1 {
    font-weight: normal;
    color: #4f5f6f;
    margin-left: 5px;
    margin-right: 5px;
  }

  #next {
    background-color: #4f5f6f;
    color: #9b9b9b;
    height: 30px;
    width: 80px;
    margin-left: 5px;
    font-size: 15px;
    padding: 0;
  }
</style>
