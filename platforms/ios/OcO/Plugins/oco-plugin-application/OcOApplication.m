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

#import "OcOApplication.h"

// 调试打印
#define DLog(args...)\
[self debugLog:args, nil]

@interface OcOApplication ()

// 调试模式
@property (nonatomic, assign) BOOL debugMode;

@end

@implementation OcOApplication

#pragma mark - Private Methods

// 打印调试信息
- (void)debugLog:(NSString *)strings, ...
{
    if (self.debugMode) {
        NSLog(@"[ OcO ][ APPLICATION ]%@.", strings);
        va_list list;
        va_start(list, strings);
        while (strings != nil) {
            NSString *string = va_arg(list, NSString *);
            if (!string) break;
            NSLog(@"[ OcO ][ APPLICATION ]%@.", string);
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
        DLog([NSString stringWithFormat:@"[ FUNCTION ] '%@' run", NSStringFromSelector(_cmd)], @" Debug Mode Open");
    }];
}

// Web 调用 -> 加载应用信息
- (void)load_information:(CDVInvokedUrlCommand *)command
{
    [self.commandDelegate runInBackground:^{
        DLog([NSString stringWithFormat:@"[ FUNCTION ] '%@' run", NSStringFromSelector(_cmd)]);
        [self sendStatus:CDVCommandStatus_OK message:@{@"currentLanguage": [[NSUserDefaults standardUserDefaults] valueForKey:@"OcO_CURRENT_LANGUAGE"] ? [[NSUserDefaults standardUserDefaults] valueForKey:@"OcO_CURRENT_LANGUAGE"] : @"zh_CN", @"currentVersion": @"1.0.0"}
                 command:command];
    }];
}

// // Web 调用 -> 更换语言环境
- (void)change_language:(CDVInvokedUrlCommand *)command
{
    [self.commandDelegate runInBackground:^{
        DLog([NSString stringWithFormat:@"[ FUNCTION ] '%@' run", NSStringFromSelector(_cmd)]);
        [[NSUserDefaults standardUserDefaults] setValue:command.arguments[0] forKey:@"OcO_CURRENT_LANGUAGE"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
}

@end
