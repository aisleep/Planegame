//
//  Bullet.m
//  1949
//
//  Created by KG on 14-9-16.
//  Copyright (c) 2014年 KG. All rights reserved.
//

#import "Bullet.h"
#import "MyPlane.h"
@implementation Bullet
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
        self.frame = CGRectMake(0, 0, 10, 10);
        MyPlane * myPlane = [MyPlane currentMyPlane];
        self.center = myPlane.center;
        self.image = [UIImage imageNamed:@"bullet"];
    }
    return self;
}
//让子弹飞一会
-(void)bulletFly
{
    CGPoint center = self.center;
    center.y -= 20;
    self.center = center;
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
