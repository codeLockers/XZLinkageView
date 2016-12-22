//
//  XZCollectionController.m
//  XZLinkageView
//
//  Created by codeLocker on 2016/12/22.
//  Copyright © 2016年 codeLocker. All rights reserved.
//

#import "XZCollectionController.h"
#import <Masonry/Masonry.h>
#import "XZLeftCell.h"
#import "NSObject+Property.h"
#import "XZCollectionModel.h"
#import "XZCollectionCell.h"
#import "XZCollectionHeadView.h"

@interface XZCollectionController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{

    BOOL _isScrollDown;
}

@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UICollectionView *collectionView;
/** 分类*/
@property (nonatomic, strong) NSMutableArray *categoryData;
@end

@implementation XZCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"meilshuo" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSArray *array = dic[@"data"][@"categories"];
    
    for (NSDictionary *dic in array) {
        
        XZCollectionModel *model = [XZCollectionModel objectWithDictionary:dic];
        [self.categoryData addObject:model];
    }
    
    [self.view addSubview:self.leftTableView];
    [self.view addSubview:self.collectionView];
    
    [self layout];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.categoryData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    XZLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XZLeftCell class])];
    XZCollectionModel *model = self.categoryData[indexPath.row];
    cell.nameLab.text = model.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.row] animated:YES scrollPosition:UICollectionViewScrollPositionTop];
}

#pragma mark - UICollectionViewDataSourc
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return self.categoryData.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    XZCollectionModel *model = self.categoryData[section];
    
    return model.subcategories.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    XZCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XZCollectionCell class]) forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor greenColor];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

    NSString *reuseIdentifier;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    { // header
        reuseIdentifier = NSStringFromClass([XZCollectionHeadView class]);
    }
    XZCollectionHeadView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                        withReuseIdentifier:reuseIdentifier
                                                                               forIndexPath:indexPath];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
      
    }
    return view;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 30);
}

- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{

    if (!_isScrollDown && self.collectionView.dragging) {
        
        [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.section inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{

    if ( _isScrollDown && self.collectionView.dragging) {
        
        [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.section+1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    CGFloat width =([UIScreen mainScreen].bounds.size.width -80 - 4)/3.0f;
    
    return CGSizeMake(width, width+30);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    static CGFloat lastOffset = 0;
    
    if (self.collectionView == scrollView) {
        
        _isScrollDown = lastOffset < scrollView.contentOffset.y;
        lastOffset = scrollView.contentOffset.y;
    }
}

#pragma mark - Layout
- (void)layout{
    
    [self.leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view);
        make.width.mas_equalTo(80.0f);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.leftTableView.mas_right);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(64);
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

- (UICollectionView *)collectionView{

    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionHeadersPinToVisibleBounds = YES;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 2;
        layout.minimumInteritemSpacing = 2;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        [_collectionView registerClass:[XZCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([XZCollectionCell class])];
        [_collectionView registerClass:[XZCollectionHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([XZCollectionHeadView class])];
    }
    return _collectionView;
}
@end
