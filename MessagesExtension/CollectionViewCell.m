//
//  CollectionViewCell.m
//  CustomMessageTest
//
//  Created by mac on 16/10/9.
//  Copyright © 2016年 boyaa. All rights reserved.
//

#import "CollectionViewCell.h"
#import "YLGIFImage.h"
#import "YLImageView.h"
@interface CollectionViewCell()
@property (nonatomic, weak)YLImageView* gifView;
@end
@implementation CollectionViewCell
+(CollectionViewCell *)cellWithData:(NSString *)name  collectView:(UICollectionView *)collectView indexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [collectView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    if (!cell) {
        cell = [[CollectionViewCell alloc] init];
    }
    if (!cell.gifView) {
        YLImageView* imageView = [[YLImageView alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
        imageView.userInteractionEnabled = NO;
        [cell.contentView addSubview:imageView];
        cell.gifView = imageView;
    }
    //cell.contentView.backgroundColor = [UIColor blackColor];
    cell.gifView.image = [YLGIFImage imageNamed:name];
    return cell;
}
@end
