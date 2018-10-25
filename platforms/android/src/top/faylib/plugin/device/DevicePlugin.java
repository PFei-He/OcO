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

package top.faylib.plugin.device;

import android.os.Environment;
import android.os.StatFs;
import android.util.Log;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;

public class DevicePlugin extends CordovaPlugin {
    //region Constant

    // 定义方法名
    private static final String DEBUG_MODE = "debug_mode";
    private static final String LOAD = "load_information";
    private static final String FREE_SIZE = "free_size";
    private static final String STORE_SIZE = "store_size";

    //endregion


    //region Variable

    // 调试模式
    private boolean debugMode = false;

    //endregion


    //region Private Methods

    // 打印调试信息
    private void debugLog(String ... strings) {
        if (debugMode) {
            for (String string : strings) {
                Log.i("OcO", "[ OcO ][ DEVICE ]" + string + ".");
            }
        }
    }

    /**
     * 获取手机内部空间总大小
     * @return 大小，字节为单位
     */
    static private long getTotalInternalMemorySize() {

        //获取内部存储根目录
        File path = Environment.getDataDirectory();

        //系统的空间描述类
        StatFs stat = new StatFs(path.getPath());

        //每个区块占字节数
        long blockSize = stat.getBlockSize();

        //区块总数
        long totalBlocks = stat.getBlockCount();

        return totalBlocks * blockSize;
    }

    /**
     * 获取手机内部可用空间大小
     * @return 大小，字节为单位
     */
    static private long getAvailableInternalMemorySize() {

        //获取内部存储根目录
        File path = Environment.getDataDirectory();

        //系统的空间描述类
        StatFs stat = new StatFs(path.getPath());

        //每个区块占字节数
        long blockSize = stat.getBlockSize();

        //获取可用区块数量
        long availableBlocks = stat.getAvailableBlocks();

        return availableBlocks * blockSize;
    }

    //endregion


    //region Cordova Plugin Methods (Web -> Native)

    /**
     * 执行 Web 端发送来的请求
     * @param action          The action to execute.
     * @param args            The exec() arguments.
     * @param callbackContext The callback context used when calling back into JavaScript.
     * @return 是否执行成功
     * @throws JSONException 解析异常
     */
    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {

        // Web 调用 -> 调试模式开关
        if (DEBUG_MODE.equals(action)) {
            cordova.getThreadPool().execute(() -> {
                try {
                    debugMode = args.getBoolean(0);
                    debugLog("[ FUNCTION ] '" + action + "' run", " Debug Mode Open");
                } catch (JSONException e) { e.printStackTrace(); }
            });
            return true;
        }

        // Web 调用 -> 加载设备信息
        else if (LOAD.equals(action)) {
            cordova.getThreadPool().execute(() -> {
                debugLog("[ FUNCTION ] '" + action + "' run");
                JSONObject jsonObject = new JSONObject();
                try {
                    jsonObject.put("deviceArchitecture", android.os.Build.CPU_ABI);
                    jsonObject.put("deviceId", "");
                    jsonObject.put("deviceSystem", "android");
                    jsonObject.put("deviceVersion", android.os.Build.VERSION.RELEASE);
                } catch (JSONException e) { e.printStackTrace(); }
                callbackContext.success(jsonObject);
            });
            return true;
        }

        // Web 调用 -> 剩余存储空间
        else if (FREE_SIZE.equals(action)) {
            cordova.getThreadPool().execute(() -> {
                debugLog("[ FUNCTION ] '" + action + "' run");
                callbackContext.success((int) getAvailableInternalMemorySize() / 1024 / 1024);
            });
            return true;
        }

        // Web 调用 -> 总存储空间
        else if (STORE_SIZE.equals(action)) {
            cordova.getThreadPool().execute(() -> {
                debugLog("[ FUNCTION ] '" + action + "' run");
                callbackContext.success((int) getTotalInternalMemorySize()  / 1024 / 1024);
            });
            return true;
        }

        return super.execute(action, args, callbackContext);
    }

    //endregion


    //region Cordova Plugin Methods (Native -> Web)

    //endregion


    //region Cordova Plugin Result Methods

    /**
     * 发送到 Web 的回调
     * @param status 响应状态
     * @param message 回调参数
     * @param keepCallback 保持回调持续可用
     * @param callbackContext 回调信息
     */
    private void send(PluginResult.Status status, Object message, boolean keepCallback, CallbackContext callbackContext) {
        PluginResult pluginResult = null;
        if (message instanceof String) {
            pluginResult = new PluginResult(status, (String)message);
        } else if (message instanceof JSONArray) {
            pluginResult = new PluginResult(status, (JSONArray)message);
        } else if (message instanceof JSONObject) {
            pluginResult = new PluginResult(status, (JSONObject)message);
        } else if (message instanceof Integer) {
            pluginResult = new PluginResult(status, (int)message);
        } else if (message instanceof Float) {
            pluginResult = new PluginResult(status, (float)message);
        }
        assert pluginResult != null;
        pluginResult.setKeepCallback(keepCallback);
        callbackContext.sendPluginResult(pluginResult);
    }

    //endregion
}
