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
  <div class="navigation-bar" ref="navigationBar">
    <!-- 左边区域 -->
    <span class="navigation-bar-left" v-on:click="leftItemEvent" v-if="showLiftItem">
        <slot name="navigation-bar-left-item"></slot>
      </span>

    <!-- 标题 -->
    <span class="navigation-bar-title">
        <slot></slot>
      </span>

    <!-- 右边区域 -->
    <span class="navigation-bar-right" v-on:click="rightItemEvent" v-if="showRightItem">
        <slot name="navigation-bar-right-item"></slot>
      </span>
  </div>
</template>

<script>
  import device from '../vendor/plugin/device'

  export default {
    // region Variable

    name: 'NavigationBar',
    props: {
      showLiftItem: {
        type: Boolean,
        default: true
      },
      showRightItem: {
        type: Boolean,
        default: true
      },
      align: {
        type: String,
        default: 'center'
      }
    },

    // endregion

    // region View Life Cycle

    mounted () {
      if (device.system() === 'ios') {
        this.$refs.navigationBar.style.paddingTop = '20px'
      }
    },

    // endregion

    // region Custom Methods

    methods: {
      // 按钮 `back` 的点击事件
      leftItemEvent () {
        this.$router.back() // 上一页
      },

      rightItemEvent () {
      }
    }

    // endregion
  }
</script>

<style lang="less">
  .navigation-bar {
    height: 44px;
    line-height: 44px;
    background-color: #4f5f6f;
    color: #9b9b9b;

    .navigation-bar-left {
      float: left;
      height: 44px;
      width: 33%;
    }

    .navigation-bar-title {
      height: 44px;
      float: left;
      width: 34%;
      text-align: center;
    }

    .navigation-bar-right {
      float: right;
      height: 44px;
      width: 33%;
    }
  }
</style>
