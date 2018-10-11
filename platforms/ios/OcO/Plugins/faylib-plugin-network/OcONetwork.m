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

#import "OcONetwork.h"
#import <AFNetworking/AFNetworking.h>

#define DLog(args...)\
[self debugLog:args, nil]

typedef NS_ENUM(NSUInteger, OcONetworkRequestMethod) {
    OcONetworkRequestMethodGET,
    OcONetworkRequestMethodPOST,
    OcONetworkRequestMethodDELETE,
};

@interface OcONetwork ()

// 调试模式
@property (nonatomic, assign) BOOL debugMode;

// 网络请求
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

// 超时时隔
@property (nonatomic) NSInteger timeoutInterval;

// 重试次数
@property (nonatomic) NSInteger retryTimes;

@end

@implementation OcONetwork

#pragma mark - Setter / Getter Methods

// 初始化请求
- (AFHTTPSessionManager *)sessionManager
{
    if (!_sessionManager) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.requestSerializer.timeoutInterval = 120;
        _sessionManager.responseSerializer.acceptableContentTypes = [_sessionManager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    }
    return _sessionManager;
}

// 超时时隔
- (void)setTimeoutInterval:(NSInteger)timeoutInterval
{
    self.sessionManager.requestSerializer.timeoutInterval = timeoutInterval;
    _timeoutInterval = timeoutInterval;
}

// 重试次数
- (NSInteger)retryTimes
{
    if (_retryTimes == 0) {
        _retryTimes = 1;
    }
    return _retryTimes;
}


#pragma mark - Private Methods

// 打印调试信息
- (void)debugLog:(NSString *)strings, ...
{
    if (self.debugMode) {
        NSLog(@"[ OcO ][ NETWORK ]%@.", strings);
        va_list list;
        va_start(list, strings);
        while (strings != nil) {
            NSString *string = va_arg(list, NSString *);
            if (!string) break;
            NSLog(@"[ OcO ][ NETWORK ]%@.", string);
        }
        va_end(list);
    }
}

// 解析 JSON
- (NSString *)parseJSON:(id)json
{
    NSError *error;
    NSString *jsonString;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:&error];
    if (jsonData) jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

// 发送请求
- (void)sendWithMethod:(OcONetworkRequestMethod)method retryTimes:(NSInteger)count response:(CDVInvokedUrlCommand *)command
{
    if (method == OcONetworkRequestMethodGET)
        DLog(count == self.retryTimes ? @"[ REQUEST ] Start sending" : @"[ REQUEST ] Retrying",
             [NSString stringWithFormat:@"[ URL ] %@", command.arguments[0]],
             @"[ METHOD ] GET",
             [NSString stringWithFormat:@"[ PARAMS ] %@", command.arguments[1]],
             [NSString stringWithFormat:@"[ RETRY TIMES ] %@", @(count)],
             [NSString stringWithFormat:@"[ TIMEOUT INTERVAL ] %@", @(self.sessionManager.requestSerializer.timeoutInterval)],
             [NSString stringWithFormat:@"[ HEADERS ] %@", self.sessionManager.requestSerializer.HTTPRequestHeaders]);
    else if (method == OcONetworkRequestMethodPOST)
        DLog(count == self.retryTimes ? @"[ REQUEST ] Start sending" : @"[ REQUEST ] Retrying",
             [NSString stringWithFormat:@"[ URL ] %@", command.arguments[0]],
             @"[ METHOD ] POST",
             [NSString stringWithFormat:@"[ PARAMS ] %@", command.arguments[1]],
             [NSString stringWithFormat:@"[ RETRY TIMES ] %@", @(count)],
             [NSString stringWithFormat:@"[ TIMEOUT INTERVAL ] %@", @(self.sessionManager.requestSerializer.timeoutInterval)],
             [NSString stringWithFormat:@"[ HEADERS ] %@", self.sessionManager.requestSerializer.HTTPRequestHeaders]);
    else if (method == OcONetworkRequestMethodDELETE)
        DLog(count == self.retryTimes ? @"[ REQUEST ] Start sending" : @"[ REQUEST ] Retrying",
             [NSString stringWithFormat:@"[ URL ] %@", command.arguments[0]],
             @"[ METHOD ] DELETE",
             [NSString stringWithFormat:@"[ PARAMS ] %@", command.arguments[1]],
             [NSString stringWithFormat:@"[ RETRY TIMES ] %@", @(count)],
             [NSString stringWithFormat:@"[ TIMEOUT INTERVAL ] %@", @(self.sessionManager.requestSerializer.timeoutInterval)],
             [NSString stringWithFormat:@"[ HEADERS ] %@", self.sessionManager.requestSerializer.HTTPRequestHeaders]);
    
    count--;
    
    switch (method) {
        case OcONetworkRequestMethodGET:
        {
            [self.sessionManager GET:command.arguments[0] parameters:command.arguments[1] success:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull responseObject) {
                [self parseWithMethod:OcONetworkRequestMethodGET response:(NSHTTPURLResponse *)task.response result:responseObject command:command];
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                if (count < 1) [self parseWithMethod:OcONetworkRequestMethodGET response:(NSHTTPURLResponse *)task.response result:[NSString stringWithFormat:@"%@", error] command:command];
                else [self sendWithMethod:OcONetworkRequestMethodGET retryTimes:count response:command];
            }];
        }
            break;
        case OcONetworkRequestMethodPOST:
        {
            [self.sessionManager POST:command.arguments[0] parameters:command.arguments[1] success:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull responseObject) {
                [self parseWithMethod:OcONetworkRequestMethodPOST response:(NSHTTPURLResponse *)task.response result:responseObject command:command];
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                if (count < 1) [self parseWithMethod:OcONetworkRequestMethodPOST response:(NSHTTPURLResponse *)task.response result:[NSString stringWithFormat:@"%@", error] command:command];
                else [self sendWithMethod:OcONetworkRequestMethodPOST retryTimes:count response:command];
            }];
        }
            break;
        case OcONetworkRequestMethodDELETE:
        {
            [self.sessionManager DELETE:command.arguments[0] parameters:command.arguments[1] success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                [self parseWithMethod:OcONetworkRequestMethodDELETE response:(NSHTTPURLResponse *)task.response result:responseObject command:command];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (count < 1) [self parseWithMethod:OcONetworkRequestMethodDELETE response:(NSHTTPURLResponse *)task.response result:[NSString stringWithFormat:@"%@", error] command:command];
                else [self sendWithMethod:OcONetworkRequestMethodDELETE retryTimes:count response:command];
            }];
        }
            break;
        default:
            break;
    }
}

// 数据处理
- (void)parseWithMethod:(OcONetworkRequestMethod)method response:(NSHTTPURLResponse *)response result:(id)result command:(CDVInvokedUrlCommand *)command
{
    // 回调结果到 Web 端
    if (response.statusCode == 200) {
        switch (method) {
            case OcONetworkRequestMethodGET:
            case OcONetworkRequestMethodPOST:
            case OcONetworkRequestMethodDELETE:
            {
                if ([result isKindOfClass:[NSDictionary class]]) {
                    DLog(@"[ REQUEST ] Success", [NSString stringWithFormat:@"[ URL ] %@", command.arguments[0]]);
                    [self sendStatus:CDVCommandStatus_OK message:@{@"statusCode": @(response.statusCode), @"response": result} command:command];
                } else {
                    DLog(@"[ REQUEST ] Success but not JSON data", [NSString stringWithFormat:@"[ URL ] %@", command.arguments[0]]);
                    [self sendStatus:CDVCommandStatus_ERROR message:@{@"statusCode": @(response.statusCode), @"response": [NSString stringWithFormat:@"%@", result]} command:command];
                }
            }
                break;
            default:
                break;
        }
    } else {
        DLog(@"[ REQUEST ] Failure", [NSString stringWithFormat:@"[ URL ] %@", command.arguments[0]]);
        [self sendStatus:CDVCommandStatus_ERROR message:@{@"statusCode": @(response.statusCode), @"response": result} command:command];
    }
}


#pragma mark - Cordova Plugin Methods (Web -> Native)

// Web 调用 -> 调试模式开关
- (void)debug_mode:(CDVInvokedUrlCommand *)command
{
    [self.commandDelegate runInBackground:^{
        self.debugMode = ([command.arguments[0] isEqual:@0]) ? NO : YES;
        DLog([NSString stringWithFormat:@"[ FUNCTION ] '%@' run", NSStringFromSelector(_cmd)], @" Debug Mode Open");
    }];
}

// Web 调用 -> 设置超时时隔
- (void)timeout_interval:(CDVInvokedUrlCommand *)command
{
    [self.commandDelegate runInBackground:^{
        DLog([NSString stringWithFormat:@"[ FUNCTION ] '%@' run", NSStringFromSelector(_cmd)]);
        self.timeoutInterval = [command.arguments[0] integerValue] / 1000;
    }];
}

// Web 调用 -> 设置重试次数
- (void)retry_times:(CDVInvokedUrlCommand *)command
{
    [self.commandDelegate runInBackground:^{
        DLog([NSString stringWithFormat:@"[ FUNCTION ] '%@' run", NSStringFromSelector(_cmd)]);
        self.retryTimes = [command.arguments[0] integerValue];
    }];
}

// Web 调用 -> 设置请求头
- (void)set_headers:(CDVInvokedUrlCommand *)command
{
    [self.commandDelegate runInBackground:^{
        DLog([NSString stringWithFormat:@"[ FUNCTION ] '%@' run", NSStringFromSelector(_cmd)]);
        [command.arguments[0] enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL * _Nonnull stop) {
            [self.sessionManager.requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }];
}

// Web 调用 -> 发送 GET 请求
- (void)request_get:(CDVInvokedUrlCommand *)command
{
    [self.commandDelegate runInBackground:^{
        DLog([NSString stringWithFormat:@"[ FUNCTION ] '%@' run", NSStringFromSelector(_cmd)]);
        [self sendWithMethod:OcONetworkRequestMethodGET retryTimes:self.retryTimes response:command];
    }];
}

// Web 调用 -> 发送 POST 请求
- (void)request_post:(CDVInvokedUrlCommand *)command
{
    [self.commandDelegate runInBackground:^{
        DLog([NSString stringWithFormat:@"[ FUNCTION ] '%@' run", NSStringFromSelector(_cmd)]);
        [self sendWithMethod:OcONetworkRequestMethodPOST retryTimes:self.retryTimes response:command];
    }];
}

// Web 调用 -> 发送 DELETE 请求
- (void)request_delete:(CDVInvokedUrlCommand *)command
{
    [self.commandDelegate runInBackground:^{
        DLog([NSString stringWithFormat:@"[ FUNCTION ] '%@' run", NSStringFromSelector(_cmd)]);
        [self sendWithMethod:OcONetworkRequestMethodDELETE retryTimes:self.retryTimes response:command];
    }];
}

// Web 调用 -> 重置请求
- (void)reset_request:(CDVInvokedUrlCommand *)command
{
    [self.commandDelegate runInBackground:^{
        DLog([NSString stringWithFormat:@"[ FUNCTION ] '%@' run", NSStringFromSelector(_cmd)]);
        self.timeoutInterval = 120;
        self.retryTimes = 1;
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
