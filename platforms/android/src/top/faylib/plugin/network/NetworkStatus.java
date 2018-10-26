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

import android.app.Activity;
import android.app.Service;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;

import java.util.Objects;

public class NetworkStatus extends BroadcastReceiver {
    private static Type type = null;
    public static final String NET_CHANGE_ACTION = "android.net.conn.CONNECTIVITY_CHANGE";
    Receiver receiver = new Receiver();
    Observer observer = new Observer();

    @Override
    public void onReceive(Context context, Intent intent) {
        receiver.init(context);
        if (receiver.getType() == type) return;
        if (Objects.equals(intent.getAction(), NET_CHANGE_ACTION)) {
            type = receiver.getType();
            Status status = observer.getNetworkStatus();
            status.onChange(type);
        }
    }

    public class Receiver {
        private ConnectivityManager getConnectivityManager(Context context) {
            return (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
        }

        private Context globalContext;

        public void init(Context context) {
            if (globalContext != null) return;
            if (context instanceof Activity) {
                globalContext = ((Activity) context).getApplication();
            } else if (context instanceof Service) {
                globalContext = ((Service) context).getApplication();
            } else {
                globalContext = context.getApplicationContext();
            }
        }

        public Type getType() {
            if (globalContext == null) {
                throw new RuntimeException(Receiver.class.getSimpleName() + "");
            }
            init(globalContext);
            ConnectivityManager connectivityManager = getConnectivityManager(globalContext);
            NetworkInfo networkInfo = connectivityManager.getActiveNetworkInfo();
            if (networkInfo == null) return Type.OcO_NETWORK_REACHABILITY_STATUS_NONE;
            else if (networkInfo.getType() == ConnectivityManager.TYPE_MOBILE) return Type.OcO_NETWORK_REACHABILITY_STATUS_WWAN;
            else if (networkInfo.getType() == ConnectivityManager.TYPE_WIFI) return Type.OcO_NETWORK_REACHABILITY_STATUS_WIFI;
            return Type.OcO_NETWORK_REACHABILITY_STATUS_NONE;
        }
    }

    public static class Observer {
        private static Status globalStatus;

        public static synchronized void register(Status status) {
            globalStatus = status;
        }

        public static void unregister() {
            globalStatus = null;
        }

        public Status getNetworkStatus() {
            return globalStatus;
        }
    }

    public enum Type {
        OcO_NETWORK_REACHABILITY_STATUS_NONE,
        OcO_NETWORK_REACHABILITY_STATUS_WWAN,
        OcO_NETWORK_REACHABILITY_STATUS_WIFI
    }

    public interface Status {
        void onChange(Type type);
    }
}
