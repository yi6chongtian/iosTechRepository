//
//  YZH5BaseViewController.m
//  YZFFMain
//
//  Created by tangzhibiao on 2018/10/31.
//  Copyright © 2018 Yingzi. All rights reserved.
//

#import "YZH5BaseViewController.h"
#import <WebViewJavascriptBridge/WebViewJavascriptBridge.h>

#define kActionKey   @"action"
#define kCallbackKey @"callback"
#define kDataKey        @"data"

@interface YZH5BaseViewController ()

@property (nonatomic,strong) WKWebView *webView;

@property (nonatomic,strong) WebViewJavascriptBridge* bridge;


@end

@implementation YZH5BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self registerJSHandler];

    [self initUI];
    
}

//注册JS脚本 ---》JS调用OC
- (void)registerJSHandler{
    //获取token
    [self.bridge registerHandler:@"getToken" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *token = @"dfdafdgkdglads";
        NSString *jsonStr = [self transToJSONString:@{@"token":token}];
        responseCallback(/*jsonStr*/@{@"token":token});
    }];
    //关闭网页
    [self.bridge registerHandler:@"closeWeb" handler:^(id data, WVJBResponseCallback responseCallback) {
        
    }];
}

#pragma mark - UI

- (void)initUI{
    [self.view addSubview:self.webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setTitle:@"返回" forState:UIControlStateNormal];
    closeButton.backgroundColor = UIColor.blueColor;
    [[closeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    [self.view addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(20);
        make.width.height.equalTo(@100);
    }];
    
    UIButton *callJSBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [callJSBtn setTitle:@"调用JS" forState:UIControlStateNormal];
    callJSBtn.backgroundColor = UIColor.blueColor;
    [[callJSBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self.bridge callHandler:@"registerAction" data:@{@"uid":@"123",@"pwd":@"123"}/*[self transToJSONString:@{@"uid":@"123",@"pwd":@"123"}]*/ responseCallback:^(id responseData) {
            NSLog(@"responseData:%@",responseData);
        }];
    }];
    [self.view addSubview:callJSBtn];
    [callJSBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.bottom.offset(-44);
        make.width.height.equalTo(@100);
    }];
    
    [self loadPage];
    
   
}

- (void)loadPage{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"ExampleApp" withExtension:@"html"];//[NSURL URLWithString:@""];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

#pragma mark - UIWebView

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    //    DLOG(@"msg = %@ frmae = %@",message,frame);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - Private
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

- (NSString *)transToJSONString:(NSDictionary *)dict
{
    NSData *paramsJSONData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    return [[NSString alloc] initWithData:paramsJSONData encoding:NSUTF8StringEncoding];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark  - Getter

- (WKWebView *)webView{
    if(_webView == nil){
        _webView = [WKWebView new];
        _webView.UIDelegate = self;
    }
    return _webView;
}

- (WebViewJavascriptBridge *)bridge{
    if(_bridge == nil){
        _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
        [_bridge setWebViewDelegate:self];
    }
    return _bridge;
}



@end
