//
//  MddGoalBigView.h
//  Printer3D
//
//  Created by mac on 2017/1/16.
//  Copyright © 2017年 mdd.oscar. All rights reserved.
//

#import <UIKit/UIKit.h>


/*
 展开视图
 */
@interface MddGoalBigView : UIView

#pragma mark ib
@property (weak, nonatomic) IBOutlet UIScrollView *mUiCenterScrollView;

@property (weak, nonatomic) IBOutlet UILabel *mUiInfoLabel;

+(instancetype) instancetypeForNib;

@end
