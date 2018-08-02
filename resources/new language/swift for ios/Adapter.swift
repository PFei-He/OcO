//
//  Copyright (c) 2018 faylib.top
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

@objc(OcOAdapter)
class Adapter: CDVPlugin {
    
    // 调试模式
    private var debugMode = false
    
    
    // MARK: Private Methods
    
    // 打印调试信息
    private func debugLog(_ strings: String ...) {
        if debugMode {
            for string in strings {
                print("[ OcO ][ ADAPTER ]\(string).")
            }
        }
    }
    
    
    // MARK: Cordova Plugin Methods (Web -> Native)
    
    // Web 调用 -> 调试模式开关
    func debug_mode(_ command: CDVInvokedUrlCommand) {
        commandDelegate.run(inBackground: {
            self.debugMode = command.arguments[0] as! Bool
            self.debugLog("[ FUNCTION ] '\(#function)' run", " Debug Mode Open")
        })
    }
    
    // Web 调用 -> 关闭 Web 页面
    func dismiss_web(_ command: CDVInvokedUrlCommand) {
        viewController.dismiss(animated: true, completion: nil)
        commandDelegate.run(inBackground: {
            self.webDismissed()
            self.debugLog("[ FUNCTION ] '\(#function)' run", " Debug Mode Open")
        })
    }
    
    
    // MARK: Cordova Plugin Methods (Native -> Web)
    
    // iOS 调用 -> Web 页面已关闭
    func webDismissed() {
        commandDelegate.evalJs("web_dismissed()")
    }
    
    
    // MARK: CDVPlugin Methods
    
    // 发送到 Web 的回调
    func send(status: CDVCommandStatus, message:Any, command: CDVInvokedUrlCommand) {
        send(status: status, message: message, keepCallback: false, command: command)
    }
    
    // 发送到 Web 的回调
    func send(status: CDVCommandStatus, message:Any, keepCallback: Bool, command: CDVInvokedUrlCommand) {
        var pluginResult: CDVPluginResult!
        if message is String {
            pluginResult = CDVPluginResult(status: status, messageAs: message as! String)
        } else if message is Array<Any> {
            pluginResult = CDVPluginResult(status: status, messageAs: message as! Array)
        } else if message is Dictionary<String, Any> {
            pluginResult = CDVPluginResult(status: status, messageAs: message as! Dictionary)
        } else if message is Int {
            pluginResult = CDVPluginResult(status: status, messageAs: message as! Int)
        } else if message is Double {
            pluginResult = CDVPluginResult(status: status, messageAs: message as! Double)
        } else {
            pluginResult = CDVPluginResult(status: status)
        }
        pluginResult.setKeepCallbackAs(keepCallback)
        commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }
}
