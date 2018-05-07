/**
*
* Copyright (c) 2018 saturn.xyz
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
  <div class="navigation-bar">

    <!-- 左边按钮 -->
    <span class="navigation-bar-left" v-on:click="leftItemEvent" v-if="showLiftItem">
        <slot name="navigation-bar-left-item"></slot>
      </span>

    <!-- 标题 -->
    <span class="navigation-bar-title">
        <slot></slot>
      </span>

    <!-- 右边按钮 -->
    <span class="navigation-bar-right" v-on:click="rightItemEvent" v-if="showRightItem">
        <slot name="navigation-bar-right-item"></slot>
      </span>
  </div>
</template>

<script>
  import device from '../plugins/device'
  export default {
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
    methods: {
      leftItemEvent () { // 按钮 `back` 的点击事件
        this.$router.back() // 上一页
      },
      rightItemEvent () {
      }
    },
    beforeCreate: function () {
      device.system(function (device) {
        if (device === 'iOS') {
          var div = document.getElementsByClassName('navigation-bar')
          div[0].setAttribute('style', 'height:64px; line-height:84px;')
          div = document.getElementsByClassName('navigation-bar-left')
          div[0].setAttribute('style', 'margin-top:25px;')
          div = document.getElementsByClassName('navigation-bar-right')
          div[0].setAttribute('style', 'margin-top:25px;')
        }
      })
    }
  }
</script>

<style lang="less">
  .navigation-bar {
    width: auto;
    height: 44px;
    text-align: center;
    line-height: 44px;
    background-color: #4f5f6f;
    color: #9b9b9b;
    margin: 0;

    .navigation-bar-left {
      float: left;
      margin-left: 20px;
      margin-top: 5px;
      height: 34px;
    }

    .navigation-bar-right {
      float: right;
      margin-right: 30px;
      margin-top: 5px;
      height: 34px;
    }
  }
</style>
