//
//  Direction.m
//  1949
//
//  Created by KG on 14-9-16.
//  Copyright (c) 2014年 KG. All rights reserved.
//

#import "Direction.h"
#import "MyPlane.h"
@implementation Direction

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(id)init
{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 450, 320, 30);
        //设置底色
        self.backgroundColor = [UIColor clearColor];
        [self crteatButton];
        
    }
    return self;
}
-(void)crteatButton
{
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 2, 30, 26);
    [leftBtn setImage:[UIImage imageNamed:@"button_left"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.tag = 100;
    [self addSubview:leftBtn];
    
    
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(290, 2, 30, 26);
    [rightBtn setImage:[UIImage imageNamed:@"button_right"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.tag = 200;
    [self addSubview:rightBtn];
  
}

-(void)buttonClicked:(UIButton *)button
{
    //获取我的战机
    MyPlane * myPlane = [MyPlane currentMyPlane];
    //获取战机的中心点位置
    CGPoint center =  myPlane.center;
    //判断方向是向左还是向右
    if (button.tag == 100) {
        //向左移动坐标
        center.x -= myPlane.xSpeed;
    }
    else
        //向右移动 坐标
        center.x += myPlane.xSpeed;
    //将计算后的位置重新赋给战机
    myPlane.center = center;
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
