//
//  MddGoalBigView.m
//  Printer3D
//
//  Created by mac on 2017/1/16.
//  Copyright © 2017年 mdd.oscar. All rights reserved.
//

#import "MddGoalBigView.h"

@implementation MddGoalBigView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(instancetype) instancetypeForNib
{
    static MddGoalBigView *sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance =[[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
    });
    return sharedInstance;
}
@end
