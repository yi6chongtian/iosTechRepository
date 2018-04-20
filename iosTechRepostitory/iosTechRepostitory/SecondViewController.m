//
//  SecondViewController.m
//  iosTechRepostitory
//
//  Created by tang on 2018/4/11.
//  Copyright © 2018年 tang. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)dealloc{
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self request2];
}

- (void)request2{
    TZBNetRequest *netRequest = [TZBNetRequest requestGetWithUrlString:@"https://www.zhibo8.cc" params:nil successBlock:^(NSInteger errCode, id responseObject) {
        NSLog(@"%@",self.view);
        if([responseObject isKindOfClass:[NSData class]]){
            NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"%@",string);
        }
        NSLog(@"%@",responseObject);
    } failureBlock:^(NSError *error) {
        NSLog(error);
    }];
    //netRequest.responseSerializerType = TZBResponseSerializerTypeHTTP;
    [netRequest startRequest];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
