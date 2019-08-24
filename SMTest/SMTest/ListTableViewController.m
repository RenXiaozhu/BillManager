//
//  ListTableViewController.m
//  SMTest
//
//  Created by ueMac on 2019/8/3.
//  Copyright © 2019 ueMac. All rights reserved.
//

#import "ListTableViewController.h"
#import "ProductModel.h"
#import "BillModel.h"

@interface ListTableViewController ()
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) BillModel *todayBill;
@end

@implementation ListTableViewController

- (NSMutableArray *)data
{
    if (_data == nil)
    {
        _data = [[NSMutableArray alloc] init];
    }
    return _data;
}

- (BillModel *)todayBill
{
    if (_todayBill == nil)
    {
        _todayBill = [[BillModel alloc] init];
    }
    return _todayBill;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.tableHeaderView = [UIView new];
    self.tableView.tableFooterView = [UIView new];

    __block ListTableViewController *weakSelf = (ListTableViewController *)self;
    if (@available(iOS 10.0, *))
    {
        [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
            [weakSelf UpdateBill];
        }];
    }
    else
    {
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(UpdateBill) userInfo:nil repeats:YES];
    }
    
    
    UIButton *addProduct = [UIButton buttonWithType:UIButtonTypeCustom];
    [addProduct setTitle:@"下单" forState:UIControlStateNormal];
    [addProduct addTarget:self action:@selector(saveBill) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithCustomView:addProduct]];
}

- (void)saveBill
{
    NSString *msg = @"";
    [self.todayBill.list removeAllObjects];
    for (ProductModel *model in self.data)
    {
        if (model.count > 0)
        {
            [self.todayBill.list addObject:model];
            msg = [msg stringByAppendingString:model.name?model.name:@""];
            msg = [msg stringByAppendingString:@"   "];
            msg = [msg stringByAppendingString:[NSString stringWithFormat:@"%d",model.count]];
            msg = [msg stringByAppendingString:@"\n"];
        }
    }
    
    
    __block ListTableViewController *weakSelf = (ListTableViewController *)self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"订单" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.todayBill.bg_tableName = @"billTable";
        [weakSelf.todayBill bg_save];
        
        weakSelf.todayBill = nil;
        [weakSelf resetData];
        [weakSelf.tableView reloadData];
    }];
    [alertController addAction:action];
    [self.navigationController presentViewController:alertController animated:YES completion:^{
        
    }];
    
    
}

- (void)UpdateBill
{
    NSString *nowdate = [self getStringFromDate:[NSDate date]];
    NSString *oldDate = [self getStringFromDate:self.todayBill.date];
    if (![nowdate isEqualToString:oldDate])
    {
        self.todayBill = nil;
    }
}

-(NSString *)getStringFromDate:(NSDate *)aDate
{
    NSDateFormatter *dateFormater=[[NSDateFormatter alloc]init];
    [dateFormater setDateFormat:@"yyyy-mm-dd"];//需转换的格式
    NSString *dateStr = [dateFormater stringFromDate:aDate];
    return dateStr;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)loadData
{
    [self.data removeAllObjects];
    [self.todayBill.list removeAllObjects];
    
    NSArray *arr = [ProductModel bg_findAll:@"MenuList"];
    [self.data addObjectsFromArray:arr];
    
    NSArray *todayList = [ProductModel bg_find:@"MenuList" type:bg_createTime dateTime:[self getStringFromDate:self.todayBill.date]];
    [self.todayBill.list addObjectsFromArray:todayList];
    [self.tableView reloadData];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ide" forIndexPath:indexPath];
    ProductModel *model = [self.data objectAtIndex:indexPath.row];
    if (cell)
    {
        UIImageView *icon = [cell.contentView viewWithTag:110];
        if (icon == nil)
        {
            icon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 60, 60)];
            [icon setTag:110];
            icon.layer.masksToBounds = YES;
            icon.layer.cornerRadius = 5;
            [cell.contentView addSubview:icon];
        }
        [icon setImage:model.icon];
        
        UILabel *title = [cell.contentView viewWithTag:111];
        if (title == nil)
        {
            title = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, 100, 20)];
            [title setFont:[UIFont systemFontOfSize:12]];
            [title setTextColor:[UIColor blackColor]];
            [title setTextAlignment:NSTextAlignmentLeft];
            [cell.contentView addSubview:title];
        }
        [title setText:model.name];
        
        UILabel *price = [cell.contentView viewWithTag:112];
        if (price == nil)
        {
            price = [[UILabel alloc] initWithFrame:CGRectMake(90, 35, 100, 15)];
            [price setFont:[UIFont systemFontOfSize:12]];
            [price setTextColor:[UIColor redColor]];
            [price setTextAlignment:NSTextAlignmentLeft];
            [cell.contentView addSubview:price];
        }
        [price setText:[NSString stringWithFormat:@"%.2f (元)",model.price]];
        
        UILabel *percent = [cell.contentView viewWithTag:113];
        if (percent == nil)
        {
            percent = [[UILabel alloc] initWithFrame:CGRectMake(90, 55, 100, 15)];
            [percent setFont:[UIFont systemFontOfSize:12]];
            [percent setTextColor:[UIColor redColor]];
            [percent setTextAlignment:NSTextAlignmentLeft];
            [cell.contentView addSubview:percent];
        }
        [percent setText:[NSString stringWithFormat:@"%.2f (元)",model.percent]];
        
        UIButton *delBtn = [cell.contentView viewWithTag:indexPath.row+10];
        if (delBtn == nil)
        {
            delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [delBtn setFrame:CGRectMake(200, 25, 30, 30)];
            [delBtn setTitle:@"-" forState:UIControlStateNormal];
            [delBtn addTarget:self action:@selector(removeCount:) forControlEvents:UIControlEventTouchUpInside];
            [delBtn setTag:indexPath.row + 10];
            [delBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [cell.contentView addSubview:delBtn];
        }
        
        UITextField *countField = [cell.contentView viewWithTag:indexPath.row + 30];
        if (countField == nil)
        {
            countField = [[UITextField alloc] initWithFrame:CGRectMake(240, 25, 40, 30)];
            [countField setTag:indexPath.row +30];
            [countField setTextColor:[UIColor blackColor]];
            [countField setTextAlignment:NSTextAlignmentCenter];
            countField.layer.masksToBounds = YES;
            countField.layer.cornerRadius = 3;
            countField.layer.borderColor = [UIColor yellowColor].CGColor;
            countField.layer.borderWidth = 1;
            [cell.contentView addSubview:countField];
        }
        [countField setText:[NSString stringWithFormat:@"%d",model.count]];
        
        UIButton *addBtn = [cell.contentView viewWithTag:indexPath.row+20];
        if (addBtn == nil)
        {
            addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [addBtn setFrame:CGRectMake(290, 25, 30, 30)];
            [addBtn setTitle:@"+" forState:UIControlStateNormal];
            [addBtn addTarget:self action:@selector(addCount:) forControlEvents:UIControlEventTouchUpInside];
            [addBtn setTag:indexPath.row + 20];
            [addBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [cell.contentView addSubview:addBtn];
        }
        
    }
    return cell;
}

- (void)addCount:(UIButton *)btn
{
    ProductModel *model = [self.data objectAtIndex:btn.tag - 20];
    model.count += 1;
    [self.tableView reloadData];
}

- (void)removeCount:(UIButton *)btn
{
    ProductModel *model = [self.data objectAtIndex:btn.tag - 10];
    if (model.count == 0)
    {
        return;
    }
    model.count -= 1;
    [self.tableView reloadData];
}

- (void)resetData
{
    for (ProductModel *model in self.data)
    {
        model.count = 0;
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
