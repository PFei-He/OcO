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

var network = (function() {

    /* Private Member Variables */

    var n = {};

    // 网络框架
    var Network = 'Network';

    // 调试模式
    var debugMode = false;

    // 超时时隔
    var timeoutInterval = 120000;

    // 重试次数
    var retryTimes = 1;


    /* Public Member Variables */

    // 服务器返回数据的类型，网络框架为 `AJAX` 时使用，默认为 `json` 类型
    n.dataType = 'json';

    // 是否使用 Native 端的请求
    n.native = true;


    /* Private Methods */

    // 打印调试信息
    function debugLog() {
        if (debugMode) {
            for (var i in arguments) {
                console.log("[ OcO ][ NETWORK ]" + arguments[i] + ".");
            }
        }
    }

    // 发送请求
    function request(method, url, params, retryTimes, successCallback, errorCallback) {

        debugLog("[ REQUEST ] Start sending", "[ URL ] " + url, "[ METHOD ] " + method, "[ PARAMS ] " + JSON.stringify(params), "[ RETRY TIMES ] " + retryTimes, "[ TIMEOUT INTERVAL ] " + timeoutInterval/1000);

        retryTimes--;

        $.ajax({
            data: params,
            dataType: n.dataType,
            method: method,
            timeout: timeoutInterval,
            url: url,

            // xhr: XMLHTTPRequest
            // 回调成功
            success: function (xhr, status, result) {
                if (typeof xhr == 'object') {
                    debugLog("[ REQUEST ] Success", "[ URL ] " + url);
                    successCallback({'statusCode': result.status, 'result': xhr});
                } else {
                    debugLog("[ REQUEST ] Success but not JSON data", "[ URL ] " + url);
                    errorCallback({'statusCode': result.status, 'result': xhr});
                }
            },

            // 回调失败
            error: function (xhr, status, error) {
                if (retryTimes < 1) {
                    debugLog("[ REQUEST ] Failure", "[ URL ] " + url);
                    errorCallback({'statusCode': error.status, 'result': xhr});
                } else {
                    request(method, url, params, retryTimes, successCallback, errorCallback);
                }
            }
        });
    }


    /* Public Methods */

    /**
     * 调试模式开关
     * @param openOrNot 是否打开
     */
    n.debugMode = function (openOrNot) {
        if (n.native) {
            cordova.exec(null, null, Network, 'debug_mode', [openOrNot]);
        } else {
            debugMode = openOrNot;
            debugLog("[ FUNCTION ] 'debugMode' run", " Debug Mode Open");
        }
    }

    /**
     * 设置超时时隔
     * @param millisecond 时隔（毫秒）
     */
    n.timeoutInterval = function (millisecond) {
        if (n.native) {
            cordova.exec(null, null, Network, 'timeout_interval', [sec]);
        } else {
            debugLog("[ FUNCTION ] 'timeoutInterval' run");
            timeoutInterval = sec;
        }
    }

    /**
     * 设置重试次数
     * @param count 次数
     */
    n.retryTimes = function (count) {
        if (n.native) {
            cordova.exec(null, null, Network, 'retry_times', [count]);
        } else {
            debugLog("[ FUNCTION ] 'retryTimes' run");
            retryTimes = count;
        }
    }

    /**
     * 发送GET请求
     * @param url 请求地址
     * @param params 请求参数
     * @param successCallback 请求成功回调
     * @param errorCallback 请求失败回调
     */
    n.GET = function (url, params, successCallback, errorCallback) {
        if (n.native) {
            cordova.exec(successCallback, errorCallback, Network, 'request_get', [url, params]);
        } else {
            debugLog("[ FUNCTION ] 'GET' run");
            request('GET', url, params, retryTimes, successCallback, errorCallback);
        }
    }

    /**
     * 发送POST请求
     * @param url 请求地址
     * @param params 请求参数
     * @param successCallback 请求成功回调
     * @param errorCallback 请求失败回调
     */
    n.POST = function (url, params, successCallback, errorCallback) {
        if (n.native) {
            cordova.exec(successCallback, errorCallback, Network, 'request_post', [url, params]);
        } else {
            debugLog("[ FUNCTION ] 'POST' run");
            request('POST', url, params, retryTimes, successCallback, errorCallback);
        }
    }

    /**
     * 发送DELETE请求
     * @param url 请求地址
     * @param params 请求参数
     * @param successCallback 请求成功回调
     * @param errorCallback 请求失败回调
     */
    n.DELETE = function (url, params, successCallback, errorCallback) {
        if (n.native) {
            cordova.exec(successCallback, errorCallback, Network, 'request_delete', [url, params]);
        } else {
            debugLog("[ FUNCTION ] 'DELETE' run");
            request('DELETE', url, params, retryTimes, successCallback, errorCallback);
        }
    }

    /**
     * 重置请求
     */
    n.reset = function () {
        if (n.native) {
            cordova.exec(null, null, Network, 'reset_request', [])
        } else {
            debugLog("[ FUNCTION ] 'reset' run");
            timeoutInterval = 120000;
            retryTimes = 1;
        }
    }

    return n;
})();
