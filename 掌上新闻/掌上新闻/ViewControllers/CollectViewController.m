//
//  CollectViewController.m
//  网易新闻
//
//  Created by qianfeng on 15/10/7.
//  Copyright (c) 2015年 XieRenQiang. All rights reserved.
//

#import "CollectViewController.h"
#import "CollectTableViewCell.h"

static NSString *CELLID = @"cellID";
@interface CollectViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView    *tableView;

@property (nonatomic) NSMutableArray *selectIndexPathArray;
@end

@implementation CollectViewController
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H - 64) style:(UITableViewStylePlain)];
        _tableView.dataSource = self;
        _tableView.delegate   = self;
        [_tableView registerNib:[UINib nibWithNibName:@"CollectTableViewCell" bundle:nil] forCellReuseIdentifier:CELLID];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
    item.title = @"返回";
    self.navigationItem.backBarButtonItem = item;
    
    [self initData];
    [self.view addSubview:self.tableView];
    [self createEditButtonItem];
}
#pragma mark - 右BarButton
- (void)createEditButtonItem{
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonClickAction:)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)rightBarButtonClickAction:(UIBarButtonItem*)item
{
    //_tableView.isEditing 判断表格是否处在编辑状态
    if (_tableView.isEditing) {
        //setEditing：YES让表处于编辑状态
        [_tableView setEditing:NO animated:YES];
        self.navigationItem.rightBarButtonItem.title = @"删除";
        [self deleteAllSelectCell];
    }else{
        [_tableView setEditing:YES animated:YES];
        self.navigationItem.rightBarButtonItem.title = @"完成";
        [_selectIndexPathArray removeAllObjects];
    }
}

- (void)deleteAllSelectCell{
    //删除数据库
    NSMutableArray *RArr = [NSMutableArray array];
    for (NSIndexPath *indexPath in self.selectIndexPathArray) {
        DataModel *model = [[self.dataArray objectAtIndex:indexPath.row] objectAtIndex:0];
        [[LimitDBManager sharedInstance] deleteNewInfo:model type:COLLECT];
        [RArr addObject:[self.dataArray objectAtIndex:indexPath.row]];
    }
    //删除数据源
    [self.dataArray removeObjectsInArray:RArr];
    //删除cell
    [self.tableView deleteRowsAtIndexPaths:_selectIndexPathArray withRowAnimation:UITableViewRowAnimationLeft];
    [self.tableView reloadData];
}
#pragma mark - 初始化
- (void)initData{
    self.selectIndexPathArray = [NSMutableArray array];
    NSArray *Array = [[LimitDBManager sharedInstance] readNewInfoList:COLLECT];

    self.dataArray = [NSMutableArray arrayWithArray:Array];
}

#pragma mark -
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CollectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID forIndexPath:indexPath];
    
    DataModel *model = [[self.dataArray objectAtIndex:indexPath.row] objectAtIndex:0];
    
    [cell updateWithModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //选中某一行时调用
    [_selectIndexPathArray addObject:indexPath];
    
    if (!tableView.isEditing) {
        DataModel *model = [[self.dataArray objectAtIndex:indexPath.row] objectAtIndex:0];
        DetailViewController *detail = [[DetailViewController alloc]init];
        detail.dataModel = model;
        detail.type = [[self.dataArray objectAtIndex:indexPath.row] objectAtIndex:1];
        NSString *url = nil;
        if ([self.title isEqualToString:@"视频"]) {
            url = [NSString stringWithFormat:kvideo,model.id];
        }else{
            url = [NSString stringWithFormat:kdetailUrl,model.id];
        }
        
        [[NetDataEngine sharedInstance] requestNewsFrom:url success:^(id responsData) {
            NSDictionary *resultDic = responsData[@"result"];
            if ([self.title isEqualToString:@"视频"]) {
                detail.webUrl = resultDic[@"v_url"];
            }else{
                detail.webUrl = resultDic[@"art_url"];
            }
            
            [self.navigationController pushViewController:detail animated:NO];
            CATransition *transition = [CATransition animation];
            transition.type = @"rippleEffect";
            transition.delegate = self;
            [self.navigationController.view.layer addAnimation:transition forKey:nil];
        } failed:^(NSError *error) {
            NSLog(@"%@",error.description);
        }];
    }
}

#pragma mark - 删除调用代理
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消选中时调用的方法
    [_selectIndexPathArray removeObject:indexPath];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (void)viewWillAppear:(BOOL)animated{
    [self initData];
    [self.tableView reloadData];
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

@end
