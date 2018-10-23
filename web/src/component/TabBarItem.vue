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
  <a class="tab-bar-item" :class="{'is-active':isActive}" @click="toRoute">

    <!-- 普通状态图片 -->
    <span class="tab-bar-item-icon" v-show="!isActive"><slot name="tab-bar-item-icon-normal"></slot></span>

    <!-- 选择状态图片 -->
    <span class="tab-bar-item-icon" v-show="isActive"><slot name="tab-bar-item-icon-active"></slot></span>

    <!-- 文字 -->
    <span class="tab-bar-item-text"><slot></slot></span>
  </a>
</template>

<script>
  export default {
    // region Variable

    name: 'TabBarItem',
    props: {
      id: {
        type: String
      },
      isRoute: {
        type: Boolean,
        default: false
      }
    },

    // endregion

    // region Computed Properties

    computed: {
      isActive () {
        if (this.$parent.value === this.id) {
          return true
        }
      }
    },

    // endregion

    // region Custom Methods

    methods: {
      toRoute () {
        this.$parent.$emit('input', this.id)
        if (this.isRoute) {
          this.$router.push(this.id)
        }
      }
    }

    // endregion
  }
</script>

<style lang="less">
  .tab-bar-item {
    flex: 1;
    text-align: center;

    .tab-bar-item-icon {
      display: block;
      padding-top: 2px;

      img {
        width: 28px;
        height: 28px;
      }
    }

    .tab-bar-item-text {
      display: block;
      font-size: 10px;
      color: #949494;
    }

    &.is-active {
      .tab-bar-item-text {
        color: #2f3f4f;
      }
    }
  }
</style>
