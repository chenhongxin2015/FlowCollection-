//
//  TGWaterflowLayout.m
//  瀑布流的封装
//
//  Created by apple on 16/6/23.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "TGWaterflowLayout.h"
@interface TGWaterflowLayout()
@property (nonatomic) NSMutableArray *attrsArray;
//存放所有列的高度值
@property (nonatomic) NSMutableArray *allColumnsHeight;
//内容的高度
@property (nonatomic) CGFloat contentHeight;
//声明获取行，列间距，列数和边距方法
- (CGFloat)rowMargin;
- (CGFloat)columnMargin;
- (NSInteger)columnCount;
- (UIEdgeInsets)edgeInsets;
@end
//列间距
static const CGFloat TGDefaultColumnMargin = 10;
//行间距
static const CGFloat TGDefaultRowMargin = 10;
//边缘间距
static const UIEdgeInsets TGDefaultEdgesMargin = {10,10,10,10};
//默认列数
static const NSInteger TGDefaultColumnCount = 3;


@implementation TGWaterflowLayout
#pragma mark - 常见数据处理
- (CGFloat)rowMargin
{
    if ([self.delegate respondsToSelector:@selector(rowMarginInWaterflowLayout:)]) {
        return [self.delegate rowMarginInWaterflowLayout:self];
        
    }else
    {
        return TGDefaultRowMargin;
    }
    
}
- (CGFloat)columnMargin
{
    if ([self.delegate respondsToSelector:@selector(columnMarginInWaterflowLayout:)]) {
        return [self.delegate columnMarginInWaterflowLayout:self];
    }else
    {
        return TGDefaultColumnMargin;
    }
}
- (NSInteger)columnCount
{
    if ([self.delegate respondsToSelector:@selector(columnCountInWaterflowLayout:)]) {
        return [self.delegate columnCountInWaterflowLayout:self];
    }else
    {
        return TGDefaultColumnCount;
    }
    
}
- (UIEdgeInsets)edgeInsets
{
    if ([self.delegate respondsToSelector:@selector(edgeInsetsInWaterflowLayout:)]) {
        return [self.delegate edgeInsetsInWaterflowLayout:self];
    }else
    {
        return TGDefaultEdgesMargin;
    }

}
#pragma mark - 懒加载
- (NSMutableArray *)allColumnsHeight
{
    if (!_allColumnsHeight) {
        _allColumnsHeight = [NSMutableArray array];
    }return _allColumnsHeight;
}
- (NSMutableArray *)attrsArray
{
    if (!_attrsArray) {
        _attrsArray = [NSMutableArray array];
    }return _attrsArray;
    
}
/*
 *初始化
 *
 */

- (void)prepareLayout
{
    [super prepareLayout];
    self.contentHeight = 0;
    //清楚以前计算的高度
    [self.allColumnsHeight removeAllObjects];
    for (NSInteger i = 0; i < TGDefaultColumnCount; i++) {
        [self.allColumnsHeight addObject:@(TGDefaultEdgesMargin.top)];
    }
    //清楚之前的所有的布局属性
    [self.attrsArray removeAllObjects];
    //创建数组（存放每个cell 布局属性）
//    NSMutableArray *arry = [NSMutableArray array];
    //开始创建每一个cell对应的布局属性
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < count; i++) {
        //创建位置
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        //indexPath 对应的cell的布局属性
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrsArray addObject:attrs];
    }
}

/*
 *决定cell的排布
 *
 */

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
   
    return self.attrsArray;
}

/*
 * 返回indexPath位置cell对应的布局属性
 *
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    //创建布局属性
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    //设置布局属性的frame
    CGFloat collectionViewW = self.collectionView.frame.size.width;
    //找出高度最短的队列
    NSInteger destColumn = 0;
    CGFloat minColumnHeight = [self.allColumnsHeight[0] doubleValue];
    for (NSInteger i = 1; i < self.columnCount; i++) {
        CGFloat columnHeight = [self.allColumnsHeight[i] doubleValue];
        if (minColumnHeight > columnHeight) {
            minColumnHeight = columnHeight;
            destColumn = i;
        }
    }
//    [self.allColumnsHeight enumerateObjectsUsingBlock:^(NSNumber *columnHeightNumber, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (minColumnHeight > columnHeightNumber.doubleValue) {
//            minColumnHeight = columnHeightNumber.doubleValue;
//            destColumn = idx;
//        }
//    }];
    CGFloat W = (collectionViewW - self.edgeInsets.left - self.edgeInsets.right - (self.columnCount - 1) * self.columnMargin)/self.columnCount;
    CGFloat X = self.edgeInsets.left + destColumn * (W + self.columnMargin);
    CGFloat Y = minColumnHeight;
    if (Y != self.edgeInsets.top ) {
        Y += self.rowMargin;
    }
    
    CGFloat H = [self.delegate waterflowLayout:self heightForItemIndexPath:indexPath itemWidth:W];
    
    attrs.frame = CGRectMake(X, Y, W, H);
    self.allColumnsHeight[destColumn] = @(CGRectGetMaxY(attrs.frame));
    //记录内容高度
    CGFloat contentHeight = [self.allColumnsHeight[destColumn] doubleValue];
    if (self.contentHeight < contentHeight) {
        self.contentHeight = contentHeight;
    }

    return attrs;
}
//重新设置 collectionView 内容尺寸
- (CGSize)collectionViewContentSize
{
//    CGFloat maxCoumnHeight = [self.allColumnsHeight[0] doubleValue];
//    for (NSInteger i = 1 ; i < self.columnCount; i++) {
//        CGFloat columnHeight = [self.allColumnsHeight[i] doubleValue];
//        if (maxCoumnHeight < columnHeight) {
//            maxCoumnHeight = columnHeight;
//        }
//    }
    return CGSizeMake(0, self.contentHeight + self.edgeInsets.bottom);
}














@end
