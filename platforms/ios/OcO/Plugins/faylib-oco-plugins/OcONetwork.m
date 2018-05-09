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

@interface OcONetwork ()

// 调试模式
@property (nonatomic, assign) BOOL debugMode;

// 创建请求
@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation OcONetwork

#pragma mark - Setter / Getter Methods

// 初始化请求
- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
        _manager.responseSerializer.acceptableContentTypes = [_manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    }
    return _manager;
}


#pragma mark - Private Methods

// 打印调试信息
- (void)debugLog:(NSString *)strings, ...
{
    if (self.debugMode) {
        NSLog(@"[ NETWORK ][ DEBUG ] %@", strings);
        va_list list;
        va_start(list, strings);
        while (strings != nil) {
            NSString *string = va_arg(list, NSString *);
            if (!string) break;
            NSLog(@"[ NETWORK ][ DEBUG ] %@", string);
        }
        va_end(list);
    }
}

// 发送 GET 请求
- (void)GET:(NSString *)url params:(NSDictionary *)params retryTimes:(NSInteger)retryTimes command:(CDVInvokedUrlCommand *)command
{
    if (self.debugMode) {// 调试信息
        NSLog(@"[ OcO ][ NETWORK ] Request sending with arguments.");
        NSLog(@"[ OcO ][ FRAMEWORK ] SYSTEM");
        NSLog(@"[ OcO ][ METHOD ] GET");
        NSLog(@"[ OcO ][ URL ] %@", url);
        NSLog(@"[ OcO ][ PARAMS ] %@", params);
        NSLog(@"[ OcO ][ RETRY] %@", @(retryTimes));
        NSLog(@"[ OcO ][ TIMEOUT ] %@", @(self.manager.requestSerializer.timeoutInterval));
    }
    
    retryTimes--;
    [self.manager GET:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull responseObject) {
        [self callback:task result:responseObject command:command];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        if (retryTimes < 1) {
            [self callback:task result:[NSString stringWithFormat:@"%@", error] command:command];
            return;
        }
        [self GET:url params:params retryTimes:retryTimes command:command];
    }];
}

// 发送 POST 请求
- (void)POST:(NSString *)url params:(NSDictionary *)params retryTimes:(NSInteger)retryTimes command:(CDVInvokedUrlCommand *)command
{
    if (self.debugMode) {// 调试信息
        NSLog(@"[ OcO ][ NETWORK ] Request sending with arguments.");
        NSLog(@"[ OcO ][ FRAMEWORK ] SYSTEM");
        NSLog(@"[ OcO ][ METHOD ] POST");
        NSLog(@"[ OcO ][ URL ] %@", url);
        NSLog(@"[ OcO ][ PARAMS ] %@", params);
        NSLog(@"[ OcO ][ RETRY] %@", @(retryTimes));
        NSLog(@"[ OcO ][ TIMEOUT ] %@", @(self.manager.requestSerializer.timeoutInterval));
    }
    
    retryTimes--;
    [self.manager POST:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull responseObject) {
        [self callback:task result:responseObject command:command];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        if (retryTimes < 1) {
            [self callback:task result:[NSString stringWithFormat:@"%@", error] command:command];
            return;
        }
        [self POST:url params:params retryTimes:retryTimes command:command];
    }];
}

// 发送 POST 请求带参数
- (void)POST:(NSString *)url params:(NSDictionary *)params body:(void (^)(id <AFMultipartFormData> formData))body retryTimes:(NSInteger)retryTimes command:(CDVInvokedUrlCommand *)command
{
    if (self.debugMode) {// 调试信息
        NSLog(@"[ OcO ][ NETWORK ] Request sending with arguments.");
        NSLog(@"[ OcO ][ FRAMEWORK ] SYSTEM");
        NSLog(@"[ OcO ][ METHOD ] POST");
        NSLog(@"[ OcO ][ URL ] %@", url);
        NSLog(@"[ OcO ][ PARAMS ] %@", params);
        NSLog(@"[ OcO ][ RETRY] %@", @(retryTimes));
        NSLog(@"[ OcO ][ TIMEOUT ] %@", @(self.manager.requestSerializer.timeoutInterval));
    }
    
    retryTimes--;
    [self.manager POST:url parameters:params constructingBodyWithBlock:body success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [self callback:task result:responseObject command:command];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (retryTimes < 1) {
            [self callback:task result:[NSString stringWithFormat:@"%@", error] command:command];
            return;
        }
        [self POST:url params:params body:body retryTimes:retryTimes command:command];
    }];
}

// 发送 DELETE 请求
- (void)DELETE:(NSString *)url params:(NSDictionary *)params retryTimes:(NSInteger)retryTimes command:(CDVInvokedUrlCommand *)command
{
    if (self.debugMode) {// 调试信息
        NSLog(@"[ OcO ][ NETWORK ] Request sending with arguments.");
        NSLog(@"[ OcO ][ FRAMEWORK ] SYSTEM");
        NSLog(@"[ OcO ][ METHOD ] DELETE");
        NSLog(@"[ OcO ][ URL ] %@", url);
        NSLog(@"[ OcO ][ PARAMS ] %@", params);
        NSLog(@"[ OcO ][ RETRY] %@", @(retryTimes));
        NSLog(@"[ OcO ][ TIMEOUT ] %@", @(self.manager.requestSerializer.timeoutInterval));
    }
    
    retryTimes--;
    [self.manager DELETE:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [self callback:task result:responseObject command:command];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (retryTimes < 1) {
            [self callback:task result:[NSString stringWithFormat:@"%@", error] command:command];
            return;
        }
        [self DELETE:url params:params retryTimes:retryTimes command:command];
    }];
}

// 处理请求结果并回调到 Web
- (void)callback:(NSURLSessionTask *)task result:(id)result command:(CDVInvokedUrlCommand *)command
{
    // 请求结果状态码
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
    NSInteger statusCode = [response statusCode];
    
    if (statusCode == 200 && [result isKindOfClass:[NSDictionary class]]) {
        if (self.debugMode) {// 调试信息
            NSLog(@"[ OcO ][ NETWORK ] Request success.");
        }
        [self sendStatus:CDVCommandStatus_OK message:@{@"statusCode": @(statusCode), @"result": result} command:command];
    } else {
        if (self.debugMode) {// 调试信息
            NSLog(@"[ OcO ][ NETWORK ] Request failure.");
        }
        [self sendStatus:CDVCommandStatus_ERROR message:@{@"statusCode": @(statusCode), @"result": result} command:command];
    }
}


#pragma mark - Cordova Plugin Methods (JavaScript -> Objective-C)

// Web 调用 -> 调试模式开关
- (void)debug_mode:(CDVInvokedUrlCommand *)command
{
    [self.commandDelegate runInBackground:^{
        self.debugMode = ([command.arguments[0] isEqual:@0]) ? NO : YES;
        
        [self debugLog:@"debug_mode run", @"Debug Mode Open", nil];
    }];
}

// Web 调用 -> 发送 GET 请求
- (void)request_get:(CDVInvokedUrlCommand *)command
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.manager.requestSerializer.timeoutInterval = [command.arguments[2] integerValue]/1000;
        [self GET:command.arguments[0] params:command.arguments[1] retryTimes:[command.arguments[3] integerValue] command:command];
    });
}

// Web 调用 -> 发送 POST 请求
- (void)request_post:(CDVInvokedUrlCommand *)command
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.manager.requestSerializer.timeoutInterval = [command.arguments[2] integerValue]/1000;
        [self POST:command.arguments[0] params:command.arguments[1] retryTimes:[command.arguments[3] integerValue] command:command];
    });
}

// Web 调用 -> 发送 POST 请求带参数
- (void)request_post_file:(CDVInvokedUrlCommand *)command
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.manager.requestSerializer.timeoutInterval = [command.arguments[2] integerValue]/1000;
        [self POST:command.arguments[0] params:command.arguments[1] body:^(id<AFMultipartFormData> formData) {
            
        } retryTimes:[command.arguments[3] integerValue] command:command];
    });
}

// Web 调用 -> 发送 DELETE 请求
- (void)request_delete:(CDVInvokedUrlCommand *)command
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.manager.requestSerializer.timeoutInterval = [command.arguments[2] integerValue]/1000;
        [self DELETE:command.arguments[0] params:command.arguments[1] retryTimes:[command.arguments[3] integerValue] command:command];
    });
}


#pragma mark - Cordova Plugin Methods (Objective-C -> JavaScript)


#pragma mark - CDVPlugin Methods

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
