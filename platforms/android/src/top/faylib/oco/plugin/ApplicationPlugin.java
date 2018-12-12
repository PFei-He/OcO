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

package top.faylib.oco.plugin;

import android.content.Context;
import android.content.SharedPreferences;
import android.util.Log;

import org.apache.cordova.CallbackContext;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import top.faylib.base.BasePlugin;
import top.faylib.oco.BuildConfig;

public class ApplicationPlugin extends BasePlugin {
    //region Private Variable

    // 调试模式
    private boolean debugMode = false;

    //endregion


    //region Private Methods

    // 打印调试信息
    private void debugLog(String ... strings) {
        if (debugMode) {
            for (String string : strings) {
                Log.i("OcO", "[ OcO ][ APPLICATION ]" + string + ".");
            }
        }
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
        if (BuildConfig.DEBUG_MODE.equals(action)) {
            cordova.getThreadPool().execute(() -> {
                try {
                    debugMode = args.getBoolean(0);
                    debugLog("[ FUNCTION ] '" + action + "' run", " Debug Mode Open");
                } catch (JSONException e) { e.printStackTrace(); }
            });
            return true;
        }

        // Web 调用 -> 加载应用信息
        else if (BuildConfig.LOAD.equals(action)) {
            cordova.getThreadPool().execute(() -> {
                debugLog("[ FUNCTION ] '" + action + "' run");
                JSONObject jsonObject = new JSONObject();
                try {
                    SharedPreferences sharedPreferences = cordova.getActivity().getSharedPreferences("OcO", Context.MODE_PRIVATE);
                    jsonObject.put("currentLanguage", sharedPreferences.getString("OcO_CURRENT_LANGUAGE", "zh_CN"));
                    jsonObject.put("currentVersion", "1.0.0");
                } catch (JSONException e) { e.printStackTrace(); }
                callbackContext.success(jsonObject);
            });
            return true;
        }

        // Web 调用 -> 更换语言环境
        else if (BuildConfig.CHANGE_LANGUAGE.equals(action)) {
            cordova.getThreadPool().execute(() -> {
                debugLog("[ FUNCTION ] '" + action + "' run");
                try {
                    SharedPreferences sharedPreferences = cordova.getActivity().getSharedPreferences("OcO", Context.MODE_PRIVATE);
                    SharedPreferences.Editor editor = sharedPreferences.edit();
                    editor.putString("OcO_CURRENT_LANGUAGE", args.getString(0));
                    editor.apply();
                } catch (JSONException e) { e.printStackTrace(); }
            });
            return true;
        }

        return super.execute(action, args, callbackContext);
    }

    //endregion
}
