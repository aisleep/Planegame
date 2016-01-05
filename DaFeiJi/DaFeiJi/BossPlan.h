//
//  BossPlan.h
//  1949
//
//  Created by qianfeng on 14-9-16.
//  Copyright (c) 2014年 KG. All rights reserved.
//

#import "Plane.h"

@interface BossPlan : Plane
+(BossPlan*)currentBossPlaneWithFrame:(CGRect)winFrame;
+(BossPlan*)currentBossPlane;
-(void)resetBossPlane;
@end
