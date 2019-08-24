//
//  SettingTableViewController.m
//  SMTest
//
//  Created by ueMac on 2019/8/3.
//  Copyright © 2019 ueMac. All rights reserved.
//

#import "SettingTableViewController.h"
#import "ManagerMenuTableViewController.h"
#import "BillTableViewController.h"

@interface SettingTableViewController ()
@property (nonatomic, strong) NSMutableArray *data;
@end

@implementation SettingTableViewController

//- (void)viewDidAppear:(BOOL)animated{
//    self.hidesBottomBarWhenPushed = YES;
//}
//
//-(void)viewDidDisappear:(BOOL)animated {
//    self.hidesBottomBarWhenPushed = NO;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.data = [[NSMutableArray alloc] init];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.data addObject:@"管理菜品"];
    [self.data addObject:@"账单管理"];
    [self.data addObject:@"设置背景图"];
    [self.data addObject:@"设置启动图"];
    self.tableView.tableHeaderView = [UIView new];
    self.tableView.tableFooterView = [UIView new];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ide" forIndexPath:indexPath];
    [cell.textLabel setText:[self.data objectAtIndex:indexPath.row]];
    [cell.textLabel setTextColor:[UIColor lightGrayColor]];
    [cell.textLabel setFont:[UIFont systemFontOfSize:12]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
        {
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            ManagerMenuTableViewController *menu = [story instantiateViewControllerWithIdentifier:@"ManagerMenuTableViewController"];
            menu.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:menu animated:YES];
        }
            break;
        case 1:
        {
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            BillTableViewController *bill = [story instantiateViewControllerWithIdentifier:@"BillTableViewController"];
            bill.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:bill animated:YES];
        }
            break;
        case 2:
        {
            
        }
            break;
        default:
            break;
    }
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
