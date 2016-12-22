//
//  XZTableViewController.m
//  XZLinkageView
//
//  Created by codeLocker on 2016/12/21.
//  Copyright © 2016年 codeLocker. All rights reserved.
//

#import "XZTableViewController.h"
#import "MTModel.h"
#import "NSObject+Property.h"
#import <Masonry/Masonry.h>
#import "XZLeftCell.h"

@interface XZTableViewController ()<UITableViewDelegate,UITableViewDataSource>{

    
    BOOL _isScrollDown;
}
/** 分类*/
@property (nonatomic, strong) NSMutableArray *categoryData;

@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *rightTableView;

@end

@implementation XZTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self loadData];
    
    [self.view addSubview:self.leftTableView];
    [self.view addSubview:self.rightTableView];
    
    [self layout];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Load_Data
- (void)loadData{

    NSString *path = [[NSBundle mainBundle] pathForResource:@"meituan" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSArray *foods = dic[@"data"][@"food_spu_tags"];
    
    for (NSDictionary *dic in foods) {
        
        CategoryModel *model = [CategoryModel objectWithDictionary:dic];
        [self.categoryData addObject:model];
        
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    if (tableView == self.rightTableView) {
        
        return self.categoryData.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (tableView == self.leftTableView) {
    
        return self.categoryData.count;
    }
    
    CategoryModel *model = self.categoryData[section];
    
    return model.spus.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    if (tableView == self.rightTableView) {
        
        CategoryModel *model = self.categoryData[section];
        
        return model.name;
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (tableView == self.leftTableView) {
        
        XZLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XZLeftCell class])];
        CategoryModel *model = self.categoryData[indexPath.row];
        cell.nameLab.text = model.name;
        
        return cell;
    }else{
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
        CategoryModel *model = self.categoryData[indexPath.section];
        FoodModel *foodModel = model.spus[indexPath.row];
        cell.textLabel.text = foodModel.name;
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (tableView == self.leftTableView) {
        
        [self.leftTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [self.rightTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.row] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section{

    if (tableView == self.rightTableView && _isScrollDown && self.rightTableView.dragging) {
    
        [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:section+1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{

    if (tableView == self.rightTableView && !_isScrollDown && self.rightTableView.dragging) {
        
        [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:section inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    static CGFloat lastOffset = 0;
    
    if (self.rightTableView == scrollView) {
        
        _isScrollDown = lastOffset < scrollView.contentOffset.y;
        lastOffset = scrollView.contentOffset.y;
    }
}

#pragma mark - Layout
- (void)layout{

    [self.leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).offset(64);
        make.bottom.equalTo(self.view);
        make.width.mas_equalTo(80.0f);
    }];
    
    [self.rightTableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.leftTableView.mas_right);
        make.top.equalTo(self.view).offset(64);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

#pragma mark - Setter && Getter
- (NSMutableArray *)categoryData{

    if (!_categoryData) {
        
        _categoryData = [NSMutableArray array];
    }
    return _categoryData;
}

- (UITableView *)leftTableView{

    if (!_leftTableView) {
        
        _leftTableView = [[UITableView alloc] init];
        _leftTableView.dataSource= self;
        _leftTableView.delegate = self;
        _leftTableView.rowHeight = 55.0f;
        _leftTableView.tableFooterView = [UIView new];
        _leftTableView.separatorColor = [UIColor clearColor];
        _leftTableView.showsVerticalScrollIndicator = NO;
        _leftTableView.showsHorizontalScrollIndicator = NO;
        [_leftTableView registerClass:[XZLeftCell class] forCellReuseIdentifier:NSStringFromClass([XZLeftCell class])];
        [_leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
    return _leftTableView;
}

- (UITableView *)rightTableView{

    if (!_rightTableView) {
        
        _rightTableView = [[UITableView alloc] init];
        _rightTableView.rowHeight = 80.f;
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        _rightTableView.showsVerticalScrollIndicator = NO;
        _rightTableView.showsHorizontalScrollIndicator = NO;
        _rightTableView.tableFooterView = [UIView new];
        [_rightTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    return _rightTableView;
}
@end
