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

#import "FLTest.h"

@interface FLTest ()

// 调试模式
@property (nonatomic, assign) BOOL debugMode;

@end

@implementation FLTest

#pragma mark - Private Methods

// 打印调试信息
- (void)debugLog:(NSString *)strings, ...
{
    if (self.debugMode) {
        NSLog(@"[ FAYLIB ][ TEST ][ DEBUG ] %@", strings);
        va_list list;
        va_start(list, strings);
        while (strings != nil) {
            NSString *string = va_arg(list, NSString *);
            if (!string) break;
            NSLog(@"[ FAYLIB ][ TEST ][ DEBUG ] %@", string);
        }
        va_end(list);
    }
}


#pragma mark - Cordova Plugin Methods (JavaScript -> Objective-C)

// 接收 Web 端发送来的 'debug_mode' 消息并作出响应，command: 与 Web 端通信的响应对象
- (void)debug_mode:(CDVInvokedUrlCommand *)command
{
    self.debugMode = command.arguments[0];
    
    [self debugLog:@"debug_mode run", @"Debug Mode Open", nil];
}

// 接收 Web 端发送来的 'test_method' 消息并作出响应，command: 与 Web 端通信的响应对象
- (void)test_method:(CDVInvokedUrlCommand *)command
{
    // 获取 Web 端传递来的参数
    NSString *param = command.arguments[0];
    
    // 响应 '成功' 并回调到 Web 端
    [self sendStatus:CDVCommandStatus_ERROR message:@"SUCCESS" command:command];

    // 响应 '失败' 并回调到 Web 端
    [self sendStatus:CDVCommandStatus_ERROR message:@"ERROR" command:command];
}


#pragma mark - Cordova Plugin Methods (Objective-C -> JavaScript)


#pragma mark - CDVPlugin Methods

// 发送到 Web 端的回调
- (void)sendStatus:(CDVCommandStatus)status message:(NSObject *)message command:(CDVInvokedUrlCommand *)command
{
    [self sendStatus:status message:message keepCallback:NO command:command];
}

// 发送到JS的回调
- (void)sendStatus:(CDVCommandStatus)status message:(NSObject *)message keepCallback:(BOOL)yesOrNo command:(CDVInvokedUrlCommand *)command
{
    // 响应结果
    CDVPluginResult *pluginResult = nil;
    if ([message isKindOfClass:[NSString class]]) {
        pluginResult = [CDVPluginResult resultWithStatus:status messageAsString:(NSString *)message];
    } else if ([message isKindOfClass:[NSArray class]]) {
        pluginResult = [CDVPluginResult resultWithStatus:status messageAsArray:(NSArray *)message];
    } else if ([message isKindOfClass:[NSDictionary class]]) {
        pluginResult = [CDVPluginResult resultWithStatus:status messageAsDictionary:(NSDictionary *)message];
    } else if ([message isKindOfClass:[NSNumber class]]) {
        if ([[NSString stringWithFormat:@"%@", message] hasPrefix:@"."]) {
            pluginResult = [CDVPluginResult resultWithStatus:status messageAsDouble:[(NSNumber *)message doubleValue]];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:status messageAsInt:[(NSNumber *)message intValue]];
        }
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:status];
    }

    // 保持响应
    [pluginResult setKeepCallbackAsBool:yesOrNo];

    // 发送响应结果
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
