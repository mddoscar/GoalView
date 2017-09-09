//
//  MddGoalView.m
//  Printer3D
//
//  Created by mac on 2017/1/16.
//  Copyright © 2017年 mdd.oscar. All rights reserved.
//

#import "MddGoalView.h"
#import "MddGoalBigView.h"
//默认大小
#define kDefCenter CGPointMake(50, 50)
#define kDefWith 50
#define kDefHeight 50
#define kDefFrame  CGRectMake(([UIScreen mainScreen].bounds.size.width), ([UIScreen mainScreen].bounds.size.width), kDefWith, kDefHeight)
#define kTopNavHeight 64
#define kPanding 10  //边距
//引用全局
#import "AppDelegate.h"
#import "ServerForPrinter3D.h"

@implementation MddGoalView

static MddGoalView *sharedInstance = nil;

-(void)awakeFromNib
{
    [super awakeFromNib];

}

-(id) init
{
    if (self=[super init]) {
        
    }
    return self;
}
-(id) initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super initWithCoder:aDecoder]) {
        
    }
    return self;
}
-(id) initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        
    }
    
    return self;
}
-(void) setDefView
{
    self.frame=kDefFrame;
    self.center=kDefCenter;
}
-(void) addSubView
{
    if (nil!=self.mSuperview) {
        if (nil==self.mBigCenterView) {
            self.mBigCenterView =[MddGoalBigView instancetypeForNib];
        }
        [self.mSuperview addSubview:self.mBigCenterView];
        self.mBigCenterView.frame=CGRectMake(0, 0, SCREEN_WIDTH*2/3, SCREEN_WIDTH*2/3);
        self.mBigCenterView.mUiCenterScrollView.frame=self.mBigCenterView.bounds;
        
        [self.mBigCenterView setCenter:self.mSuperview.center];
    }
}
-(void) drawRect:(CGRect)rect{
    float Radus= self.frame.size.width/2;
    //用bezier曲线画遮罩层
    UIBezierPath *path=[UIBezierPath bezierPathWithArcCenter: CGPointMake(self.center.x-self.frame.origin.x, self.center.y-self.frame.origin.y) radius:Radus startAngle:0 endAngle:2*M_PI clockwise:YES];
    CAShapeLayer *shape=[CAShapeLayer layer];
    shape.path=path.CGPath;
    self.layer.mask=shape;
}
#pragma mark 
-(void)setUp
{
    [self setNeedsLayout];
    [self setDefView];
    [self addSubView];
    [self doAddNotif];
    [self doAddEvent];
    //初始化
    self.mState=MddGoalViewStateCircle;
    [self.mSuperview needsUpdateConstraints];
    //刷新
    [self setNeedsDisplay];
    [self setUserInteractionEnabled:YES];
    //默认状态
    [self doCloseViewState];
}
-(void) openView
{
    [self.mBigCenterView setHidden:NO];
    [self setHidden:YES];
    [self setInfoText:[ServerForPrinter3D getStringWithDic:[AppDelegate GetAppDelegate].mGoalDic]];
}
-(void) closeView
{
    [self.mBigCenterView setHidden:YES];
    [self setHidden:NO];
}
-(void) setInfoText:(NSMutableAttributedString *) pText
{
    self.mBigCenterView.mUiInfoLabel.attributedText=pText;
     self.mBigCenterView.mUiInfoLabel.numberOfLines = 0;
}
//添加广播坚挺
-(void) doAddNotif
{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doPostUiCmd:) name:kNoticfUiParamCmd object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doPostCmd:) name:kNoticfCmd object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doAppStateChange:) name:kMddApplicationWillEnterStateCmd object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeFrames:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
}

-(void) removeNotivce
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNoticfCmd object:nil];
  
//        [[NSNotificationCenter defaultCenter] removeObserver:self name:kMddApplicationWillEnterStateCmd object:nil];
    
}
//-(void) doPostUiCmd:(NSNotification *)note
-(void) doPostCmd:(NSNotification *)note
{
    //    NSLog(@"Received notification: %@", note);
    
    NSMutableArray * pDataArray= [note.object valueForKey:kNoticfArrKey];
    
      if (self.mState==MddGoalViewStateCircle)
      {
          //
      }else if(self.mState==MddGoalViewStateView)
      {
      
          if (pDataArray.count>0) {
              //测试日志
              [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayDataLog]=[pDataArray description];
              NSString * tCmd=pDataArray[0];
              //轴位置包
              if ([kCmdType_axis_req_resp isEqualToString:tCmd]){
                  [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayX]=[NSString stringWithFormat:@"%.3f",[pDataArray[1] doubleValue]/1000.0f];
                  [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayY]=[NSString stringWithFormat:@"%.3f",[pDataArray[2] doubleValue]/1000.0f];
                  [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayZ]=[NSString stringWithFormat:@"%.3f",[pDataArray[3] doubleValue]/1000.0f];
//                  [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayZp1]=[NSString stringWithFormat:@"%.3f",[pDataArray[4] doubleValue]/1000.0f];
//                  [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayZp2]=[NSString stringWithFormat:@"%.3f",[pDataArray[5] doubleValue]/1000.0f];
                  [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayC]=[NSString stringWithFormat:@"%.3f",[pDataArray[4] doubleValue]/1000.0f];
                  [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayW]=[NSString stringWithFormat:@"%.3f",[pDataArray[5] doubleValue]/1000.0f];
                  
                  [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayWork_X]=[NSString stringWithFormat:@"%.3f",[pDataArray[6] doubleValue]/1000.0f];
                  if (pDataArray.count>7)
                      [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayWork_Y]=[NSString stringWithFormat:@"%.3f",[pDataArray[7] doubleValue]/1000.0f];
                  if (pDataArray.count>8)
                      [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayWork_Z]=[NSString stringWithFormat:@"%.3f",[pDataArray[8] doubleValue]/1000.0f];
                  if (pDataArray.count>9)
                  [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayWork_C]=[NSString stringWithFormat:@"%.3f",[pDataArray[9] doubleValue]/1000.0f];
                  if (pDataArray.count>10)
                  [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayWork_W]=[NSString stringWithFormat:@"%.3f",[pDataArray[10] doubleValue]/1000.0f];
        //add
                  if (pDataArray.count>11)
                      [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayZp1]=[NSString stringWithFormat:@"%.3f",[pDataArray[11] doubleValue]/1000.0f];
                  if (pDataArray.count>12)
                      [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayZp2]=[NSString stringWithFormat:@"%.3f",[pDataArray[12] doubleValue]/1000.0f];
                  if (pDataArray.count>13)
                      [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayZT]=[NSString stringWithFormat:@"%.3f",[pDataArray[13] doubleValue]/1000.0f];
                  if (pDataArray.count>14)
                      [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayWorkZp1]=[NSString stringWithFormat:@"%.3f",[pDataArray[14] doubleValue]/1000.0f];
                  if (pDataArray.count>15)
                      [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayWorkZp2]=[NSString stringWithFormat:@"%.3f",[pDataArray[15] doubleValue]/1000.0f];
                  if (pDataArray.count>16)
                      [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayWorkZT]=[NSString stringWithFormat:@"%.3f",[pDataArray[16] doubleValue]/1000.0f];
                  
                  //行号位置包
              }else if ([kCmdType_linenumber_req_resp isEqualToString:tCmd]){
                  [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayLineNumber]=pDataArray[1];
                  //
                  if ([AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayLineNumberAll]!=nil) {
                      long LineNumberAll=[[AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayLineNumberAll] integerValue];
                      if (LineNumberAll>0) {
                          [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayProcess]=[NSString stringWithFormat:@"%.1f%@",[[AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayLineNumber] integerValue]/(LineNumberAll*1.0),@"%"];
                      }
                  }

                  //速率包
              }else if ([kCmdType_speed_resp isEqualToString:tCmd]){
                  //全局Socket有了
//                  int type=[pDataArray[1] intValue]%2;
//                  //f值
//                  if ([kCmdType_speedset_commonTpye_in intValue]==type) {
//                                            if (pDataArray.count>3) {
//                                                NSString * speed=pDataArray[3];
//                                                NSString * displaySpeed= [NSString stringWithFormat:@"%.3f",[speed intValue]/(1000.0)];
//                                                [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayF]=displaySpeed;
//                                            }
//                      
//                  }
//                  //e值
//                  else if ([kCmdType_speedset_commonTpye_out intValue]==type) {
//                      if (pDataArray.count>3) {
//                          NSString * speed=pDataArray[3];
//                          NSString * displaySpeed= [NSString stringWithFormat:@"%.3f",[speed intValue]/(1000.0)];
//                          //转换随机数
//                          long  groupId=[pDataArray[2] intValue]%(4+1);
//                          if (groupId==1) {
//                              [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayEp1]=displaySpeed;
//                          }else if (groupId==2) {
//                              [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayEp2]=displaySpeed;
//                          }else if (groupId==3) {
//                              [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayEp3]=displaySpeed;
//                          }else if (groupId==4) {
//                              [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayEp4]=displaySpeed;
//                          }
//                          
//                      }
//                  }
              }else if ([kCmdType_speedset_req isEqualToString:tCmd]){
                  //全局Socket有了
//                  int type=[pDataArray[1] intValue]%2;
//                  //f值
//                  if ([kCmdType_speedset_commonTpye_in intValue]==type) {
//                      if (pDataArray.count>3) {
//                          NSString * speed=pDataArray[3];
//                          NSString * displaySpeed= [NSString stringWithFormat:@"%.3f",[speed intValue]/(1000.0)];
//                          [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayF]=displaySpeed;
//                      }
//                      
//                  }
//                  //e值
//                  else if ([kCmdType_speedset_commonTpye_out intValue]==type) {
//                      if (pDataArray.count>3) {
//                          NSString * speed=pDataArray[3];
//                          NSString * displaySpeed= [NSString stringWithFormat:@"%.3f",[speed intValue]/(1000.0)];
//                          //转换随机数
//                          long  groupId=[pDataArray[2] intValue]%4+1;
//                          if (groupId==1) {
//                              [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayEp1]=displaySpeed;
//                          }else if (groupId==2) {
//                              [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayEp2]=displaySpeed;
//                          }else if (groupId==3) {
//                              [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayEp3]=displaySpeed;
//                          }else if (groupId==4) {
//                              [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayEp4]=displaySpeed;
//                          }
//                          
//                      }
//                  }
              }
              
              else if ([kCmdType_temp_req_resp isEqualToString:tCmd]){
                  //有两种类型
                  int type=[pDataArray[1] intValue]%2;
                  //f值
                  if ([kCmdType_speedset_commonTpye_in intValue]==type) {
                      if (pDataArray.count>3) {
                          NSString * speed=pDataArray[3];
                          NSString * displaySpeed= [NSString stringWithFormat:@"%.3f",[speed intValue]/(1000.0)];
                          [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplaySetF]=displaySpeed;
                      }
                      
                  }
                  //e值
                  else if ([kCmdType_speedset_commonTpye_out intValue]==type) {
                      if (pDataArray.count>3) {
                          NSString * speed=pDataArray[3];
                          NSString * displaySpeed= [NSString stringWithFormat:@"%.3f",[speed intValue]/(1000.0)];
                          //转换随机数
                          long  groupId=[pDataArray[2] intValue]%4+1;
                          if (groupId==1) {
                              [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplaySetEp1]=displaySpeed;
                          }else if (groupId==2) {
                              [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplaySetEp2]=displaySpeed;
                          }else if (groupId==3) {
                              [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplaySetEp3]=displaySpeed;
                          }else if (groupId==4) {
                              [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplaySetEp4]=displaySpeed;
                          }
                          
                      }
                  }
              }else if([kCmdType_now_req isEqualToString:tCmd])
              {
                  struct ScenePackage sp= [ServerForDevices decodeArrayNewWithDataArray:[AppDelegate GetAppDelegate].mGoalDic[kGoalDisplaySceenArray]];
                   [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayX]=[NSString stringWithFormat:@"%.3f",sp.status.CurPos.X_Int/1000.0f];
                   [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayY]=[NSString stringWithFormat:@"%.3f",sp.status.CurPos.Y_Int/1000.0f];
                    [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayZ]=[NSString stringWithFormat:@"%.3f",sp.status.CurPos.Z_Int/1000.0f];
                    [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayC]=[NSString stringWithFormat:@"%.3f",sp.status.CurPos.C_Int/1000.0f];
                    [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayW]=[NSString stringWithFormat:@"%.3f",sp.status.CurPos.W_Int/1000.0f];
                  [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayWork_X]=[NSString stringWithFormat:@"%.3f",sp.status.CurWorkPos.X_Int/1000.0f];
                  [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayWork_Y]=[NSString stringWithFormat:@"%.3f",sp.status.CurWorkPos.Y_Int/1000.0f];
                  [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayWork_Z]=[NSString stringWithFormat:@"%.3f",sp.status.CurWorkPos.Z_Int/1000.0f];
                  [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayWork_C]=[NSString stringWithFormat:@"%.3f",sp.status.CurWorkPos.C_Int/1000.0f];
                  [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayWork_W]=[NSString stringWithFormat:@"%.3f",sp.status.CurWorkPos.W_Int/1000.0f];
                [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayE_ALL]=[NSString stringWithFormat:@"%.3f",sp.status.CurModeCode.CurEValue/1000.0f];
                  
                  
                  [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayF]=[NSString stringWithFormat:@"%.3f",sp.status.CurModeCode.CurFValue/1000.0f];// [NSString stringWithFormat:@"%d",sp.status.CurModeCode.CurFValue];
                [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayLineNumber]=[NSString stringWithFormat:@"%d",sp.status.CurModeCode.PrintLineNum];
//                [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayPT]=pDataArray[1];
//                [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayERROR]=pDataArray[1];
//
//                  struct ScenePackage decodePackage;
//                  int *pint=(int *)&decodePackage;
//                  NSMutableArray * TArr=[[AppDelegate GetAppDelegate].mGoalDic[kGoalDisplaySceenArray] mutableCopy];
//                  
//                  for (int i=1; i<TArr.count-1; i++) {
//                      pint[i-1]=[TArr[i] doubleValue];
//                      pint++;
//                      
//                  }
                  NSLog(@"%u",sp.status.RunStatus);
                  //反解析数组
//                  NSMutableArray * tmpArray=[ServerForDevices encodeArrayNewWithDataStruct:sp];
//                  NSLog(@"tmpArray:%@",tmpArray);

              }else if([kCmdType_error_resp isEqualToString:tCmd])
              {
                  if (pDataArray.count>0) {
                      [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayERROR_NUMBER]=pDataArray[1];
                  }
                  if (pDataArray.count>1)
                  [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayERROR_alert_Value]=pDataArray[2];
                  if (pDataArray.count>2)
                  [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayERROR_HOT_NUMBER]=pDataArray[3];
                  if (pDataArray.count>3)
                  [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayERROR_HOT_OFFSET]=pDataArray[4];
                  if (pDataArray.count>4)
                  [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayERROR_Head_NUMBER]=pDataArray[5];
                  if (pDataArray.count>5)
                  [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayERROR_Head_OFFSET]=pDataArray[6];

              }
//              else if([kCmdType_now_req isEqualToString:tCmd])
//              {
//                  pDataArray= [ServerForDevices decodeArrayNowPackageWithData:pDataArray];
//                  NSDictionary *fParamData = [NSDictionary dictionaryWithObject:pDataArray forKey:kNoticfArrKey];
//                [[NSNotificationCenter defaultCenter] postNotificationName:kNoticfCmd object:fParamData];
//              }
              //    //更新UI全局
              //    if ([kCmdType_axis_req_resp isEqualToString:tCmd]||[kCmdType_linenumber_req_resp isEqualToString:tCmd]||[kCmdType_speed_resp isEqualToString:tCmd]||[kCmdType_temp_req_resp isEqualToString:tCmd]) {
              //        NSDictionary *fUIParamData = [NSDictionary dictionaryWithObject:[ServerForPrinter3D getStringWithDic:[AppDelegate GetAppDelegate].mGoalDic] forKey:kNoticfGoalParamKey];
              //        [[NSNotificationCenter defaultCenter] postNotificationName:kNoticfUiParamCmd object:fUIParamData];
              //    }
              //    
              //    
              //    
              //      NSString * tStr= [note.object valueForKey:kNoticfGoalParamKey];
              [self setInfoText:[ServerForPrinter3D getStringWithDic:[AppDelegate GetAppDelegate].mGoalDic]];
          }
      
      }

}
-(void) doAddEvent
{
    UITapGestureRecognizer *singleRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doOpenViewState)];
    singleRecognizer1.numberOfTapsRequired = 1; //点击的次数 =1:单击
    [singleRecognizer1 setNumberOfTouchesRequired:1];//1个手指操作
    [self.mUiCenterImage setUserInteractionEnabled:YES];
    [self.mUiCenterImage addGestureRecognizer:singleRecognizer1];
    
    UITapGestureRecognizer *singleRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doCloseViewState)];
    singleRecognizer2.numberOfTapsRequired = 1; //点击的次数 =1:单击
    [singleRecognizer2 setNumberOfTouchesRequired:1];//1个手指操作
    [self.mBigCenterView addGestureRecognizer:singleRecognizer2];
}
-(void) doOpenClose
{
    if (self.mState==MddGoalViewStateCircle) {
        self.mState=MddGoalViewStateView;
        [self openView];
    }else  if (self.mState==MddGoalViewStateView)
    {
        self.mState=MddGoalViewStateCircle;
        [self closeView];
    }
}
-(void) doOpenViewState
{
    self.mState=MddGoalViewStateView;
    [self openView];
    [self doAddNotif];
}
-(void) doCloseViewState
{
    self.mState=MddGoalViewStateCircle;
    [self closeView];
    [self removeNotivce];
    //调节大小
    //kDefHeight
    [self doChangeSmallView];
}
-(void) doChangeSelfView
{
    if (self.frame.size.height>kDefHeight) {
        self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, kDefHeight);
//        NSLog(@"self:%@,center:%@,origin:%@",self,NSStringFromCGPoint(self.center),NSStringFromCGPoint(self.frame.origin));
    }
    if (self.frame.size.height<kDefHeight/2) {
        self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, kDefHeight);
        //        NSLog(@"self:%@,center:%@,origin:%@",self,NSStringFromCGPoint(self.center),NSStringFromCGPoint(self.frame.origin));
    }
    if (self.frame.size.width>kDefWith) {
        self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, kDefWith, kDefHeight);
    }
    if (self.frame.size.width<kDefWith/2) {
        self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, kDefWith, kDefHeight);
    }
}
-(void) doChangeSmallView
{
    if (self.mUiCenterImage.frame.size.height>kDefHeight) {
        self.mUiCenterImage.frame=CGRectMake(self.mUiCenterImage.frame.origin.x, self.mUiCenterImage.frame.origin.y, self.mUiCenterImage.frame.size.width, kDefHeight);
    }
    if (self.mUiCenterImage.frame.size.height<kDefHeight/2) {
        self.mUiCenterImage.frame=CGRectMake(self.mUiCenterImage.frame.origin.x, self.mUiCenterImage.frame.origin.y, self.mUiCenterImage.frame.size.width, kDefHeight);
    }
    if (self.mUiCenterImage.frame.size.width>kDefWith) {
        self.mUiCenterImage.frame=CGRectMake(self.mUiCenterImage.frame.origin.x, self.mUiCenterImage.frame.origin.y, kDefWith, kDefHeight);
    }
    if (self.mUiCenterImage.frame.size.width<kDefWith/2) {
        self.mUiCenterImage.frame=CGRectMake(self.mUiCenterImage.frame.origin.x, self.mUiCenterImage.frame.origin.y, kDefWith, kDefHeight);
    }
//    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, kDefWith, kDefHeight);
//    self.mUiCenterImage.frame=self.frame;
//    self.mUiCenterImage.center=self.center;
    
}
//点击事件
//-(void) doAddEvent
//{
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
//    [self setUserInteractionEnabled:YES];
//    [self addGestureRecognizer:pan];
//}
//- (void) handlePan: (UIPanGestureRecognizer *)rec{
//    NSLog(@"xxoo---xxoo---xxoo");
//    CGPoint point = [rec translationInView:self.mSuperview];
//    NSLog(@"%f,%f",point.x,point.y);
////    /*
////     高度限制
////     */
////    CGFloat newY=rec.view.center.y + point.y;
////    if (newY-kCicleR/2<0) {
////        newY=-kCicleR/2;
////    }
////    if (newY>self.frame.size.height-kCicleR/2) {
////        newY=self.frame.size.height-kCicleR/2;
////    }
//    rec.view.center = CGPointMake(point.x, point.y);
//    
//    
//    [rec setTranslation:CGPointMake(0, 0) inView:self.mSuperview];
//    if (rec.state == UIGestureRecognizerStateCancelled ||
//        rec.state == UIGestureRecognizerStateFailed)
//    {
//       
//    }
//    if (rec.state == UIGestureRecognizerStateEnded ) {
//       
//    }
//}

-(void) doDistance
{
    if (self.center.x<self.frame.size.width/2+kPanding) {
       [self doChangeCenter:self.frame.size.width/2+kPanding mY: self.center.y];
    }
    
    if (self.center.y<self.frame.size.height/2+kPanding) {
       [self doChangeCenter:self.center.x mY:self.frame.size.height/2+kPanding];
    }
    
    if (self.center.x>self.mSuperview.frame.size.width-self.frame.size.width/2-kPanding) {
      [self doChangeCenter: self.mSuperview.frame.size.width-self.frame.size.width/2-kPanding mY: self.center.y];
    }
    
    if (self.center.y> self.mSuperview.frame.size.height -self.frame.size.height/2-kPanding) {
       [self doChangeCenter:self.center.x mY:self.mSuperview.frame.size.height -self.frame.size.height/2-kPanding];
    }

}
-(void) doAutoPos
{
    //贴边
    int top=self.center.y;
    int left=self.center.x;
    int right=self.mSuperview.frame.size.width-self.center.x;
    int bottom=self.mSuperview.frame.size.height-self.center.y;
    //吸附到上边
    if ((top<left)&&(top<right)&&(top<bottom)) {
        [self doChangeCenter:self.center.x mY: self.frame.size.height/2+kPanding];
    }
    //吸附到左边
    if ((left<top)&&(left<right)&&(left<bottom)) {
        [self doChangeCenter:self.frame.size.width/2+kPanding mY:  self.center.y];
    }
    //吸附到右边
    if ((right<top)&&(right<left)&&(right<bottom)) {
        [self doChangeCenter:self.mSuperview.frame.size.width-self.frame.size.width/2-kPanding mY: self.center.y];
    }
    //吸附到下边
    if ((bottom<top)&&(bottom<left)&&(bottom<right)) {
        [self doChangeCenter:self.center.x mY:self.mSuperview.frame.size.height-self.frame.size.height/2-kPanding];
       
    }
}
//超出频幕
-(void) doChangeCenter:(int )pX mY:(int) pY
{
//    NSLog(@"center:x:%d,y:%d",pX,pY);
     self.center= CGPointMake(pX, pY);
    //还原矩阵
    self.transform=CGAffineTransformMake(1, 0, 0, 1, 0, 0);
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self doAutoPos];
    [self doDistance];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{

}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //NSLog(@"%@", touches);
    UITouch *touch = [touches anyObject];
//
//    //当前的point
//    CGPoint currentP = [touch locationInView:self];
//    
//    //以前的point
//    CGPoint preP = [touch previousLocationInView:self];
//    
//    //x轴偏移的量
//    CGFloat offsetX = currentP.x - preP.x;
//    
//    //Y轴偏移的量
//    CGFloat offsetY = currentP.y - preP.y;
    
    //self.transform = CGAffineTransformTranslate(self.transform, offsetX, offsetY);
     CGPoint currentP1 =[touch locationInView:self.mSuperview];
    
    self.center = CGPointMake(currentP1.x, currentP1.y);

    
    [self doDistance];
    [self doChangeSelfView];
}

-(void)dealloc
{
    [self removeNotivce];
}

+(instancetype) GetInstanceViewInSuperview:(UIView *) pSuperview
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance =[[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
    });
    sharedInstance.mSuperview=pSuperview;
    return sharedInstance;
}
+(instancetype) GetInitInstance
{
    if (nil==sharedInstance) {
        sharedInstance =[[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
    }
    return sharedInstance;
}
-(void) refeshView
{
[self setInfoText:[ServerForPrinter3D getStringWithDic:[AppDelegate GetAppDelegate].mGoalDic]];
}

-(void) doAppStateChange:(NSNotification *)note
{
    NSString * data= [note.object valueForKey:kMddNoticeSocketStateKey];
    [self doChangeSelfView];
}
-(void) changeFrames:(NSNotification *)note
{
    UIDevice * curDevice=note.object;
    //调整
    self.center=self.superview.center;
    [self doAutoPos];
    [self doDistance];
//    NSLog(@"self:%@,center:%@,origin:%@,curDevice.orientation:%ld",self,NSStringFromCGPoint(self.center),NSStringFromCGPoint(self.frame.origin),(long)curDevice.orientation);
    if (curDevice.orientation==UIDeviceOrientationLandscapeLeft) {
//        [self doAutoPos];
//        [self doDistance];
    }else if (curDevice.orientation==UIDeviceOrientationLandscapeRight) {
        
    }else if (curDevice.orientation==UIDeviceOrientationPortrait) {
        
    }else if (curDevice.orientation==UIDeviceOrientationPortraitUpsideDown) {
        
    }

//    [self doChangeSelfView];
}
//- (void)applicationWillEnterForeground:(UIApplication *)application
//{
//    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
//    NSLog(@"applicationWillEnterForeground");
//
//}
//
//- (void)applicationDidBecomeActive:(UIApplication *)application
//{
//    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    NSLog(@"applicationDidBecomeActive");
////    [self doChangeSelfView];
//}
@end
