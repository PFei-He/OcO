//
//  Copyright (c) 2018 saturn.xyz
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

#import "OcONativeViewController.h"
#import <AFNetworking/AFNetworking.h>

@interface OcONativeViewController ()

@end

@implementation OcONativeViewController

#pragma mark - Views Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


#pragma mark - Events Management

- (IBAction)closeMe:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)requestNetwork:(id)sender
{
    // 创建网络请求
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 添加请求超时间隔（30秒）
    manager.requestSerializer.timeoutInterval = 30;
    
    // 添加 text/html 响应类型
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    // 发送GET请求
    [manager GET:@"http://www.weather.com.cn/data/sk/101010100.html" parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        // 请求结果状态码
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSInteger statusCode = [response statusCode];
        NSLog(@"%ld", statusCode);
        
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        // 请求结果状态码
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSInteger statusCode = [response statusCode];
        NSLog(@"%ld", statusCode);
        
        NSLog(@"%@", error);
    }];
}


#pragma mark - Memory Managements

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
