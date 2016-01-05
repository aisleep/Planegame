//
//  MyPlane.h
//  1949
//
//  Created by KG on 14-9-16.
//  Copyright (c) 2014年 KG. All rights reserved.
//

#import "Plane.h"

@interface MyPlane : Plane
//我的战机，使用单例方法来创建
+(id)currentMyPlane;
-(void)deallocMyPlane;
@end
