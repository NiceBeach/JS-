//
//  ViewController.m
//  demo
//
//  Created by hlznj on 2017/9/25.
//  Copyright © 2017年 HLZNJ. All rights reserved.
//

#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSObjectDelegate <JSExport>

- (void)callCamera;
- (void)share:(NSString *)shareString;

@end

@interface ViewController ()<UIWebViewDelegate,JSObjectDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) JSContext *jsContext;

@end

@implementation ViewController

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _webView.delegate = self;
    }
    return _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.webView];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"webTest" withExtension:@"html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.jsContext[@"NBBridge"] = self;
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        NSLog(@"异常信息%@",exception);
    };
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *url = request.URL.absoluteString;
    if ([url rangeOfString:@"toyun://"].location != NSNotFound) {
        NSLog(@"%@",url);
        return NO;
    }
    return YES;
}

- (void)callCamera {
    NSLog(@"%s",__func__);
    JSValue *picCallback = self.jsContext[@"picCallback"];
    [picCallback callWithArguments:nil];
}

- (void)share:(NSString *)shareString {
    NSLog(@"%s",__func__);
    JSValue *shareCallback = self.jsContext[@"shareCallback"];
    [shareCallback callWithArguments:nil];
}

@end
