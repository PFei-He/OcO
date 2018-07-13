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

<template>
  <div class="home">
    <navigation-bar>Hybrid</navigation-bar>
    <h1>{{ msg }}</h1>
    <button id="next" @click="pushNext">Next Page</button>
  </div>
</template>

<script>
  import NavigationBar from '../../component/NavigationBar'
  export default {
    components: {NavigationBar}, // 添加导航栏
    name: 'home',
    methods: {
      pushNext () { // 按钮 `next` 的点击事件
        this.$router.push({ // 下一页
          name: 'today' // 跳转到路径 `/today` ，则进入 `Today.vue`
        })
      }
    },
    data () { // 页面数据
      return {
        msg: 'Welcome to Your Vue.js App'
      }
    },
    mounted () { // 页面挂载后
      // 显示TabBar
      this.$parent.tabBarHidden = false
    },
    destroyed () { // 页面销毁后
      // 隐藏TabBar
      this.$parent.tabBarHidden = true
    }
  }
</script>

<style>
  .home { /* 背景样式 */
    background-color: white;
  }

  h1 {
    font-weight: normal;
    color: #2f3f4f;
  }

  #next {

  }
</style>
