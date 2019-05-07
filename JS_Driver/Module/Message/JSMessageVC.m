//
//  JSMessageVC.m
//  JS_Driver
//
//  Created by Jason_zyl on 2019/3/6.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "JSMessageVC.h"

@interface JSMessageVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation JSMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageHomeTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageHomeTabCell"];
    return cell;
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
@implementation MessageHomeTabCell

@end
