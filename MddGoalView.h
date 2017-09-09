//
//  MddGoalView.h
//  Printer3D
//
//  Created by mac on 2017/1/16.
//  Copyright © 2017年 mdd.oscar. All rights reserved.
//

#import <UIKit/UIKit.h>



@class MddGoalView;
@class MddGoalBigView;


typedef NS_ENUM(NSUInteger, MddGoalViewState) {
    MddGoalViewStateOff=1      //未启用
    ,MddGoalViewStateCircle=2      //球状态
    ,MddGoalViewStateView=3      //视图状态
};
/*
 控件圆球
 */
@interface MddGoalView : UIView

#pragma mark data
//球形态
@property(nonatomic,assign) MddGoalViewState mState;
//球的坐标中心
@property(nonatomic,assign) CGPoint mSphereCenter;
//球的
@property(nonatomic,assign) CGRect mSphereRect;
//展开的大小
@property(nonatomic,assign) CGPoint mBigCenter;
//展开视图
#pragma mark ib
@property(nonatomic,assign) MddGoalBigView * mBigCenterView;
@property (weak, nonatomic) IBOutlet UIImageView *mUiCenterImage;

//父亲视图
@property(nonatomic,assign) UIView * mSuperview;

#pragma mark ctor

+(instancetype) GetInstanceViewInSuperview:(UIView *) pSuperview;
+(instancetype) GetInitInstance;

#pragma mark func
//启动
-(void) setUp;
-(void) openView;
-(void) closeView;
-(void) setInfoText:(NSString *) pText;
-(void) refeshView;

@end
