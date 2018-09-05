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

package top.faylib.test;

import android.util.Log;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class TestPlugin extends CordovaPlugin {

	//region Variable

    // 调试模式
    private boolean debugMode = false;

    //endregion


    //region Private Methods

    // 打印调试信息
    private void debugLog(String ... strings) {
        if (debugMode) {
            for (String string : strings) {
                Log.i("FAYLIB", "[ FAYLIB ][ DEBUG ] " + string);
            }
        }
    }

    //endregion


    //region Cordova Plugin Methods (JavaScript -> Java)

    /**
    * 接收 Web 端消息的方法
    *
    * action: 消息名
    * args: Web 端传递来的参数
    * callbackContext: 与 Web 端通信的响应对象
    */
    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {

        // 接收 Web 端发送来的 'debug_mode' 消息并作出响应
        if (action.equals("debug_mode")) {
            debugMode = args.getBoolean(0);

            debugLog("debug_mode run", "Debug Mode Open");

            return true;
        }

        // 接收 Web 端发送来的 'test_method' 消息并作出响应
        else if ("test_method".equals(action)) {

            // 获取 Web 端传递来的参数
            String param = args.getString(0);

            // 响应成功的结果并回调到 Web 端
            callbackContext.success("SUCCESS");

            // 响应失败的结果并回调到 Web 端
            callbackContext.error("ERROR");

            return true;
        }

        return super.execute(action, args, callbackContext);
    }

    //endregion


    //region Cordova Plugin Methods (Java -> JavaScript)

    //endregion


    //region CordovaPlugin Methods

    private void send(PluginResult.Status status, Object message, boolean keepCallback, CallbackContext callbackContext) {

        // 响应结果
        PluginResult pluginResult = null;
        if (message instanceof String) {
            pluginResult = new PluginResult(status, (String) message);
        } else if (message instanceof JSONArray) {
            pluginResult = new PluginResult(status, (JSONArray) message);
        } else if (message instanceof JSONObject) {
            pluginResult = new PluginResult(status, (JSONObject) message);
        } else if (message instanceof Integer) {
            pluginResult = new PluginResult(status, (int) message);
        } else if (message instanceof Float) {
            pluginResult = new PluginResult(status, (float) message);
        }
        assert pluginResult != null;

        // 保持响应
        pluginResult.setKeepCallback(keepCallback);

        // 发送响应结果
        callbackContext.sendPluginResult(pluginResult);
    }

    //endregion
}
