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

#import <Cordova/CDV.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLPlugin : CDVPlugin

/**
 回调到 Web 端
 @param status 响应的状态
 @param message 回调的内容
 @param command 响应的标记
 */
- (void)sendStatus:(CDVCommandStatus)status message:(nullable NSObject *)message command:(CDVInvokedUrlCommand *)command;

/**
 回调到 Web 端
 @param status 响应的状态
 @param message 回调的内容
 @param yesOrNo 是否保持响应状态
 @param command 响应的标记
 */
- (void)sendStatus:(CDVCommandStatus)status message:(nullable NSObject *)message keepCallback:(BOOL)yesOrNo command:(CDVInvokedUrlCommand *)command;

@end

NS_ASSUME_NONNULL_END
