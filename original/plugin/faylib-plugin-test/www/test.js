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

var test = exports;
var exec = require('cordova/exec');

test.debugMode = function(openOrNot) {

	/**
	* 发送 'debug_mode' 消息（Web 端与移动端通信的方法）
	*/
	exec(null, null, 'Test', 'debug_mode', [openOrNot]);
};

test.testMethod = function(arguments, successCallback, failureCallback) {

	/**
	* 发送 'test_method' 消息（Web 端与移动端通信的方法）
    *
	* successCallback: 移动端响应 '成功' 时执行的方法
	* failureCallback: 移动端响应 '失败' 时执行的方法
	* 'Test': 移动端用于接收消息的类的标识码
	* 'test_method': 移动端接收消息并响应的方法名
	* arguments: 传递到移动端的参数，数组类型
	*/
	exec(successCallback, failureCallback, 'Test', 'test_method', arguments);
};
