OcO
===

About / 简介
---
Cordova + Vue 构建的 Hybrid App<br>
<br>
随着现在移动开发周期越来越短，各种各样的应用井喷式的出现，又如潮水般消失，导致应用的生命周期变得非常不稳定，各种快速开发，跨平台集成的需求越来越大，所以就催生了 `Native + Web` 这种快速构建的模式，利用 HTML5 搭建应用界面，原生做数据和逻辑处理。这样做的好处是减轻了移动端对不同设备做界面适配的工作，只需一套界面即可在所有设备中运行，大大减少开发时间。<br>
<br>
目前市面上存在的比较流行的框架分为 `React-Native` 和 `Cordova` ，这里选用的是 `Cordova` 。<br>
p.s. 包括 `ionic` ，`weex` 等框架也是利用 `Cordova` 做底层进行二次封装的，所以学会 `Cordova` ，对于其它框架的上手会有很大的帮助。<br>
<br>
这套工程存在的目的，即是为不了解 Hybrid App 的开发者提供快速上手的教程，帮助其学会如何从零开始搭建，编写到最后打包成一个完整的应用。


Structure / 目录结构
---
```
OcO/
    config.xml                  // 工程配置文件，包含有工程名，描述，使用平台，插件等信息
    ../hooks/
    LICENSE                     // 开源证书（ MIT ）
    ../node_modules/            // npm 目录，存放构建工程需要的工具
    ../original/                // 资源文件夹，用于存放工程用到的所有源文件
        ../image/               // 存放图片
        ../plugin/              // 存放自定义插件
    package.json                // 工程配置文件，构建工程时会使用此文件更新 config.xml 的内容
    ../platforms/               // 移动端文件夹
        ../android/             // Android 端根目录
        ../ios/                 // iOS 端根目录
        platforms.json          // 移动端信息文件，包含有如使用平台，平台版本号等信息
    ../plugins/                 // 存放插件包，编译时会自动导入到相应平台的工程中
    README.md                   // 工程说明（即为此文件）
    ../res/                     // 资源文件夹，用于存放应用的 icon 图片，splash screen 图片
        ../icon/                // icon 图片
        ../screen/              // splash screen 图片
    ../shell/                   // 存放 Shell 脚本文件
    ../web/                     // Web 端根目录（Vue 工程目录）
        ../bulid/
        ../config/
        index.html              // Web 首页，由于为单页面应用，所以整个 Web App 只有这一页
        ../node_modules/        // npm 目录，存放构建工程需要的工具
        package.json            // 工程配置文件，构建 Web 工程时所需要的信息
        README.md
        ../src/                 // Web 端源代码及资源文件夹
        ../static/              // 临时存放 Web 端编译好的文件，后会移到 www/ 目录
    ../www/                     // Cordova 的 Web 端的根目录，用于存放编译好的文件，HTML，CSS，JavaScript 等（Vue 工程编译后的文件会存放于此）
```



Cordova
===

Install / 安装
---
```
$sudo npm i cordova -g
```


Create / 创建
---
```
$cordova create ProjectName PackageName AppName

// example / 范例
$cordova create OcO xyz.saturn.OcO OcO
```


Add Platform / 添加移动端
---
* Android
```
$cd OcO/
$cordova platform add android
```

* iOS
```
$cd OcO/
$cordova platform add ios
```


Plugin List / 插件列表
---
```
$cd OcO/
$cordova plugin list
```


Add Plugin / 添加插件
---
```
$cordova plugin add <PLUGIN_NAME>
```

* Cordova Splash Screen
```
$cd OcO/
$cordova plugin add cordova-plugin-splashscreen
$cordova plugin add https://github.com/apache/cordova-plugin-splashscreen.git
```

* Cordova Camera
```
$cd OcO/
$cordova plugin add cordova-plugin-camera
```

* Cordova Console
```
$cd OcO/
$cordova plugin add cordova-plugin-console
```

* Cordova WKWebView Engine
```
$cd OcO/
$cordova plugin add cordova-plugin-wkwebview-engine
```


Remove Plugin / 移除插件
---
```
$cordova plugin remove <PLUGIN_NAME>
```

* Cordova Splash Screen
```
$cd OcO/
$cordova plugin remove cordova-plugin-splashscreen
```

* Cordova Camera
```
$cd OcO/
$cordova plugin remove cordova-plugin-camera
```

* Cordova Console
```
$cd OcO/
$cordova plugin remove cordova-plugin-console
```

* Cordova WKWebView Engine
```
$cd OcO/
$cordova plugin remove cordova-plugin-wkwebview-engine
```


Custom Plugin / 自定义插件
---
### Structure / 目录结构
```
saturn.plugin.test          // 插件包名
    ../src/                 // 存放移动端代码文件
        ../android/         // 存放 Android 端代码
            TestPlugin.java // Android 端代码文件
        ../ios/             // 存放 iOS 端代码文件
            STRTest.h       // iOS 端代码文件
            STRTest.m       // iOS 端代码文件
    ../www/                 // 存放 Web 端代码文件
        test.js             // Web 端代码文件
    package.json            // 插件描述文件
    plugin.xml              // 插件配置文件
    LICENSE                 // 开源证书
```

### JSON
* `package.json`
```
{
    "name": "saturn-plugin-test",           // 插件名称
    "version": "0.0.1",                     // 版本号
    "description": "Saturn Test Plugin",    // 插件描述
    "cordova": {
        "id": "saturn-plugin-test",         // 插件的ID，这个很重要，要和插件目录名一致
        "platforms": [                      // 插件支持的平台
            "android",                      // 该插件支持Android和iOS
            "ios"
        ]
    },
    "repository": {                         // 远程库地址
        "type": "git",
        "url": "https://github.com/saturn/STRPluginTest"
    },
    "issue": "",
    "keywords": [                           // 用于在 cordova plugin search 被查找出来
        "saturn",
        "cordova",
        "test",
        "ecosystem:cordova",
        "cordova-android",
        "cordova-ios"
    ],
    "author": "498130877@qq.com",           // 作者
    "license": "MIT"                        // 开源协议
}
```

### XML
* `plugin.xml`
```
<?xml version="1.0" encoding="UTF-8"?>

<plugin xmlns="http://apache.org/cordova/ns/plugins/1.0"
           id="saturn-plugin-test"
      version="0.0.1">

    <name>Test</name>
    <description>Saturn Test Plugin</description>
    <license>MIT</license>
    <keywords>saturn,test</keywords>
    <repo>></repo>
    <issue></issue>

    <engines>
        <engine name="cordova-android" version=">=5.0.0"/>
        <engine name="cordova-ios" version=">=9.0.0"/>
    </engines>

    <!-- android -->
    <platform name="android">
        <js-module src="www/test.js" name="test">
            <run/>
            <clobbers target="saturn.test" />
        </js-module>
        <config-file target="config.xml" parent="/*">
            <feature name="Test" >
                <param name="android-package" value="xyz.saturn.test.TestPlugin"/>
                <param name="onload" value="true" />
            </feature>
        </config-file>
        <source-file src="src/android/TestPlugin.java" target-dir="src/xyz/saturn/test" />
    </platform>

    <!-- ios -->
    <platform name="ios">
        <js-module src="www/test.js" name="test">
            <run/>
            <clobbers target="saturn.test" />
        </js-module>
        <config-file target="config.xml" parent="/*">
            <feature name="Test">
                <param name="ios-package" value="Test" onload="true" />
            </feature>
        </config-file>
        <header-file src="src/ios/STRTest.h" />
        <source-file src="src/ios/STRTest.m" />
    </platform>

</plugin>
```

### Web
* `test.js`
```
var test = exports;
var exec = require('cordova/exec');

test.testMethod = function(arguments, successCallback, failureCallback) {
    exec(successCallback, failureCallback, 'Test', 'test_method', arguments);
}
```

### Android
* `TestPlugin.java`
```
package xyz.saturn.test;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
import org.json.JSONArray;
import org.json.JSONException;

public class TestPlugin extends CordovaPlugin {
    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        
        if ("test_method".equals(action)) {

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
}
```

### iOS
* `STRTest.h`
```
#import <Cordova/CDV.h>

@interface STRTest : CDVPlugin

@end
```

* `STRTest.m`
```
#import <Foundation/Foundation.h>
#import "STRTest.h"

@implementation STRTest
    
- (void)test_method:(CDVInvokedUrlCommand *)command
{
    // 获取 Web 端传递来的参数
    NSString *param = command.arguments[0];
    
    // 响应成功的结果并回调到 Web 端
    [self sendStatus:CDVCommandStatus_ERROR message:@"SUCCESS" command:command];
    
    // 响应失败的结果并回调到 Web 端
    [self sendStatus:CDVCommandStatus_ERROR message:@"ERROR" command:command];
}

@end
```

### Install Custom Plugin / 安装自定义插件
```
$cordova plugin add <PLUGIN_PATH>

// example / 范例
$cd OcO/
$cordova plugin add orginal/plugin/saturn-plugin-test
```


Build / 构建
---
运行编译命令 `$cordova build` / `$cordova build android` 或添加插件命令 `$cordova plugin add ***` (*** 代表插件名)时出现错误提示 `Error: spawn EACCES` ，
表示 cordova 没有获得 build / android build 的权限，执行 `$sudo chmod -R a+rwx ***/` (*** 表示该工程的根目录) / `$sudo chmod -R a+rwx ***/platforms/android/` (*** 表示该工程的根目录)来获得权限；
或因工程没有获得使用 Gradle 的权限，执行 `sudo chmod 755 "/Applications/Android Studio.app/Contents/gradle/gradle-***/bin/gradle"` (*** 代表版本号)来获得权限。

* All
```
$cordova build
```

* Android
```
$cordova build android
```

* iOS
```
$cordova build ios
```



Vue
===

Root Path / 目录
---
`/OcO/web`


Install / 安装
---
```
$sudo npm install --global vue-cli
```


Create / 创建
---
```
$vue init webpack PackageName

// example / 范例
$cd OcO/
$vue init webpack web
```

node
---
```
$npm i / $npm install
```


Build / 构建
---
```
$npm run build
```


Debug / 调试
---
```
$npm run dev
```


Integrate / 整合
---
* 将 Vue 项目构建到 Cordova 的 Web 端 `/OcO/web/config/index.js`
```
// line 7 / 7行
// index: path.resolve(__dirname, '../dist/index.html'),
index: path.resolve(__dirname, '../../www/index.html'),
```

```
// line 8 / 8行
// assetsRoot: path.resolve(__dirname, '../dist'),
assetsRoot: path.resolve(__dirname, '../../www'),
```

```
// line 10 / 10行
// assetsPublicPath: '/',
assetsPublicPath: './',
```

* 导入 Cordova 库以引导 Web 端 `/OcO/web/index.html`
```
// line 17 / 17行
<script src="cordova.js"></script>
```


Custom shell script / 自定义脚本 `OcO/web/package.json`
---
```
// line 12 / 12行
"cordova": "npm run build && cordova build"
```

```
$npm run shell_name

// example / 范例
$cd OcO/web/
$npm run cordova
```



Android
===

Root Path / 目录
---
`OcO/platforms/android`


Library / 类库 `/OcO/platforms/android/build.gradle`
---
* [Volley](https://github.com/google/volley)
```
// line 261 / 261行
compile 'com.android.volley:volley:1.0.0'
```

* [Gson](https://github.com/google/gson)
```
// line 262 / 262行
compile 'com.google.code.gson:gson:2.8.0'
```


Add Plugin / 添加插件 `/OcO/platforms/android/android.json`
---
声明用于 `JavaScript` 与 `Java` 通信的接口文件。
```
{
    "xml": "<feature name=\"Adapter\"><param name=\"android-package\" value=\"xyz.saturn.oco.plugins.AdapterPlugin\" /><param name=\"onload\" value=\"true\" /></feature>",
    "count": 1
},
{
    "xml": "<feature name=\"Device\"><param name=\"android-package\" value=\"xyz.saturn.oco.plugins.DevicePlugin\" /><param name=\"onload\" value=\"true\" /></feature>",
    "count": 1
},
{
    "xml": "<feature name=\"Network\"><param name=\"android-package\" value=\"xyz.saturn.oco.plugins.NetworkPlugin\" /><param name=\"onload\" value=\"true\" /></feature>",
    "count": 1
}
```


WebActivity
---
Cordova 默认寻找 `/OcO/platforms/android/src/xyz/saturn/oco` 目录下继承 'CordovaActivity' 的子类作为 WebActivity，若修改了 WebActivity 的路径，需要更改 Cordova 的读取路径。<br>
* `/OcO/platforms/android/cordova/lib/prepare.js`
* `/OcO/node_modules/cordova-android/bin/templates/cordova/lib/prepare.js`
```
// line 196 / 196行
// var javaPattern = path.join(locations.root, 'src', orig_pkg.replace(/\./g, '/'), '*.java');
var javaPattern = path.join(locations.root, 'src', orig_pkg.replace(/\./g, '/'), 'activity', '*.java');
```

```
// line 207 / 207行
// var destFile = path.join(locations.root, 'src', pkg.replace(/\./g, '/'), path.basename(java_files[0]));
var destFile = path.join(locations.root, 'src', pkg.replace(/\./g, '/'), 'activity', path.basename(java_files[0]));
```

```
// line 209 / 209行
// shell.sed(/package [\w\.]*;/, 'package ' + pkg + ';', java_files[0]).to(destFile);
shell.sed(/package [\w\.]*;/, 'package ' + pkg + '.activity' + ';', java_files[0]).to(destFile);
```


Gradle
---
解决 `Android Studio` 使用 `Gradle` 构建工程慢，从 [Gradle官网](https://gradle.org) 下载适用的版本，将zip包放入到 `/Users/username/.gradle/wrapper/dists/gradle-***-all/***/` (*** 表示版本号)目录下，重新打开工程，`Android Studio` 会自行解压安装。



iOS
===

Root Path / 目录
---
`OcO/platforms/ios`


Library / 类库 `/OcO/platforms/ios/Podfile`
---
* [AFNetworking](https://github.com/AFNetworking/AFNetworking)
```
// line 5 / 5行
pod 'AFNetworking', '~> 2.6.0'
```


Add Plugin / 添加插件 `/OcO/platforms/ios/ios.json`
---
声明用于 `JavaScript` 与 `Objective-C` 通信的接口文件。
```
// line 15-26 / 15-26行
{
    "xml": "<feature name=\"Adapter\"><param name=\"ios-package\" value=\"OcOAdapter\" /><param name=\"onload\" value=\"true\" /></feature>",
    "count": 1
},
{
    "xml": "<feature name=\"Device\"><param name=\"ios-package\" value=\"OcODevice\" /><param name=\"onload\" value=\"true\" /></feature>",
    "count": 1
},
{
    "xml": "<feature name=\"Network\"><param name=\"ios-package\" value=\"OcONetwork\" /><param name=\"onload\" value=\"true\" /></feature>",
    "count": 1
}
```


UIWebView and WKWebView
---
由于 `UIWebView` 性能缓慢，对于单页面应用不够友好，使用全新的 `WKWebView` 替代，全面提升其速度和降低内存资源使用率。<br>
使用 Shell 脚本 `wkwebview-install` 可快速替换，但需要先执行 `vue-build` 构建工程。
```
// 通过判断是否支持 IndexDB 来判定当前的 web 框架是 UIWebView 还是 WKWebView
if (window.indexedDB) {
    console.log('[ OcO ][ DEBUG ] Current web framework is WKWebView!')
} else {
    console.log('[ OcO ][ DEBUG ] Current web framework is UIWebView!')
}
```


CocoaPods
---
* Install / 安装
```
$sudo gem install -n /usr/local/bin cocoapods
```

* Download / 下载类库
```
$pod install
```

由于未知原因，Cordova 工程添加 CocoaPods 后，不能自动修改配置文件导致工程报错，需要修复后才能使用 `OcO/platforms/ios/cordova/build.xcconfig` 。
```
HEADER_SEARCH_PATHS = "$(TARGET_BUILD_DIR)/usr/local/lib/include" "$(OBJROOT)/UninstalledProducts/include" "$(OBJROOT)/UninstalledProducts/$(PLATFORM_NAME)/include" "$(BUILT_PRODUCTS_DIR)" "${PODS_ROOT}/Headers/Public" "${PODS_ROOT}/Headers/Public/AFNetworking"

OTHER_LDFLAGS = -ObjC -l"AFNetworking" -framework "CoreGraphics" -framework "MobileCoreServices" -framework "Security" -framework "SystemConfiguration"

GCC_PREPROCESSOR_DEFINITIONS = $(inherited) COCOAPODS=1
LIBRARY_SEARCH_PATHS = $(inherited) "$PODS_CONFIGURATION_BUILD_DIR/AFNetworking"
PODS_BUILD_DIR = $BUILD_DIR
PODS_CONFIGURATION_BUILD_DIR = $PODS_BUILD_DIR/$(CONFIGURATION)$(EFFECTIVE_PLATFORM_NAME)
PODS_PODFILE_DIR_PATH = ${SRCROOT}/.
PODS_ROOT = ${SRCROOT}/Pods
```



Shell
===

Root Path / 目录
---
`/OcO/shell`


Detail / 说明
---
* cordova-clean             清空全部构建内容

* cordova-plugin-add        添加插件

* cordova-plugin-remove     移除插件

* npm-install               安装 npm

* npm-remove                移除 npm

* pod-install               为 iOS 工程导入指定的类库

* vue-build                 构建 Vue 的代码并加载到 Cordova

* wkwebview-install         将 iOS 的 web 框架换成 WKWebView，需要先执行 `vue-build` 构建工程

* wkwebview-remove          将 iOS 的 web 框架换成 UIWebView，需要先执行 `vue-build` 构建工程



License
===
`OcO` is released under the MIT license, see [LICENSE](https://raw.githubusercontent.com/PFei-He/OcO/master/LICENSE) for details.
