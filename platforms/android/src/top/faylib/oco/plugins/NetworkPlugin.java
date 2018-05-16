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

import com.android.volley.DefaultRetryPolicy;
import com.android.volley.NetworkResponse;
import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.toolbox.Volley;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class NetworkPlugin extends CordovaPlugin {

    //region Variable

    // 调试模式
    private boolean debugMode = false;

    // 创建请求队列
    private RequestQueue queue = null;

    // 超时时隔
    private int timeoutInterval;

    // 请求结果状态码
    private int statusCode;

    //endregion


    //region Life Cycle Methods

    @Override
    protected void pluginInitialize() {
        // 初始化请求队列
        queue = Volley.newRequestQueue(cordova.getActivity());
        super.pluginInitialize();
    }

    //endregion


    //region Private Methods

    // 打印调试信息
    private void debugLog(String ... strings) {
        if (debugMode) {
            for (String string : strings) {
                Log.i("OcO", "[ NETWORK ][ DEBUG ] " + string);
            }
        }
    }

    /**
     * 发送请求
     *
     * @param method 请求方法
     * @param url 请求地址
     * @param params 请求参数
     * @param retryTimes 请求失败重试次数
     * @param callbackContext JavaScript回调
     */
    private void send(int method, String url, JSONObject params, int retryTimes, CallbackContext callbackContext) {

        if (timeoutInterval == 0) {
            timeoutInterval = 120000;
        }

        if (debugMode) { // 调试信息
            Log.i("OcO", "[ OcO ][ NETWORK ] Request sending with arguments.");
            Log.i("OcO", "[ OcO ][ FRAMEWORK ] SYSTEM");

            switch (method) {
                case 0:
                    Log.i("OcO", "[ OcO ][ METHOD ] GET");
                    break;
                case 1:
                    Log.i("OcO", "[ OcO ][ METHOD ] POST");
                    break;
                case 3:
                    Log.i("OcO", "[ OcO ][ METHOD ] DELETE");
                    break;
                default:
                    break;
            }

            Log.i("OcO", "[ OcO ][ URL ] " + url);
            Log.i("OcO", "[ OcO ][ PARAMS ] " + params.toString());
            Log.i("OcO", "[ OcO ][ RETRY ] " + String.valueOf(retryTimes));
            Log.i("OcO", "[ OcO ][ TIMEOUT INTERVAL ] " + String.valueOf(timeoutInterval/1000));
        }

        retryTimes--;
        int finalRetryTimes = retryTimes;
        JsonObjectRequest request = new JsonObjectRequest(method, url, params, response -> {
            callback(statusCode, response, callbackContext);
        }, error -> {
            if (finalRetryTimes < 1) {
                callback(statusCode, error, callbackContext);
            } else {
                send(method, url, params, finalRetryTimes, callbackContext);
            }
        }) {// 重写解析服务器返回的数据
            @Override
            protected Response<JSONObject> parseNetworkResponse(NetworkResponse response) {
                statusCode = response.statusCode;
                return super.parseNetworkResponse(response);
            }
        };

        // 添加请求超时间隔
        request.setRetryPolicy(new DefaultRetryPolicy(timeoutInterval,
                DefaultRetryPolicy.DEFAULT_MAX_RETRIES,
                DefaultRetryPolicy.DEFAULT_BACKOFF_MULT));

        // 添加请求到队列
        queue.add(request);
    }

    /**
     * 处理请求结果并回调到 Web
     *
     * @param statusCode 请求结果状态码
     * @param result 请求结果
     * @param callbackContext 回调信息
     */
    private void callback(int statusCode, Object result, CallbackContext callbackContext) {

        // 处理请求结果
        JSONObject jsonObject = new JSONObject();
        try {
            jsonObject.put("statusCode", statusCode);
            jsonObject.put("result", result);
        } catch (JSONException e) {
//            e.printStackTrace();
        }

        // 回调
        if (statusCode == 200 && result instanceof JSONObject) {
            if (debugMode) {// 调试信息
                Log.i("OcO", "[ OcO ][ NETWORK ] Request success.");
            }

            // 回调成功
            callbackContext.success(jsonObject.toString());
        } else {
            if (debugMode) {// 调试信息
                Log.i("OcO", "[ OcO ][ NETWORK ] Request failure.");
            }

            // 回调失败
            callbackContext.error(jsonObject.toString());
        }
    }

    //endregion


    //region Cordova Plugin Methods (JavaScript -> Java)

    /**
     * 执行 Web 端发送来的请求
     *
     * @param action          The action to execute.
     * @param args            The exec() arguments.
     * @param callbackContext The callback context used when calling back into JavaScript.
     * @return 是否执行成功
     * @throws JSONException 解析异常
     */
    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {

        // Web 调用 -> 调试模式开关
        if ("debug_mode".equals(action)) {
            debugMode = args.getBoolean(0);
            debugLog("debug_mode run", "Debug Mode Open");

            return true;
        }

        //  Web 调用 -> 设置超时时隔
        else if ("timeout_interval".equals(action)) {
            timeoutInterval = args.getInt(0);

            return true;
        }

        // Web 调用 -> 发送 GET 请求
        else if ("request_get".equals(action)) {
            send(Request.Method.GET, args.getString(0),
                    (args.optJSONObject(1) != null) ? args.getJSONObject(1) : new JSONObject(),
                    args.getInt(2),
                    callbackContext);
            
            return true;
        }

        // Web 调用 -> 发送 POST 请求
        else if ("request_post".equals(action)) {
            send(Request.Method.POST, args.getString(0),
                    (args.optJSONObject(1) != null) ? args.getJSONObject(1) : new JSONObject(),
                    args.getInt(2),
                    callbackContext);
            
            return true;
        }

        // Web 调用 -> 发送 POST 请求带参数
//        else if ("request_post_file".equals(action)) {
//            send(Request.Method.POST, args.getString(0),
//                    (args.optJSONObject(1) != null) ? args.getJSONObject(1) : new JSONObject(),
//                    args.getInt(2),
//                    args.getInt(3),
//                    callbackContext);
//
//            return true;
//        }

        // Web 调用 -> 发送 DELETE 请求
        else if ("request_delete".equals(action)) {
            send(Request.Method.DELETE, args.getString(0),
                    (args.optJSONObject(1) != null) ? args.getJSONObject(1) : new JSONObject(),
                    args.getInt(2),
                    callbackContext);
            
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
