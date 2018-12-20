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

#import "FLNetwork.h"
#import <AFNetworking/AFNetworking.h>

// 调试打印
#define DLog(args...)\
[self debugLog:args, nil]

typedef NS_ENUM(NSUInteger, FLNetworkRequestMethod) {
    FLNetworkRequestMethodGET,
    FLNetworkRequestMethodPOST,
    FLNetworkRequestMethodDELETE,
    FLNetworkRequestMethodDownload
};

// 定义网络状态
NSString * const FL_NETWORK_REACHABILITY_STATUS_UNKNOWN = @"FL_NETWORK_REACHABILITY_STATUS_UNKNOWN";
NSString * const FL_NETWORK_REACHABILITY_STATUS_NONE = @"FL_NETWORK_REACHABILITY_STATUS_NONE";
NSString * const FL_NETWORK_REACHABILITY_STATUS_WWAN = @"FL_NETWORK_REACHABILITY_STATUS_WWAN";
NSString * const FL_NETWORK_REACHABILITY_STATUS_WIFI = @"FL_NETWORK_REACHABILITY_STATUS_WIFI";

@interface FLNetwork ()

/// 调试模式
@property (nonatomic, assign) BOOL debugMode;

/// 网络请求
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

/// 网络状态
@property (nonatomic, strong) AFNetworkReachabilityManager *reachabilityManager;

/// 超时时隔
@property (nonatomic) NSInteger timeoutInterval;

/// 重试次数
@property (nonatomic) NSInteger retryTimes;

@end

@implementation FLNetwork

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

// 初始化监控
- (AFNetworkReachabilityManager *)reachabilityManager
{
    if (!_reachabilityManager) {
        _reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    }
    return _reachabilityManager;
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
        NSLog(@"[ FayLIB ][ NETWORK ]%@.", strings);
        va_list list;
        va_start(list, strings);
        while (strings != nil) {
            NSString *string = va_arg(list, NSString *);
            if (!string) break;
            NSLog(@"[ FayLIB ][ NETWORK ]%@.", string);
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
- (void)sendWithMethod:(FLNetworkRequestMethod)method retryTimes:(NSInteger)count response:(CDVInvokedUrlCommand *)command
{
    switch (method) {
        case FLNetworkRequestMethodGET:
        {
            DLog(count == self.retryTimes ? @"[ REQUEST ] Start sending" : @"[ REQUEST ] Retrying",
                 [NSString stringWithFormat:@"[ URL ] %@", command.arguments[0]],
                 @"[ METHOD ] GET",
                 [NSString stringWithFormat:@"[ PARAMS ] %@", command.arguments[1]],
                 [NSString stringWithFormat:@"[ RETRY TIMES ] %@", @(count)],
                 [NSString stringWithFormat:@"[ TIMEOUT INTERVAL ] %@", @(self.sessionManager.requestSerializer.timeoutInterval)],
                 [NSString stringWithFormat:@"[ HEADERS ] %@", self.sessionManager.requestSerializer.HTTPRequestHeaders]);
            
            count--;
            
            [self.sessionManager GET:command.arguments[0] parameters:command.arguments[1] success:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull responseObject) {
                [self parseWithMethod:FLNetworkRequestMethodGET response:(NSHTTPURLResponse *)task.response result:responseObject command:command];
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                if (count < 1) [self parseWithMethod:FLNetworkRequestMethodGET response:(NSHTTPURLResponse *)task.response result:[NSString stringWithFormat:@"%@", error] command:command];
                else [self sendWithMethod:FLNetworkRequestMethodGET retryTimes:count response:command];
            }];
        }
            break;
        case FLNetworkRequestMethodPOST:
        {
            DLog(count == self.retryTimes ? @"[ REQUEST ] Start sending" : @"[ REQUEST ] Retrying",
                 [NSString stringWithFormat:@"[ URL ] %@", command.arguments[0]],
                 @"[ METHOD ] POST",
                 [NSString stringWithFormat:@"[ PARAMS ] %@", command.arguments[1]],
                 [NSString stringWithFormat:@"[ RETRY TIMES ] %@", @(count)],
                 [NSString stringWithFormat:@"[ TIMEOUT INTERVAL ] %@", @(self.sessionManager.requestSerializer.timeoutInterval)],
                 [NSString stringWithFormat:@"[ HEADERS ] %@", self.sessionManager.requestSerializer.HTTPRequestHeaders]);
            
            count--;
            
            [self.sessionManager POST:command.arguments[0] parameters:command.arguments[1] success:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull responseObject) {
                [self parseWithMethod:FLNetworkRequestMethodPOST response:(NSHTTPURLResponse *)task.response result:responseObject command:command];
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                if (count < 1) [self parseWithMethod:FLNetworkRequestMethodPOST response:(NSHTTPURLResponse *)task.response result:[NSString stringWithFormat:@"%@", error] command:command];
                else [self sendWithMethod:FLNetworkRequestMethodPOST retryTimes:count response:command];
            }];
        }
            break;
        case FLNetworkRequestMethodDELETE:
        {
            DLog(count == self.retryTimes ? @"[ REQUEST ] Start sending" : @"[ REQUEST ] Retrying",
                 [NSString stringWithFormat:@"[ URL ] %@", command.arguments[0]],
                 @"[ METHOD ] DELETE",
                 [NSString stringWithFormat:@"[ PARAMS ] %@", command.arguments[1]],
                 [NSString stringWithFormat:@"[ RETRY TIMES ] %@", @(count)],
                 [NSString stringWithFormat:@"[ TIMEOUT INTERVAL ] %@", @(self.sessionManager.requestSerializer.timeoutInterval)],
                 [NSString stringWithFormat:@"[ HEADERS ] %@", self.sessionManager.requestSerializer.HTTPRequestHeaders]);
            
            count--;
            
            [self.sessionManager DELETE:command.arguments[0] parameters:command.arguments[1] success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                [self parseWithMethod:FLNetworkRequestMethodDELETE response:(NSHTTPURLResponse *)task.response result:responseObject command:command];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (count < 1) [self parseWithMethod:FLNetworkRequestMethodDELETE response:(NSHTTPURLResponse *)task.response result:[NSString stringWithFormat:@"%@", error] command:command];
                else [self sendWithMethod:FLNetworkRequestMethodDELETE retryTimes:count response:command];
            }];
        }
            break;
        case FLNetworkRequestMethodDownload:
        {
            DLog(count == self.retryTimes ? @"[ REQUEST ] Start sending" : @"[ REQUEST ] Retrying",
                 [NSString stringWithFormat:@"[ URL ] %@", command.arguments[0]],
                 @"[ METHOD ] Download",
                 [NSString stringWithFormat:@"[ FILE PATH ] %@", command.arguments[1]],
                 [NSString stringWithFormat:@"[ RETRY TIMES ] %@", @(count)],
                 [NSString stringWithFormat:@"[ TIMEOUT INTERVAL ] %@", @(self.sessionManager.requestSerializer.timeoutInterval)],
                 [NSString stringWithFormat:@"[ HEADERS ] %@", self.sessionManager.requestSerializer.HTTPRequestHeaders]);
            
            count--;
            
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:command.arguments[0]]];
            NSURLSessionDownloadTask *downloadTask = [self.sessionManager downloadTaskWithRequest:request progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                // 保存路径
                return [NSURL fileURLWithPath:command.arguments[1]];
            } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                if (!error) {
                    [self parseWithMethod:FLNetworkRequestMethodDownload response:(NSHTTPURLResponse *)response result:filePath command:command];
                } else {
                    if (count < 1) [self parseWithMethod:FLNetworkRequestMethodDownload response:(NSHTTPURLResponse *)response result:error command:command];
                    else [self sendWithMethod:FLNetworkRequestMethodDownload retryTimes:count response:command];
                }
            }];
            [downloadTask resume];
        }
            break;
        default:
            break;
    }
}

// 数据处理
- (void)parseWithMethod:(FLNetworkRequestMethod)method response:(NSHTTPURLResponse *)response result:(id)result command:(CDVInvokedUrlCommand *)command
{
    // 回调结果到 Web 端
    if (response.statusCode == 200) {
        switch (method) {
            case FLNetworkRequestMethodGET:
            case FLNetworkRequestMethodPOST:
            case FLNetworkRequestMethodDELETE:
            {
                if ([result isKindOfClass:[NSDictionary class]]) {
                    DLog(@"[ REQUEST ] Success", [NSString stringWithFormat:@"[ URL ] %@", command.arguments[0]]);
                    [self sendStatus:CDVCommandStatus_OK message:@{@"statusCode": @(response.statusCode), @"result": result} command:command];
                } else {
                    DLog(@"[ REQUEST ] Success but not JSON data", [NSString stringWithFormat:@"[ URL ] %@", command.arguments[0]]);
                    [self sendStatus:CDVCommandStatus_ERROR message:@{@"statusCode": @(response.statusCode), @"result": [NSString stringWithFormat:@"%@", result]} command:command];
                }
            }
                break;
            case FLNetworkRequestMethodDownload:
            {
                if ([result isKindOfClass:[NSURL class]]) {
                    DLog(@"[ REQUEST ] Success", [NSString stringWithFormat:@"[ URL ] %@", command.arguments[0]]);
                    [self sendStatus:CDVCommandStatus_OK message:@{@"statusCode": @(response.statusCode), @"result": [NSString stringWithFormat:@"%@", result]} command:command];
                } else {
                    DLog(@"[ REQUEST ] Success but error file", [NSString stringWithFormat:@"[ URL ] %@", command.arguments[0]]);
                    [self sendStatus:CDVCommandStatus_ERROR message:@{@"statusCode": @(response.statusCode), @"result": [NSString stringWithFormat:@"%@", result]} command:command];
                }
            }
                break;
            default:
                break;
        }
    } else {
        DLog(@"[ REQUEST ] Failure", [NSString stringWithFormat:@"[ URL ] %@", command.arguments[0]]);
        [self sendStatus:CDVCommandStatus_ERROR message:@{@"statusCode": @(response.statusCode), @"result": [NSString stringWithFormat:@"%@", result]} command:command];
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
        [self sendWithMethod:FLNetworkRequestMethodGET retryTimes:self.retryTimes response:command];
    }];
}

// Web 调用 -> 发送 POST 请求
- (void)request_post:(CDVInvokedUrlCommand *)command
{
    [self.commandDelegate runInBackground:^{
        DLog([NSString stringWithFormat:@"[ FUNCTION ] '%@' run", NSStringFromSelector(_cmd)]);
        [self sendWithMethod:FLNetworkRequestMethodPOST retryTimes:self.retryTimes response:command];
    }];
}

// Web 调用 -> 发送 DELETE 请求
- (void)request_delete:(CDVInvokedUrlCommand *)command
{
    [self.commandDelegate runInBackground:^{
        DLog([NSString stringWithFormat:@"[ FUNCTION ] '%@' run", NSStringFromSelector(_cmd)]);
        [self sendWithMethod:FLNetworkRequestMethodDELETE retryTimes:self.retryTimes response:command];
    }];
}

// Web 调用 -> 发送下载请求
- (void)request_download:(CDVInvokedUrlCommand *)command
{
    [self.commandDelegate runInBackground:^{
        DLog([NSString stringWithFormat:@"[ FUNCTION ] '%@' run", NSStringFromSelector(_cmd)]);
        [self sendWithMethod:FLNetworkRequestMethodDownload retryTimes:self.retryTimes response:command];
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

// Web 调用 -> 打开网络监听
- (void)start_monitoring:(CDVInvokedUrlCommand *)command
{
    [self.commandDelegate runInBackground:^{
        DLog([NSString stringWithFormat:@"[ FUNCTION ] '%@' run", NSStringFromSelector(_cmd)]);
        [self.reachabilityManager startMonitoring];
        [self sendStatus:CDVCommandStatus_OK message:nil keepCallback:YES command:command];
        __weak __typeof__(self) weakSelf = self;
        [self.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            __typeof__(weakSelf) self = weakSelf;
            switch (status) {
                case AFNetworkReachabilityStatusUnknown:
                    [self sendStatus:CDVCommandStatus_OK message:FL_NETWORK_REACHABILITY_STATUS_UNKNOWN keepCallback:YES command:command];
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                    [self sendStatus:CDVCommandStatus_OK message:FL_NETWORK_REACHABILITY_STATUS_NONE keepCallback:YES command:command];
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    [self sendStatus:CDVCommandStatus_OK message:FL_NETWORK_REACHABILITY_STATUS_WWAN keepCallback:YES command:command];
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    [self sendStatus:CDVCommandStatus_OK message:FL_NETWORK_REACHABILITY_STATUS_WIFI keepCallback:YES command:command];
                    break;
                default:
                    break;
            }
        }];
    }];
}

// Web 调用 -> 关闭网络监听
- (void)stop_monitoring:(CDVInvokedUrlCommand *)command
{
    [self.commandDelegate runInBackground:^{
        DLog([NSString stringWithFormat:@"[ FUNCTION ] '%@' run", NSStringFromSelector(_cmd)]);
        [self.reachabilityManager stopMonitoring];
        [self sendStatus:CDVCommandStatus_OK message:nil keepCallback:YES command:command];
    }];
}

// Web 调用 -> 网络状态
- (void)network_reachability:(CDVInvokedUrlCommand *)command
{
    [self.commandDelegate runInBackground:^{
        DLog([NSString stringWithFormat:@"[ FUNCTION ] '%@' run", NSStringFromSelector(_cmd)]);
        if (self.reachabilityManager.networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWWAN) {
            [self sendStatus:CDVCommandStatus_OK message:FL_NETWORK_REACHABILITY_STATUS_WWAN command:command];
        } else if (self.reachabilityManager.networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi) {
            [self sendStatus:CDVCommandStatus_OK message:FL_NETWORK_REACHABILITY_STATUS_WIFI command:command];
        } else {
            [self sendStatus:CDVCommandStatus_OK message:FL_NETWORK_REACHABILITY_STATUS_NONE command:command];
        }
    }];
}

@end
