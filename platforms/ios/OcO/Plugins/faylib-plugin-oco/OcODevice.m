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

#import "OcODevice.h"

#define DLog(args...)\
[self debugLog:args, nil]

@interface OcODevice ()

// 调试模式
@property (nonatomic, assign) BOOL debugMode;

@end

@implementation OcODevice

#pragma mark - Private Methods

// 打印调试信息
- (void)debugLog:(NSString *)strings, ...
{
    if (self.debugMode) {
        NSLog(@"[ OcO ][ DEVICE ][ DEBUG ]%@.", strings);
        va_list list;
        va_start(list, strings);
        while (strings != nil) {
            NSString *string = va_arg(list, NSString *);
            if (!string) break;
            NSLog(@"[ OcO ][ DEVICE ][ DEBUG ]%@.", string);
        }
        va_end(list);
    }
}


#pragma mark - Cordova Plugin Methods (Web -> Native)

// Web 调用 -> 调试模式开关
- (void)debug_mode:(CDVInvokedUrlCommand *)command
{
    [self.commandDelegate runInBackground:^{
        self.debugMode = ([command.arguments[0] isEqual:@0]) ? NO : YES;
        DLog([NSString stringWithFormat:@" '%@' run", NSStringFromSelector(_cmd)], @" Debug Mode Open.");
    }];
}

// Web 调用 -> 获取设备系统
- (void)device_system:(CDVInvokedUrlCommand *)command
{
    [self.commandDelegate runInBackground:^{
        DLog([NSString stringWithFormat:@" '%@' run", NSStringFromSelector(_cmd)]);
        [self sendStatus:CDVCommandStatus_OK message:@"iOS" command:command];
    }];
}


#pragma mark - Cordova Plugin Methods (Native -> Web)


#pragma mark - Cordova Plugin Result Methods

// 发送到 Web 的回调
- (void)sendStatus:(CDVCommandStatus)status message:(NSObject *)message command:(CDVInvokedUrlCommand *)command
{
    [self sendStatus:status message:message keepCallback:NO command:command];
}

// 发送到 Web 的回调
- (void)sendStatus:(CDVCommandStatus)status message:(NSObject *)message keepCallback:(BOOL)yesOrNo command:(CDVInvokedUrlCommand *)command
{
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
    [pluginResult setKeepCallbackAsBool:yesOrNo];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end