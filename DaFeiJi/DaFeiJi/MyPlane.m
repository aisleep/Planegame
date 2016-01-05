//
//  MyPlane.m
//  1949
//
//  Created by KG on 14-9-16.
//  Copyright (c) 2014年 KG. All rights reserved.
//

#import "MyPlane.h"
MyPlane * myPlane = nil;
@implementation MyPlane

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}

+(id)currentMyPlane
{
    
    if (!myPlane) {
        //初始化我的战机
        myPlane = [[MyPlane alloc]init];
        //设置frame
        myPlane.frame = CGRectMake(140, 420, 40, 40);
        //设置图片
        myPlane.image = [UIImage imageNamed:@"myplane"];
        //设置我的战机的横向移动速度
        myPlane.xSpeed = 10;
        
        //创建动画数组
        NSMutableArray * animationArray = [[NSMutableArray alloc]init];
        //初始化动画数组中的图片
        for (int i = 1; i<= 20; i++) {
            NSString * string = [NSString stringWithFormat:@"bossbomb%d",i];
            UIImage * image = [UIImage imageNamed:string];
            [animationArray addObject:image];
        }
        //将动画图片赋值给imageView的动画数组
        myPlane.animationImages = animationArray;
        myPlane.animationDuration = 0.2;
        myPlane.animationRepeatCount = 1;
        
    }
    return myPlane;
}
-(void)deallocMyPlane{
    myPlane = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
