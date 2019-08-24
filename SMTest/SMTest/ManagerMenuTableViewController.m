//
//  ManagerTableViewController.m
//  SMTest
//
//  Created by 王傲 on 2019/8/4.
//  Copyright © 2019 ueMac. All rights reserved.
//

#import "ManagerMenuTableViewController.h"
#import "AddMenuViewController.h"
#import "ProductModel.h"
#import "BGFMDB.h"
@interface ManagerMenuTableViewController ()
@property (nonatomic, strong) NSMutableArray *data;
@end

@implementation ManagerMenuTableViewController

- (NSMutableArray *)data
{
    if (_data == nil)
    {
        _data = [[NSMutableArray alloc] init];
    }
    return _data;
}

- (void)loadData
{
    
    NSArray *arr = [ProductModel bg_findAll:@"MenuList"];
    [self.data removeAllObjects];
    [self.data addObjectsFromArray:arr];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"列表";
    self.tableView.tableHeaderView = [UIView new];
    self.tableView.tableFooterView = [UIView new];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:btn]];
    
    UIButton *add = [UIButton buttonWithType:UIButtonTypeCustom];
    [add setTitle:@"添加菜品" forState:UIControlStateNormal];
    [add addTarget:self action:@selector(goToAddController) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:add]];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)goToAddController
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    AddMenuViewController *menu = [story instantiateViewControllerWithIdentifier:@"AddMenuViewController"];
    [self.navigationController pushViewController:menu animated:YES];
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
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
            [icon setImage:model.icon];
            [icon setTag:110];
            icon.layer.masksToBounds = YES;
            icon.layer.cornerRadius = 5;
            [cell.contentView addSubview:icon];
        }
        
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
        
    }
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.data removeObjectAtIndex:indexPath.row];
        
        [tableView beginUpdates];
        [tableView reloadData];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
        [ProductModel bg_delete:@"MenuList" row:indexPath.row + 1];
    }
}


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
