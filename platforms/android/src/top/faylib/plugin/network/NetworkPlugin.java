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

package top.faylib.plugin.network;

import android.app.DownloadManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.net.Uri;
import android.util.Log;

import com.android.volley.AuthFailureError;
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

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

public class NetworkPlugin extends CordovaPlugin {

    //region Constant

    // 定义方法名
    private static final String DEBUG_MODE = "debug_mode";
    private static final String TIMEOUT_INTERVAL = "timeout_interval";
    private static final String RETRY_TIMES = "retry_times";
    private static final String SET_HEADERS = "set_headers";
    private static final String REQUEST_GET = "request_get";
    private static final String REQUEST_POST = "request_post";
    private static final String REQUEST_DELETE = "request_delete";
    private static final String REQUEST_DOWNLOAD = "request_download";
    private static final String RESET_REQUEST = "reset_request";

    //endregion


    //region Variable

    // 调试模式
    private boolean debugMode = false;

    // 请求队列
    private RequestQueue queue = null;

    // 超时时隔
    private int timeoutInterval = 120000;

    // 重试次数
    private int retryTimes = 1;

    // 请求头
    private Map<String, String> headers = new HashMap<>();

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

    // JSONObject 格式转 Map<String, String> 格式
    private static Map<String, String> toStringMap(JSONObject jsonObject) throws JSONException {
        Map<String, String> map = new HashMap<>();
        Iterator<String> keys = jsonObject.keys();
        while(keys.hasNext()) {
            String key = keys.next();
            map.put(key, jsonObject.getString(key));
        }   return map;
    }

    // JSONObject 格式转 Map<String, Object> 格式
    private static Map<String, Object> toObjectMap(JSONObject jsonObject) throws JSONException {
        Map<String, Object> map = new HashMap<>();
        Iterator<String> keys = jsonObject.keys();
        while(keys.hasNext()) {
            String key = keys.next();
            Object value = jsonObject.get(key);
            if (value instanceof JSONArray) {
                value = toList((JSONArray) value);
            } else if (value instanceof JSONObject) {
                value = toObjectMap((JSONObject) value);
            }
            map.put(key, value);
        }   return map;
    }

    // JSONArray 格式转 List<Object> 格式
    private static List<Object> toList(JSONArray jsonArray) throws JSONException {
        List<Object> list = new ArrayList<>();
        for(int i = 0; i < jsonArray.length(); i++) {
            Object value = jsonArray.get(i);
            if (value instanceof JSONArray) {
                value = toList((JSONArray) value);
            } else if (value instanceof JSONObject) {
                value = toObjectMap((JSONObject) value);
            }
            list.add(value);
        }   return list;
    }

    // 拼接参数
    private String appendParameter(String url, Map<String, String> params) {
        Uri uri = Uri.parse(url);
        Uri.Builder builder = uri.buildUpon();
        for(Map.Entry<String, String> entry : params.entrySet()) {
            builder.appendQueryParameter(entry.getKey(), entry.getValue());
        }
        return builder.build().getQuery();
    }

    // 打印调试信息
    private void debugLog(String ... strings) {
        if (debugMode) {
            for (String string : strings) {
                Log.i("OcO", "[ OcO ][ NETWORK ]" + string + ".");
            }
        }
    }

    // 发送请求
    private void request(int method, String url, Map params, int retryTimes, CallbackContext callbackContext) {

        switch (method) {
            case 0:
                debugLog(retryTimes == this.retryTimes ? "[ REQUEST ] Start sending" : "[ REQUEST ] Retrying",
                        "[ URL ] " + url,
                        "[ METHOD ] GET",
                        "[ PARAMS ] " + params.toString(),
                        "[ RETRY TIMES ] " + String.valueOf(retryTimes),
                        "[ TIMEOUT INTERVAL ] " + String.valueOf(timeoutInterval/1000));
                break;
            case 1:
                debugLog(retryTimes == this.retryTimes ? "[ REQUEST ] Start sending" : "[ REQUEST ] Retrying",
                        "[ URL ] " + url,
                        "[ METHOD ] POST",
                        "[ PARAMS ] " + params.toString(),
                        "[ RETRY TIMES ] " + String.valueOf(retryTimes),
                        "[ TIMEOUT INTERVAL ] " + String.valueOf(timeoutInterval/1000));
                break;
            case 3:
                debugLog(retryTimes == this.retryTimes ? "[ REQUEST ] Start sending" : "[ REQUEST ] Retrying",
                        "[ URL ] " + url,
                        "[ METHOD ] DELETE",
                        "[ PARAMS ] " + params.toString(),
                        "[ RETRY TIMES ] " + String.valueOf(retryTimes),
                        "[ TIMEOUT INTERVAL ] " + String.valueOf(timeoutInterval/1000));
                break;
            default:
                break;
        }

        retryTimes--;
        int count = retryTimes;

        JsonObjectRequest request = new JsonObjectRequest(method, url, null, response -> {
            parse(url, statusCode, response, callbackContext);
        }, error -> {
            if (count < 1) {
                parse(url, statusCode, error, callbackContext);
            } else {
                request(method, url, params, count, callbackContext);
            }
        }) {
            // 重写请求头
            @Override
            public Map<String, String> getHeaders() throws AuthFailureError {
                headers.putAll(super.getHeaders());
                debugLog("[ HEADERS ] " + headers.toString());
                return headers;
            }

            // 重写请求体的内容类型
            @Override
            public String getBodyContentType() {
                return "application/x-www-form-urlencoded; charset=" + getParamsEncoding();
            }

            // 重写请求体
            @Override
            public byte[] getBody() {
                try {
                    final String string = appendParameter(url, params);
                    return string.getBytes(PROTOCOL_CHARSET);
                } catch (UnsupportedEncodingException uee) {
                    return null;
                }
            }

            // 重写解析服务器返回的数据
            @Override
            protected Response<JSONObject> parseNetworkResponse(NetworkResponse response) {
                statusCode = response.statusCode;
                return super.parseNetworkResponse(response);
            }
        };

        // 添加请求超时时隔
        request.setRetryPolicy(new DefaultRetryPolicy(timeoutInterval,
                DefaultRetryPolicy.DEFAULT_MAX_RETRIES,
                DefaultRetryPolicy.DEFAULT_BACKOFF_MULT));

        // 添加请求到队列
        queue.add(request);
    }

    // 数据处理
    private void parse(String url, int statusCode, Object result, CallbackContext callbackContext) {

        // 处理请求结果
        JSONObject jsonObject = new JSONObject();
        try {
            jsonObject.put("statusCode", statusCode);
            jsonObject.put("result", result.toString());
        } catch (JSONException e) { e.printStackTrace(); }

        // 回调结果到 Web 端
        if (statusCode == 200) {
            if (result instanceof JSONObject) {
                debugLog("[ REQUEST ] Success", "[ URL ] " + url);
                callbackContext.success(jsonObject.toString());
            } else {
                debugLog("[ REQUEST ] Success but not JSON data", "[ URL ] " + url);
                callbackContext.error(jsonObject.toString());
            }
        } else {
            debugLog("[ REQUEST ] Failure", "[ URL ] " + url);
            callbackContext.error(jsonObject.toString());
        }
    }

    // 监听下载
    private void listener(final long id, JSONArray args, CallbackContext callbackContext) {
        // 注册广播监听系统的下载完成事件
        IntentFilter intentFilter = new IntentFilter(DownloadManager.ACTION_DOWNLOAD_COMPLETE);
        BroadcastReceiver broadcastReceiver = new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                if (intent.getLongExtra(DownloadManager.EXTRA_DOWNLOAD_ID, -1) == id) {
                    try {
                        parse(args.getString(0), DownloadManager.STATUS_SUCCESSFUL, args.getString(1), callbackContext);
                    } catch (JSONException e) { e.printStackTrace(); }
                }
            }
        };
        cordova.getActivity().registerReceiver(broadcastReceiver, intentFilter);
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
                } catch (JSONException e) { e.printStackTrace(); }
                debugLog("[ FUNCTION ] '" + action + "' run", " Debug Mode Open");
            });
            return true;
        }

        //  Web 调用 -> 设置超时时隔
        else if (TIMEOUT_INTERVAL.equals(action)) {
            cordova.getThreadPool().execute(() -> {
                debugLog("[ FUNCTION ] '" + action + "' run");
                try {
                    timeoutInterval = args.getInt(0);
                } catch (JSONException e) { e.printStackTrace(); }
            });
            return true;
        }

        // Web 调用 -> 设置重试次数
        else if (RETRY_TIMES.equals(action)) {
            cordova.getThreadPool().execute(() -> {
                debugLog("[ FUNCTION ] '" + action + "' run");
                try {
                    retryTimes = args.getInt(0);
                } catch (JSONException e) { e.printStackTrace(); }
            });
            return true;
        }

        // Web 调用 -> 设置请求头
        else if (SET_HEADERS.equals(action)) {
            cordova.getThreadPool().execute(() -> {
                debugLog("[ FUNCTION ] '" + action + "' run");
                try {
                    headers.putAll(toStringMap(args.optJSONObject(0)!=null ? args.optJSONObject(0) : new JSONObject("{}")));
                } catch (JSONException e) { e.printStackTrace(); }
            });
        }

        // Web 调用 -> 发送 GET 请求
        else if (REQUEST_GET.equals(action)) {
            cordova.getThreadPool().execute(() -> {
                debugLog("[ FUNCTION ] '" + action + "' run");
                try {
                    Map map = toObjectMap(args.optJSONObject(1)!=null ? args.optJSONObject(1) : new JSONObject("{}"));
                    request(Request.Method.GET, args.getString(0), map, retryTimes, callbackContext);
                } catch (JSONException e) { e.printStackTrace(); }
            });
            return true;
        }

        // Web 调用 -> 发送 POST 请求
        else if (REQUEST_POST.equals(action)) {
            cordova.getThreadPool().execute(() -> {
                debugLog("[ FUNCTION ] '" + action + "' run");
                try {
                    Map map = toObjectMap(args.optJSONObject(1)!=null ? args.optJSONObject(1) : new JSONObject("{}"));
                    request(Request.Method.POST, args.getString(0), map, retryTimes, callbackContext);
                } catch (JSONException e) { e.printStackTrace(); }
            });
            return true;
        }

        // Web 调用 -> 发送 DELETE 请求
        else if (REQUEST_DELETE.equals(action)) {
            cordova.getThreadPool().execute(() -> {
                debugLog("[ FUNCTION ] '" + action + "' run");
                try {
                    Map map = toObjectMap(args.optJSONObject(1)!=null ? args.optJSONObject(1) : new JSONObject("{}"));
                    request(Request.Method.DELETE, args.getString(0), map, retryTimes, callbackContext);
                } catch (JSONException e) { e.printStackTrace(); }
            });
            return true;
        }

        // Web 调用 -> 发送下载请求
        else if (REQUEST_DOWNLOAD.equals(action)) {
            cordova.getThreadPool().execute(() -> {
                debugLog("[ FUNCTION ] '" + action + "' run");
                DownloadManager downloadManager = (DownloadManager)cordova.getActivity().getSystemService(Context.DOWNLOAD_SERVICE);
                DownloadManager.Request request = null;
                try {
                    request = new DownloadManager.Request(Uri.parse(args.getString(0)));
                    request.setDestinationInExternalFilesDir(cordova.getActivity(), null, args.getString(1));
                } catch (JSONException e) { e.printStackTrace(); }
                long downloadId = downloadManager != null ? downloadManager.enqueue(request) : 0;
                listener(downloadId, args, callbackContext);
            });
        }

        // Web 调用 -> 重置请求
        else if (RESET_REQUEST.equals(action)) {
            cordova.getThreadPool().execute(() -> {
                debugLog("[ FUNCTION ] '" + action + "' run");
                timeoutInterval = 120000;
                retryTimes = 1;
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
