//
//  BossBullet.m
//  1949
//
//  Created by qianfeng on 14-9-16.
//  Copyright (c) 2014年 KG. All rights reserved.
//

#import "BossBullet.h"
#import "BossPlan.h"

@implementation BossBullet

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(id)init{
    
    if (self=[super init]) {
        self.frame=CGRectMake(0, 0, 10, 10);
        BossPlan *bossplan=[BossPlan currentBossPlane];
        self.center=CGPointMake(bossplan.center.x, bossplan.center.y + 60);
        self.image = [UIImage imageNamed:@"superbullet"];
    }
    return self;
    
}
-(void)BossBulletFlay{
    
    
    CGPoint center=self.center;
    center.y+=20;
    self.center=center;
    
    
    
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
