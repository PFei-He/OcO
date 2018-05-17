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

package top.faylib.oco.plugins;

import android.util.Log;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.List;

public class DevicePlugin extends CordovaPlugin {

    //region Variable

    // 调试模式
    private boolean debugMode = false;

    //endregion


    //region Private Methods

    // 打印调试信息
    private void debugLog(String ... strings) {
        if (debugMode) {
            for (String string : strings) {
                Log.i("OcO", "[ OcO ][ DEVICE ][ DEBUG ] " + string);
            }
        }
    }

    //endregion


    //region Cordova Plugin Methods (JavaScript -> Java)

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {

        // Web 调用 -> 调试模式开关
        if (action.equals("debug_mode")) {
            debugMode = args.getBoolean(0);
            debugLog("debug_mode run", "Debug Mode Open");

            return true;
        }

        // Web 调用 -> 获取设备系统
        else if (action.equals("device_system")) {
            callbackContext.success("Android");
            send(PluginResult.Status.OK, 2, false, callbackContext);
            debugLog("device_system run");

            return true;
        }

        return super.execute(action, args, callbackContext);
    }

    //endregion


    //region Cordova Plugin Methods (Java -> JavaScript)

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
    private void send(PluginResult.Status status, Object message, boolean keepCallback, CallbackContext callbackContext) {
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
        pluginResult.setKeepCallback(keepCallback);
        callbackContext.sendPluginResult(pluginResult);
    }

    //endregion
}
