//
//  ViewController.m
//  DaFeiJi
//
//  Created by 小希 on 15/12/27.
//  Copyright © 2015年 小希. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "ViewController.h"
#import "MyPlane.h"
//#import "Direction.h"
#import "EnemyPlane.h"
#import "Bullet.h"
#import "BossPlan.h"
#import "BossBullet.h"

#define HITNUMBER 5     //击毁数, 用于判定出现BOSS的条件
#define MYHIT 1         //我方子弹攻击力
#define BOSSHIT 10      //BOSS子弹攻击力
#define BOSSBLOOD 10    //BOSS血量

#define MYBULLETSTIME 0.2                               //我方子弹生成速度
#define BOSSBULLETSTIME (0.18 - _level * 0.01)          //BOSS子弹生成速度
#define BOSSMOVETIME (0.2 - _level * 0.01)              //BOSS移动速度

@interface ViewController ()
{
    CGRect _winFrame;                                   //屏幕尺寸
    //模型
    NSMutableArray * _enemyPlanes;                      //敌机数组
    NSMutableArray * _myBullets;                        //我方子弹数组
    NSMutableArray * _bossBullets;                      //BOSS子弹数组
    
    NSTimer * _gameTimer;                               //游戏运行计时器
    NSTimer * _bossMoveTimer;                           //BOSS移动计时器
    NSTimer * _bossBulletsTimer;                        //BOSS子弹计时器
    NSTimer * _myBulletsTimer;                          //我方子弹计时器
    
    
    int _hitCount;                                      //击毁计数
    int _ifBoss;                                        //BOSS存在判定
    int _scores;                                        //游戏分数
    int _level;                                         //游戏关卡
    
    __weak BossPlan *_bossPlane;                        //BOSS飞机
    __weak MyPlane* _myPlane;                           //我方飞机
    
    AVAudioPlayer *_gameMusicPlayer;                    //游戏背景音乐
    
    SystemSoundID _gameOverSoundID;                     //游戏结束音效
    SystemSoundID _bulletSoundID;                       //子弹音效
    SystemSoundID _bossDownSoundID;
}

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;             //游戏标题标签
@property (strong, nonatomic) IBOutlet UIButton *startButton;           //开始按钮
@property (strong, nonatomic) IBOutlet UIButton *exitButton;            //退出按钮
@property (strong, nonatomic) IBOutlet UILabel *scoresLabel;            //分数标签
@property (strong, nonatomic) IBOutlet UILabel *levelLabel;             //关卡标签
@property (nonatomic) UIImageView * bgImageView;                        //背景图片
@end

@implementation ViewController
#pragma mark 游戏初始化 -
//设置背景
-(void)prepareBackgroundImage
{
    self.bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _winFrame.size.width, _winFrame.size.height)];
    self.bgImageView.image = [UIImage imageNamed:@"background"];
    [self.view insertSubview:self.bgImageView atIndex:0];
}

//准备我的飞机
-(void)creatMyPlane
{
    _myPlane = [MyPlane currentMyPlane];
    [self.bgImageView addSubview:_myPlane];
}

////准备我的方向盘
//-(void)creatDirection
//{
//    Direction * direction = [[Direction alloc]init];
//    [self.view addSubview:direction];
//    
//}


-(void)prepareArray
{
    //初始化敌机数组
    //这个数组用来管理敌机
    _enemyPlanes = [[NSMutableArray alloc]init];
    
    //初始化我的子弹数组
    _myBullets = [[NSMutableArray alloc]init];
    
    _bossBullets=[[NSMutableArray alloc]init];
    
}
#pragma mark -
#pragma mark 计时器调用 -
//准备敌机
-(void)creatEnemyPlane
{
    static int n =  0;
    if (n++ % 5 == 0) {
        EnemyPlane * enemy = [[EnemyPlane alloc] initWithWinFrame:_winFrame];
        [self.bgImageView addSubview:enemy];
        [_enemyPlanes addObject:enemy];
    }
    
}

-(void)allPlaneFly
{
    //遍历数组中的所有飞机
    for (int i = 0; i<_enemyPlanes.count; i++) {
        //取出一个飞机
        EnemyPlane * enemy = [_enemyPlanes objectAtIndex:i];
        //让飞机飞一会
        [enemy planeMove];
        
        //用来去移除飞出屏幕的飞机
        if (enemy.center.y > _winFrame.size.height) {
            [enemy removeFromSuperview];
            [_enemyPlanes removeObject:enemy];
            i--;
        }
    }
}


//创建boss飞机
-(void)creatBOSS{
    _bossPlane = [BossPlan currentBossPlaneWithFrame:CGRectMake(_winFrame.size.width/2 - 60, -120, 120, 120)];
    _bossPlane.blood = BOSSBLOOD;
    [self.bgImageView addSubview:_bossPlane];
    NSLog(@"hahahahahahahah");
    
    _ifBoss = 1;            //Boss计数
    _hitCount = 0;          //击落计数归零
    //boss飞
    _bossMoveTimer = [NSTimer scheduledTimerWithTimeInterval:BOSSMOVETIME target:self selector:@selector(bossPlaneDownMove) userInfo:nil repeats:YES];
    //Boss子弹飞
    _bossBulletsTimer = [NSTimer scheduledTimerWithTimeInterval:BOSSBULLETSTIME target:self selector:@selector(prepareBossBullet) userInfo:nil repeats:YES];
}
//Boss飞机移动
-(void)bossPlaneDownMove{
    CGPoint center= _bossPlane.center;
    if (center.y < _winFrame.size.height/4) {
        center.y += 10;
        _bossPlane.center=center;
    }else {
        [_bossMoveTimer invalidate];
        _bossMoveTimer = [NSTimer scheduledTimerWithTimeInterval:BOSSMOVETIME target:self selector:@selector(bossPlaneLiftMove) userInfo:nil repeats:YES];
    }
}

-(void)bossPlaneLiftMove{
    CGPoint center= _bossPlane.center;
    if(center.x > 0) {
        center.x -= 10;
        _bossPlane.center=center;
    }else {
        [_bossMoveTimer invalidate];
        _bossMoveTimer = [NSTimer scheduledTimerWithTimeInterval:BOSSMOVETIME target:self selector:@selector(bossPlaneRightMove) userInfo:nil repeats:YES];
    }
    
}

-(void)bossPlaneRightMove{
    CGPoint center=_bossPlane.center;
    if (center.x < _winFrame.size.width) {
        center.x += 10;
        _bossPlane.center=center;
    }else {
        [_bossMoveTimer invalidate];
        _bossMoveTimer = [NSTimer scheduledTimerWithTimeInterval:BOSSMOVETIME target:self selector:@selector(bossPlaneLiftMove) userInfo:nil repeats:YES];
    }
    
}
//准备子弹
-(void)prepareBullet
{
    static int myTime = 0;
    if (myTime++ % 3 == 0) {
        Bullet * myBullet = [[Bullet alloc]init];
        [self.bgImageView addSubview:myBullet];
        [_myBullets addObject:myBullet];
        if (!_bulletSoundID) {
            NSURL *url = [[NSBundle mainBundle] URLForResource:@"bullet" withExtension:@"mp3"];
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &_bulletSoundID);
        }
        AudioServicesPlaySystemSound(_bulletSoundID);
    }
}

-(void)prepareBossBullet{
    if (_ifBoss) {
        static int bossBulletTime=0;
        if (bossBulletTime++ % 3==0) {
            BossBullet *bossbullet=[[BossBullet alloc]init];
            [self.bgImageView addSubview:bossbullet];
            [_bossBullets addObject:bossbullet];
        }
    }
}

//Boss子弹飞
-(void)allBossBulletFly{
    
    for (int i=0; i<_bossBullets.count; i++) {
        BossBullet *bullet=[_bossBullets objectAtIndex:i];
        [bullet BossBulletFlay];
        
        if (bullet.center.y>_winFrame.size.height) {
            [bullet removeFromSuperview];
            [_bossBullets removeObject:bullet];
            i--;
        }
    }
    
}

//让所有的子弹飞起来
-(void)allBulletFly
{
    for (int i = 0; i<_myBullets.count; i++) {
        Bullet * bullet = [_myBullets objectAtIndex:i];
        [bullet bulletFly];
        
        if (bullet.center.y < 0) {
            [bullet removeFromSuperview];
            [_myBullets removeObject:bullet ];
            i--;
        }
    }
}


//碰撞检测
-(void)crashCheck
{
    Bullet* myBullet = nil;
    Bullet* bossBullet = nil;
    for (int j = 0;j<_myBullets.count; j++) {
        myBullet = [_myBullets objectAtIndex:j];
        //BossPlan与我方子弹碰撞检测
        if (_ifBoss == 1) {
            if (CGRectIntersectsRect(_bossPlane.frame, myBullet.frame)) {
                _bossPlane.blood -= MYHIT;
                _scores += 2;
                [self setScoresLabel];
                NSLog(@"%d", _bossPlane.blood);
                
                [myBullet removeFromSuperview];
                [_myBullets removeObject:myBullet];
                j--;
                if (_bossPlane.blood == 0) {
                    _ifBoss = 0;
                    _level++;
                    [self setLevelLabel];
                    //销毁BOSS相关的计时器
                    [_bossBulletsTimer invalidate];
                    [_bossMoveTimer invalidate];
                    //销毁BOSS
                    [_bossPlane resetBossPlane];
                    
                }
            }
        }
        //敌方飞机与我方子弹碰撞判定
        for (int i = 0; i<_enemyPlanes.count; i++) {
            EnemyPlane * enemy = [_enemyPlanes objectAtIndex:i];
            //CGRectIntersectsRect 方法用来判断两个frame是否相交
            if (CGRectIntersectsRect(enemy.frame, myBullet.frame)) {
                [myBullet removeFromSuperview];
                [_myBullets removeObject:myBullet];
                j--;
                //开始播放爆炸动画
                [enemy startAnimating];
                //延迟0.2秒后执行移除操作
                [enemy performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.2];
                //延迟0.2秒后从数组中移除
                [_enemyPlanes performSelector:@selector(removeObject:) withObject:enemy afterDelay:0.2];
                i--;
                
                _scores++;
                [self setScoresLabel];
                
                if (_ifBoss == 0) {
                    _hitCount++;
                    
                    NSLog(@"%d", _hitCount);
                    
                    if (_hitCount == HITNUMBER) {
                        [self creatBOSS];
                    }
                   
                }
                break;
                
            }
            //我方飞机与敌机碰撞判定
            if (CGRectIntersectsRect(enemy.frame, _myPlane.frame)) {
                //开始播放爆炸动画
                [enemy startAnimating];
                [_myPlane startAnimating];
                [_myPlane performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.2];
                               //延迟0.2秒后执行移除操作
                [enemy performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.2];
                //延迟0.2秒后从数组中移除
                [_enemyPlanes performSelector:@selector(removeObject:) withObject:enemy afterDelay:0.2];
                
                [self gameOver];
            }
            
        }
        //我方飞机与BOSS子弹碰撞判定
        for (int i = 0; i < _bossBullets.count; i++) {
            bossBullet = [_bossBullets objectAtIndex:i];
            if (CGRectIntersectsRect(bossBullet.frame, myBullet.frame)) {
                [myBullet removeFromSuperview];
                [bossBullet removeFromSuperview];
                [_myBullets removeObject:myBullet];
                [_bossBullets removeObject:bossBullet];
                i--;
                j--;
                continue;
            }
            if (CGRectIntersectsRect(bossBullet.frame, _myPlane.frame)) {
                [_myPlane startAnimating];
                [_myPlane performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.2];
                
                [self gameOver];
            }
        }
    }
    
    
}
#pragma mark -
#pragma mark 游戏运行 -
-(void)prepareGame
{
    [self creatEnemyPlane];
    [self allPlaneFly];
    [self allBossBulletFly];
    [self allBulletFly];
    [self crashCheck];
    
    
}

//UITouch的一个方法，在触摸屏幕移动时，调用此方法
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    MyPlane * myPlane = [MyPlane currentMyPlane];
    UITouch * touch = [touches anyObject];
    
    myPlane.center = [touch locationInView:self.view];
}

-(void)gameOver{
    [_bossPlane stopAnimating];
    //销毁定时器
    [_myBulletsTimer invalidate];
    [_bossBulletsTimer invalidate];
    [_bossMoveTimer invalidate];
    [_gameTimer invalidate];
    
    
    [_enemyPlanes removeAllObjects];
    [_myBullets removeAllObjects];
    [_bossBullets removeAllObjects];
    if (!_gameOverSoundID) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"game_over" withExtension:@"mp3"];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &_gameOverSoundID);
    }
    AudioServicesPlaySystemSound(_gameOverSoundID);
    UIAlertController* gameOverController = [UIAlertController alertControllerWithTitle:@"Game OVer!" message:@"你被击毁! 少年是否再战?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesAction = [UIAlertAction actionWithTitle:@"再战!" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (_bossPlane) {
            [_bossPlane resetBossPlane];
        }
        //移除所有子视图
        //[self.bgImageView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.bgImageView removeFromSuperview];
        self.bgImageView = nil;
        
        [self startGameView];
       
    }];
    
    UIAlertAction* noAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        [_myPlane deallocMyPlane];
        if (_bossPlane) {
            [_bossPlane resetBossPlane];
        }
        //移除所有子视图
        //[self.bgImageView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.bgImageView removeFromSuperview];
        self.bgImageView = nil;
        
        [self loadGameView];
    }];
    
    [gameOverController addAction:yesAction];
    [gameOverController addAction:noAction];
    
    [self presentViewController:gameOverController animated:YES completion:nil];
}

-(void)setScoresLabel{
    NSString* scoresString = [NSString stringWithFormat:@"分数: %d", _scores];
    NSMutableAttributedString* labelText = [[NSMutableAttributedString alloc] initWithString:scoresString];
    [labelText addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, scoresString.length)];
    self.scoresLabel.attributedText = labelText;
    
}
-(void)setLevelLabel{
    NSString* levelString = [NSString stringWithFormat:@"关卡: %d", _level];
    NSMutableAttributedString* labelText = [[NSMutableAttributedString alloc] initWithString:levelString];
    [labelText addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, levelString.length)];
    self.levelLabel.attributedText = labelText;
}
//开始新游戏
-(void)startGameView{
    if (!self.bgImageView) {
    [self prepareBackgroundImage];
    }
    _ifBoss = 0;
    _scores = 0;
    _level = 1;
    
    [self setScoresLabel];
    [self setLevelLabel];
    [self prepareArray];
    [self creatMyPlane];
    [self prepareGame];
    
    _gameTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(prepareGame) userInfo:nil repeats:YES];
    _myBulletsTimer = [NSTimer scheduledTimerWithTimeInterval:MYBULLETSTIME target:self selector:@selector(prepareBullet) userInfo:nil repeats:YES];
}
//
-(void)loadGameView{
    [self prepareBackgroundImage];
    self.titleLabel.hidden = NO;
    self.startButton.hidden = NO;
    self.exitButton.hidden = NO;
    self.scoresLabel.hidden = YES;
    self.levelLabel.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _winFrame = [[UIScreen mainScreen] bounds];
    [self prepareBackgroundImage];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"game_music" withExtension:@"mp3"];
    _gameMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [_gameMusicPlayer prepareToPlay];
    [_gameMusicPlayer setVolume:1];         //设置音量
    _gameMusicPlayer.numberOfLoops = -1;    //播放循环
    [_gameMusicPlayer play];
}


- (IBAction)startPressed:(UIButton *)sender {
    self.titleLabel.hidden = YES;
    self.startButton.hidden = YES;
    self.exitButton.hidden = YES;
    self.scoresLabel.hidden = NO;
    self.levelLabel.hidden = NO;
    [self startGameView];
}

- (IBAction)exitPressed:(UIButton *)sender {
    exit(0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

@end
