//
//  ViewController.m
//  iosTechRepostitory
//
//  Created by tang on 2018/1/14.
//  Copyright © 2018年 tang. All rights reserved.
//

#import "ViewController.h"
#import "TZBNetRequest.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //[self request2];
    //[self request];
    [self downloadFile];
}

- (void)request{
        NSURLSessionDataTask *task = [TZBNetTool getWithUrlString:@"https://api.douban.com/v2/movie/in_theaters" params:nil downloadProgress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"%@",responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@",error);
        }];
        if(task.state == NSURLSessionTaskStateRunning){
            [task cancel];
        }
}

- (void)downloadFile{
    //http://dl154.80s.im:920/1711/[行尸走肉][第八季]第01集/[行尸走肉][第八季]第01集_hd.mp4
    TZBNetRequest *request = [[TZBNetRequest alloc] initWithDownloadFileWithUrlString:@"http://m4.pc6.com/xuh3/revealapp.dmg" params:nil downloadProgressBlock:^(NSProgress *downloadProgress) {
        NSLog(@"%f",1.0 *downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
    } downloadDestinationBlock:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
        NSLog(@"targetPath:%@",targetPath);
        NSLog(@"fullPath:%@",fullPath);
        return [NSURL fileURLWithPath:fullPath];
    } downloadCompleteBlock:^(NSURLResponse *response, NSURL *filepath, NSError *error) {
        NSLog(@"%@",filepath);

    }];
    [request startRequest];
}




@end
