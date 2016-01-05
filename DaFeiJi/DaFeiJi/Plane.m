//
//  Plane.m
//  1949
//
//  Created by KG on 14-9-16.
//  Copyright (c) 2014年 KG. All rights reserved.
//

#import "Plane.h"

@implementation Plane

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)planeMove
{
    CGPoint center = self.center;
    center.x += self.xSpeed;
    center.y += self.ySpeed;
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
