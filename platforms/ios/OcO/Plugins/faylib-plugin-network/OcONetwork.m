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
@property (nonatomic, strong) AFHTTPSessionManager *manager;

// 超时时隔
@property (nonatomic) NSInteger timeoutInterval;

// 重试次数
@property (nonatomic) NSInteger retryTimes;

@end

@implementation OcONetwork

#pragma mark - Setter / Getter Methods

// 初始化请求
- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
        _manager.requestSerializer.timeoutInterval = 120;
        _manager.responseSerializer.acceptableContentTypes = [_manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    }
    return _manager;
}

// 超时时隔
- (void)setTimeoutInterval:(NSInteger)timeoutInterval
{
    self.manager.requestSerializer.timeoutInterval = timeoutInterval;
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
- (void)sendWithMethod:(OcONetworkRequestMethod)method url:(NSString *)url params:(NSDictionary *)params retryTimes:(NSInteger)count response:(CDVInvokedUrlCommand *)command
{    
    if (method == OcONetworkRequestMethodGET) DLog(count == self.retryTimes ? @"[ REQUEST ] Start sending" : @"[ REQUEST ] Retrying", [NSString stringWithFormat:@"[ URL ] %@", url], @"[ METHOD ] GET", [NSString stringWithFormat:@"[ PARAMS ] %@", params], [NSString stringWithFormat:@"[ RETRY TIMES ] %@", @(count)], [NSString stringWithFormat:@"[ TIMEOUT INTERVAL ] %@", @(self.manager.requestSerializer.timeoutInterval)]);
    else if (method == OcONetworkRequestMethodPOST) DLog(count == self.retryTimes ? @"[ REQUEST ] Start sending" : @"[ REQUEST ] Retrying", [NSString stringWithFormat:@"[ URL ] %@", url], @"[ METHOD ] POST", [NSString stringWithFormat:@"[ PARAMS ] %@", params], [NSString stringWithFormat:@"[ RETRY TIMES ] %@", @(count)], [NSString stringWithFormat:@"[ TIMEOUT INTERVAL ] %@", @(self.manager.requestSerializer.timeoutInterval)]);
    else if (method == OcONetworkRequestMethodDELETE) DLog(count == self.retryTimes ? @"[ REQUEST ] Start sending" : @"[ REQUEST ] Retrying", [NSString stringWithFormat:@"[ URL ] %@", url], @"[ METHOD ] DELETE", [NSString stringWithFormat:@"[ PARAMS ] %@", params], [NSString stringWithFormat:@"[ RETRY TIMES ] %@", @(count)], [NSString stringWithFormat:@"[ TIMEOUT INTERVAL ] %@", @(self.manager.requestSerializer.timeoutInterval)]);
    
    count--;
    
    switch (method) {
        case OcONetworkRequestMethodGET:
        {
            [self.manager GET:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull responseObject) {
                [self parseWithURL:url task:task result:responseObject command:command];
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                if (count < 1) [self parseWithURL:url task:task result:[NSString stringWithFormat:@"%@", error] command:command];
                else [self sendWithMethod:OcONetworkRequestMethodGET url:url params:params retryTimes:count response:command];
            }];
        }
            break;
        case OcONetworkRequestMethodPOST:
        {
            [self.manager POST:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull responseObject) {
                [self parseWithURL:url task:task result:responseObject command:command];
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                if (count < 1) [self parseWithURL:url task:task result:[NSString stringWithFormat:@"%@", error] command:command];
                else [self sendWithMethod:OcONetworkRequestMethodPOST url:url params:params retryTimes:count response:command];
            }];
        }
            break;
        case OcONetworkRequestMethodDELETE:
        {
            [self.manager DELETE:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                [self parseWithURL:url task:task result:responseObject command:command];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (count < 1) [self parseWithURL:url task:task result:[NSString stringWithFormat:@"%@", error] command:command];
                else [self sendWithMethod:OcONetworkRequestMethodDELETE url:url params:params retryTimes:count response:command];
            }];
        }
            break;
        default:
            break;
    }
}

// 数据处理
- (void)parseWithURL:(NSString *)url task:(NSURLSessionTask *)task result:(id)result command:(CDVInvokedUrlCommand *)command
{
    // 请求结果状态码
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
    NSInteger statusCode = [response statusCode];
    
    // 回调结果到 Web 端
    if (statusCode == 200) {
        if ([result isKindOfClass:[NSDictionary class]]) {
            DLog(@"[ REQUEST ] Success", [NSString stringWithFormat:@"[ URL ] %@", url]);
            [self sendStatus:CDVCommandStatus_OK message:@{@"statusCode": @(statusCode), @"response": result} command:command];
        } else {
            DLog(@"[ REQUEST ] Success but not JSON data", [NSString stringWithFormat:@"[ URL ] %@", url]);
            [self sendStatus:CDVCommandStatus_ERROR message:@{@"statusCode": @(statusCode), @"response": [NSString stringWithFormat:@"%@", result]} command:command];
        }
    } else {
        DLog(@"[ REQUEST ] Failure", [NSString stringWithFormat:@"[ URL ] %@", url]);
        [self sendStatus:CDVCommandStatus_ERROR message:@{@"statusCode": @(statusCode), @"response": result} command:command];
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
            [self.manager.requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }];
}
// Web 调用 -> 发送 GET 请求
- (void)request_get:(CDVInvokedUrlCommand *)command
{
    [self.commandDelegate runInBackground:^{
        DLog([NSString stringWithFormat:@"[ FUNCTION ] '%@' run", NSStringFromSelector(_cmd)]);
        [self sendWithMethod:OcONetworkRequestMethodGET url:command.arguments[0] params:command.arguments[1] retryTimes:self.retryTimes response:command];
    }];
}

// Web 调用 -> 发送 POST 请求
- (void)request_post:(CDVInvokedUrlCommand *)command
{
    [self.commandDelegate runInBackground:^{
        DLog([NSString stringWithFormat:@"[ FUNCTION ] '%@' run", NSStringFromSelector(_cmd)]);
        [self sendWithMethod:OcONetworkRequestMethodPOST url:command.arguments[0] params:command.arguments[1] retryTimes:self.retryTimes response:command];
    }];
}

// Web 调用 -> 发送 DELETE 请求
- (void)request_delete:(CDVInvokedUrlCommand *)command
{
    [self.commandDelegate runInBackground:^{
        DLog([NSString stringWithFormat:@"[ FUNCTION ] '%@' run", NSStringFromSelector(_cmd)]);
        [self sendWithMethod:OcONetworkRequestMethodDELETE url:command.arguments[0] params:command.arguments[1] retryTimes:self.retryTimes response:command];
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
