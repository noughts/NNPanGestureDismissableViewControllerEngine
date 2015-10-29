//
//  TableViewController.m
//  NNPanGestureDismissableViewControllerEngine
//
//  Created by noughts on 2015/10/29.
//  Copyright © 2015年 Koichi Yamamoto. All rights reserved.
//

#import "TableViewController.h"
#import <NBULog.h>

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NBULogInfo(@"%@", NSStringFromSelector(_cmd));
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NBULogInfo(@"%@", NSStringFromSelector(_cmd));
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NBULogInfo(@"%@", NSStringFromSelector(_cmd));
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NBULogInfo(@"%@", NSStringFromSelector(_cmd));
}


-(IBAction)close:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}




#pragma mark - Table view data source


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"click");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
