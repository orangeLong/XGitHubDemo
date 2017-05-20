//
//  XHomeViewController.m
//  XGitHubDemo
//
//  Created by LiX i n long on 2017/5/20.
//  Copyright © 2017年 LiX i n long. All rights reserved.
//

#import "XHomeViewController.h"

//manager
#import "XAPIManager.h"
//3rd
#import <SDWebImage/UIImageView+WebCache.h>
//model
#import "XUserViewModel.h"

static NSString *const languageKeyPath = @"userlanguage";

@interface XHomeViewController ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource; /**< 数据源*/

@end

@implementation XHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - <UITableViewDelegate, UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    XUserViewModel *user = self.dataSource[indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:user.userImagePath] placeholderImage:[UIImage imageNamed:@"icon"]];
    cell.textLabel.text = user.userName;
    cell.detailTextLabel.text = user.userlanguage;
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    for (XUserViewModel *user in self.dataSource) {
        [user removeObserver:self forKeyPath:languageKeyPath];
    }
    [self.dataSource removeAllObjects];
    [self.tableView reloadData];
    [[XAPIManager shardInstance] searchUserinfoWithKey:searchText callback:^(id obj) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            id results = obj[@"items"];
            if (results && [results isKindOfClass:[NSArray class]]) {
                for (id item in results) {
                    if (item && [item isKindOfClass:[NSDictionary class]]) {
                        XUserViewModel *user = [[XUserViewModel alloc] initWithDic:item];
                        [user addObserver:self forKeyPath:languageKeyPath options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
                        [self.dataSource addObject:user];
                    }
                }
            }
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - superMethod

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    XUserViewModel *user = (XUserViewModel *)object;
    NSInteger index = [self.dataSource indexOfObject:user];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - setter && getter

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
