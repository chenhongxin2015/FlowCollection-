//
//  TGWaterflowLayout.h
//  瀑布流的封装
//
//  Created by apple on 16/6/23.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TGWaterflowLayout;
@protocol TGWaterflowLayoutDelegate <NSObject>
@required
/**
 * 瀑布流高度的设置
 */
- (CGFloat)waterflowLayout:(TGWaterflowLayout *)waterflowLayout heightForItemIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth;
@optional
/**
 * 瀑布流 列数的设置
 */
- (NSInteger)columnCountInWaterflowLayout:(TGWaterflowLayout *)waterflowLayout;
/**
 * 瀑布流 列间距的设置
 */
- (CGFloat)columnMarginInWaterflowLayout:(TGWaterflowLayout *)waterflowLayout;
/**
 * 瀑布流 行间距的设置
 */
- (CGFloat)rowMarginInWaterflowLayout:(TGWaterflowLayout *)waterflowLayout;
/**
 * 瀑布流 内边距的设置
 */
- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(TGWaterflowLayout *)waterflowLayout;
@end
@interface TGWaterflowLayout : UICollectionViewLayout
@property (nonatomic,weak) id <TGWaterflowLayoutDelegate> delegate;
@end
