//
//  ViewController.m
//  瀑布流的封装
//
//  Created by apple on 16/6/23.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "ViewController.h"
#import "TGWaterflowLayout.h"
#import "XMGShop.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "XMGShopCell.h"
@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,TGWaterflowLayoutDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>
@property (nonatomic) NSMutableArray *shops;

@property (nonatomic) UICollectionView *collectionView;
@end

@implementation ViewController
static NSString *const ID = @"shop";
- (NSMutableArray *)shops
{
    if (!_shops) {

        _shops = [NSMutableArray array];
    }return _shops;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupLayout];
    [self setupRefresh];

}
- (void)move:(NSTimer *)timer
{
    CGPoint point = self.collectionView.contentOffset;
    point.y += 8;
    if (point.y >= self.view.bounds.size.height * 2) {
        point.y = 0;
        [self.collectionView setContentOffset:point];
        return;
    }
    [UIView animateWithDuration:0.02 animations:^{
        [self.collectionView setContentOffset:point];
//        [self.collectionView setContentOffset:point animated:YES];
    }];
    

}
- (void)setupRefresh
{
    __weak typeof(self) weakSelf = self;
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewShops];
    }];
    self.collectionView.footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreShops];
    }];
    [self.collectionView.header beginRefreshing];
}
- (void)loadNewShops
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSString *file =
        NSArray *shops =  [XMGShop objectArrayWithFilename:@"1.plist"];
        [self.shops removeAllObjects];
        [self.shops addObjectsFromArray:shops];
        //刷新数据
        [self.collectionView reloadData];
        [self.collectionView.header endRefreshing];
    });
   
}
- (void)loadMoreShops
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *shops =  [XMGShop objectArrayWithFilename:@"1.plist"];
      
        [self.shops addObjectsFromArray:shops];
        //刷新数据
        [self.collectionView reloadData];
        [self.collectionView.footer endRefreshing];
    });
    
}
- (void)setupLayout
{
    //创建布局
    TGWaterflowLayout *layout = [[TGWaterflowLayout alloc]init];
    layout.delegate = self;
    //创建CollectionView
//    CGFloat collectionW = self.view.frame.size.width;
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    [_collectionView registerNib:[UINib nibWithNibName:@"XMGShopCell" bundle:nil] forCellWithReuseIdentifier:ID];
  
//    self.collectionView.scrollEnabled = NO;
//    self.collectionView setd

}

- (void)doSomething
{
    NSLog(@"%@",[NSThread currentThread]);
                [self performSelectorOnMainThread:@selector(Something) withObject:nil waitUntilDone:NO];
}
- (void)Something
{
 NSLog(@"==%@",[NSThread currentThread]);

}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  
    return self.shops.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"%ld",indexPath.section);

   
 
     XMGShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.shop = self.shops[indexPath.item];
    cell.backgroundColor = [UIColor orangeColor];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(0, 30);
}
#pragma mark - TGWaterflowLayoutDelegate


- (CGFloat)waterflowLayout:(TGWaterflowLayout *)waterflowLayout heightForItemIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth
{
  
    XMGShop *shop = self.shops[indexPath.item];
    return itemWidth * shop.h/shop.w;
    return itemWidth;
}
- (CGFloat)rowMarginInWaterflowLayout:(TGWaterflowLayout *)waterflowLayout
{

    return 0;
}


//- (NSInteger)columnCountInWaterflowLayout:(TGWaterflowLayout *)waterflowLayout atIndexPath:(NSIndexPath *)indexPath
//{
////    if (indexPath.section) {
////        return 3;
////    }
//    return 4;
//}
- (NSInteger)columnCountInWaterflowLayout:(TGWaterflowLayout *)waterflowLayout
{
    return 3;
}

- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(TGWaterflowLayout *)waterflowLayout
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGFloat)columnMarginInWaterflowLayout:(TGWaterflowLayout *)waterflowLayout
{

    return 0;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"click item");
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"draging");
}


@end
