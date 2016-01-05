//
//  EnemyPlane.m
//  1949
//
//  Created by KG on 14-9-16.
//  Copyright (c) 2014年 KG. All rights reserved.
//

#import "EnemyPlane.h"

@implementation EnemyPlane
{
    NSMutableArray * planeName;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)preparePlaneName
{
    planeName = [[NSMutableArray alloc]initWithObjects:@"boss0",@"boss1",@"boss2",@"boss3",@"enemy1",@"enemy2",@"enemy3",@"enemy4", nil];
}
-(id)initWithWinFrame:(CGRect)winFrame
{
    if (self = [super init]) {
        [self preparePlaneName];
        //随机一个敌机出现的位置
        self.frame = CGRectMake(arc4random()%(int)(winFrame.size.width - 40), 0, 40, 40);
        //随机选一张敌机图片
        self.image = [UIImage imageNamed:[planeName objectAtIndex:arc4random()%8]];
        //创建动画数组
        NSMutableArray * animationArray = [[NSMutableArray alloc]init];
        //初始化动画数组中的图片
        for (int i = 0; i < 6; i++) {
            NSString * string = [NSString stringWithFormat:@"bomb%d",i];
            UIImage * image = [UIImage imageNamed:string];
            [animationArray addObject:image];
        }
        //将动画图片赋值给imageView的动画数组
        self.animationImages = animationArray;
        self.animationDuration = 0.2;
        self.animationRepeatCount = 1;
        self.ySpeed = arc4random() % 5 + 10;
        
    }
    return self;
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
