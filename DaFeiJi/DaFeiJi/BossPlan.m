//
//  BossPlan.m
//  1949
//
//  Created by qianfeng on 14-9-16.
//  Copyright (c) 2014年 KG. All rights reserved.
//

#import "BossPlan.h"

BossPlan *bossPlane = nil;

@implementation BossPlan

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+(BossPlan*)currentBossPlaneWithFrame:(CGRect)newframe{
    if (!bossPlane) {
        bossPlane = [[BossPlan alloc] init];
        if (bossPlane) {
            bossPlane.frame=newframe;
            bossPlane.xSpeed=10;
            bossPlane.image=[UIImage imageNamed:@"boss0"];
            bossPlane.blood= 10;
            NSMutableArray *animationArray=[[NSMutableArray alloc]init];
            for (int i=0; i<4; i++) {
                NSString *string=[NSString stringWithFormat:@"boss%d",i];
                UIImage *image=[UIImage imageNamed:string];
                [animationArray addObject:image];
            }
            bossPlane.animationImages=animationArray;
            
            [UIView animateWithDuration:0.2 animations:^{
                bossPlane.animationRepeatCount=0;
                [bossPlane startAnimating];

            }];
        }
        
    }
    return bossPlane;
}

+(BossPlan *)currentBossPlane{
    if (!bossPlane) {
        bossPlane = [BossPlan currentBossPlaneWithFrame:CGRectMake(0, 0, 0, 0)];
    }
    return bossPlane;
}

-(void)resetBossPlane{
    //创建动画数组
    NSMutableArray * animationArray = [[NSMutableArray alloc]init];
    //初始化动画数组中的图片
    for (int i = 1; i <= 20; i++) {
        NSString * string = [NSString stringWithFormat:@"bossbomb%d",i];
        UIImage * image = [UIImage imageNamed:string];
        [animationArray addObject:image];
    }
    //将动画图片赋值给imageView的动画数组
    self.animationImages = animationArray;
    self.animationDuration = 0.2;
    self.animationRepeatCount = 1;
    [self startAnimating];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.2];
    bossPlane = nil;
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
