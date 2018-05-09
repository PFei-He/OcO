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

package top.faylib.oco.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;

import com.android.volley.DefaultRetryPolicy;
import com.android.volley.NetworkResponse;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.toolbox.Volley;

import org.json.JSONObject;

import top.faylib.oco.R;

public class NativeActivity extends Activity {

    // 请求结果状态码
    private int statusCode;

    //region Views Life Cycle

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_native);
    }

    //endregion


    //region Events Management

    public void closeMe(View v) {
        finish();
    }

    public void requestNetwork(View v) {

        // 创建请求队列（异步请求）
        RequestQueue queue = Volley.newRequestQueue(this);

        // 创建网络请求（发送GET请求）
        JsonObjectRequest request = new JsonObjectRequest("http://www.weather.com.cn/data/sk/101010100.html", null, response -> {

            // 请求结果状态码
            Log.i("OcO", String.valueOf(statusCode));

            Log.i("OcO", response.toString());
        }, error -> {

            // 请求结果状态码
            Log.i("OcO", String.valueOf(error.networkResponse.statusCode));

            Log.i("OcO", error.toString());
        }) {// 重写网络响应的方法
            @Override
            protected Response<JSONObject> parseNetworkResponse(NetworkResponse response) {
                statusCode = response.statusCode;
                return super.parseNetworkResponse(response);
            }
        };

        // 添加请求超时间隔（30000毫秒-30秒），重试次数1次（失败不再重试），规避次数1f
        request.setRetryPolicy(new DefaultRetryPolicy(30000,
                DefaultRetryPolicy.DEFAULT_MAX_RETRIES,
                DefaultRetryPolicy.DEFAULT_BACKOFF_MULT));

        // 添加请求到队列
        queue.add(request);
    }

    //endregion


    //region Public Methods

    public static void start(Activity activity) {
        Intent intent = new Intent(activity, NativeActivity.class);
        activity.startActivity(intent);
    }

    //endregion
}
