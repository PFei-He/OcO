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
  <div>
    <!-- 使用路由 -->
    <router-view v-if="isRouterAlive"></router-view>

    <tab-bar v-model="tab" v-show="!tabBarHidden">
      <tab-bar-item id="home" isRoute>
        <img src="./assets/image/ic_tab_home_normal.png" slot="tab-bar-item-icon-normal">
        <img src="./assets/image/ic_tab_home_active.png" slot="tab-bar-item-icon-active">
        {{'首页', '首頁', 'Home' | localize}}
      </tab-bar-item>

      <tab-bar-item id="search" isRoute>
        <img src="./assets/image/ic_tab_group_normal.png" slot="tab-bar-item-icon-normal">
        <img src="./assets/image/ic_tab_group_active.png" slot="tab-bar-item-icon-active">
        {{'搜索', '搜索', 'Search' | localize}}
      </tab-bar-item>

      <tab-bar-item id="mine" isRoute>
        <img src="./assets/image/ic_tab_profile_normal.png" slot="tab-bar-item-icon-normal">
        <img src="./assets/image/ic_tab_profile_active.png" slot="tab-bar-item-icon-active">
        {{{'zh_CN': '我的', 'zh_HK': '我的', 'en': 'Mine'} | localize}}
      </tab-bar-item>
    </tab-bar>
  </div>
</template>

<script>
  import TabBar from './component/TabBar'
  import TabBarItem from './component/TabBarItem'

  export default {
    // region Variable

    components: { TabBarItem, TabBar },
    name: 'app',
    props: { // 动态绑定TabBar是否隐藏的属性，默认隐藏
      tabBarHidden: {
        type: Boolean,
        default: true
      }
    },

    // endregion

    // region Vue Methods

    provide () { // 将刷新页面方法传递到子组件
      return {
        reload: this.reload
      }
    },

    data () {
      return {
        tab: 'home',
        isRouterAlive: true
      }
    },

    // endregion

    // region Custom Methods

    methods: {
      reload () { // 刷新页面
        this.isRouterAlive = false
        this.$nextTick(() => (this.isRouterAlive = true))
      }
    }

    // endregion
  }
</script>

<style>
  /**
    name {标签选择器 => <name>
      ...
    }

    .name {类选择器 => <div class="name"></div>
      ...
    }

    #name {控件选择器 => <div id="name"></div>
      ...
    }
   */

  body {
    margin: 0;
  }
</style>

/* 引用外部文件 (.js) 作为本文件的 script */
<!--<script src=".."></script>-->

/* 引用外部文件 (.css/.scss/...) 作为本文件的 style */
/* 这样写的css文件中的样式只能在本组件中使用，而不会影响其他组件 */
<!--<style src=".."></style>-->
/* 这样写的话import的css文件会被编译为全局样式，但是引入less等预编译文件，就会局部生效 */
<!--<style>@import "..";</style>-->
<!--<style>@import url("..");</style>-->
