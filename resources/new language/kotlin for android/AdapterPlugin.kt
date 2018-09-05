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

package top.faylib.oco.plugins

import android.util.Log

import org.apache.cordova.CallbackContext
import org.apache.cordova.CordovaPlugin
import org.apache.cordova.PluginResult
import org.json.JSONArray
import org.json.JSONObject

class AdapterPlugin : CordovaPlugin() {

    //region Variable

    // 调试模式
    private var debugMode = false

    //endregion


    //region Private Methods

    // 打印调试信息
    private fun debugLog(vararg strings: String) {
        if (debugMode) {
            for (string in strings) {
                Log.i("OcO", "[ OcO ][ NETWORK ]$string.")
            }
        }
    }

    //endregion


    //region Cordova Plugin Methods (Web -> Native)

    override fun execute(action: String?, args: JSONArray?, callbackContext: CallbackContext?): Boolean {

        // Web 调用 -> 调试模式开关
        if ("debug_mode" == action) {
            debugMode = args!![0] as Boolean
            debugLog("[ FUNCTION ] '$action' run", " Debug Mode Open")
            return true
        }

        // Web 调用 -> 关闭 Web 页面
        else if ("dismiss_web" == action) {
            cordova.activity.finish()
            webDismissed()
            debugLog("[ FUNCTION ] '$action' run")
            return true
        }

        return super.execute(action, args, callbackContext)
    }

    //endregion


    //region Cordova Plugin Methods (Native -> Web)

    // Android 调用 -> Web 页面已关闭
    private fun webDismissed() {
        cordova.activity.runOnUiThread { webView.loadUrl("javascript:web_dismissed()") }
    }

    //endregion


    //region CordovaPlugin Methods

    /**
     * 发送到 Web 的回调
     *
     * @param status 响应状态
     * @param message 回调参数
     * @param keepCallback 保持回调持续可用
     * @param callbackContext 回调信息
     */
    private fun send(status: PluginResult.Status, message: Any, keepCallback: Boolean, callbackContext: CallbackContext) {
        var pluginResult: PluginResult? = null
        when (message) {
            is String -> pluginResult = PluginResult(status, message)
            is JSONArray -> pluginResult = PluginResult(status, message)
            is JSONObject -> pluginResult = PluginResult(status, message)
            is Int -> pluginResult = PluginResult(status, message)
            is Float -> pluginResult = PluginResult(status, message)
        }
        pluginResult!!.keepCallback = keepCallback
        callbackContext.sendPluginResult(pluginResult)
    }

    //endregion
}
