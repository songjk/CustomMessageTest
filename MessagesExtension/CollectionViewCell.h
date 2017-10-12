//
//  CollectionViewCell.h
//  CustomMessageTest
//
//  Created by mac on 16/10/9.
//  Copyright © 2016年 boyaa. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const cellId = @"cellId";
@interface CollectionViewCell : UICollectionViewCell
+(CollectionViewCell *)cellWithData:(NSString *)name collectView:(UICollectionView *)collectView indexPath:(NSIndexPath *)indexPath;
@end
