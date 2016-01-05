//
//  Plane.h
//  1949
//
//  Created by KG on 14-9-16.
//  Copyright (c) 2014年 KG. All rights reserved.
//

#import <UIKit/UIKit.h>
//飞机的基类，父类
@interface Plane : UIImageView
//飞机的横轴移动速度
@property (nonatomic) int xSpeed;
//飞机的纵轴移动速度
@property (nonatomic) int ySpeed;
//飞机的血量
@property (nonatomic) int blood;
//飞机移动方法
-(void)planeMove;
@end








