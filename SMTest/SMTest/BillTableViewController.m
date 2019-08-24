//
//  BillTableViewController.m
//  SMTest
//
//  Created by MacMini2 on 2019/8/19.
//  Copyright © 2019 ueMac. All rights reserved.
//

#import "BillTableViewController.h"
#import "BGFMDB.h"
#import "BillModel.h"

@interface BillTableViewController ()
@property (nonatomic, strong) NSMutableDictionary *DataDict;
@property (nonatomic, strong) NSMutableArray *keys;
@end

@implementation BillTableViewController

- (NSMutableArray *)keys
{
    if (_keys == nil)
    {
        _keys = [[NSMutableArray alloc] init];
    }
    return _keys;
}

- (NSMutableDictionary *)DataDict
{
    if (_DataDict == nil)
    {
        _DataDict = [[NSMutableDictionary alloc] init];
    }
    return _DataDict;
}

- (void)loadData
{
    NSArray *arr = [BillModel bg_findAll:@"billTable"];
    [self.DataDict removeAllObjects];
    for (BillModel *model in arr)
    {
        NSString *date = [self getStringFromDate:model.date];
        NSMutableArray *data = [self.DataDict objectForKey:date];
        if (data == nil)
        {
            data = [[NSMutableArray alloc] init];
            [self.DataDict setObject:data forKey:date];
        }
        [data addObject:model];
    }
    [self.keys removeAllObjects];
    [self.keys addObjectsFromArray:self.DataDict.allKeys];
    [self.keys sortUsingComparator:^NSComparisonResult(NSString * obj1, NSString * obj2) {
        if ([obj1 integerValue] > [obj2 integerValue])
        {
            return NSOrderedDescending;
        }
        else
        {
            return NSOrderedAscending;
        }
    }];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}

-(NSString *)getStringFromDate:(NSDate *)aDate
{
    NSDateFormatter *dateFormater=[[NSDateFormatter alloc]init];
    [dateFormater setDateFormat:@"yyyy-MM-dd"];//需转换的格式
    NSString *dateStr = [dateFormater stringFromDate:aDate];
    return dateStr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableHeaderView = [UIView new];
    self.tableView.tableFooterView = [UIView new];
    [self.navigationController.navigationBar setTranslucent:NO];
    self.title = @"账单管理";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return self.keys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    NSArray *arr = [self.DataDict objectForKey:[self.keys objectAtIndex:section]];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ide" forIndexPath:indexPath];
    
    NSArray *arr = [self.DataDict objectForKey:[self.keys objectAtIndex:indexPath.section]];
    BillModel *model = [arr objectAtIndex:indexPath.row];
    
    // Configure the cell...
    UILabel *timeLabel = [cell.contentView viewWithTag:110];
    if (timeLabel == nil)
    {
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 200, 20)];
        [timeLabel setBackgroundColor:[UIColor clearColor]];
        [timeLabel setFont:[UIFont systemFontOfSize:12]];
        [timeLabel setTextColor:[UIColor blackColor]];
        [timeLabel setTag:110];
        [cell.contentView addSubview:timeLabel];
    }
    [timeLabel setText:model.date.description];
    
    UILabel *priceLabel = [cell.contentView viewWithTag:111];
    if (priceLabel == nil)
    {
        priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 15, 100, 20)];
        [priceLabel setBackgroundColor:[UIColor clearColor]];
        [priceLabel setFont:[UIFont systemFontOfSize:12]];
        [priceLabel setTextColor:[UIColor blackColor]];
        [priceLabel setTag:111];
        [cell.contentView addSubview:priceLabel];
    }
    [priceLabel setText:[NSString stringWithFormat:@"总价 : %.2f (元)",model.allPrice]];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"%@        今日账单总价：%.2f",[self.keys objectAtIndex:section],[self getTodayBill:section]];
}

- (CGFloat)getTodayBill:(NSInteger)section
{
    NSArray *arr = [self.DataDict objectForKey:[self.keys objectAtIndex:section]];
    CGFloat price = 0;
    for (BillModel *model in arr)
    {
        price += [model allPrice];
    }
    return price;
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
