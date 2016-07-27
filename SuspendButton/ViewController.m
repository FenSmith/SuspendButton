//
//  ViewController.m
//  SuspendButton
//
//  Created by tangwei on 16/7/27.
//  Copyright © 2016年 tangwei. All rights reserved.
//

#import "ViewController.h"

#define LRRowHeight 240

#define LRCount 10

#define LRGetImage(row) [UIImage imageNamed:[NSString stringWithFormat:@"%zd",row]]

#define kAngle (90.0 * M_PI) / 180.0

static NSString * const LRCellId = @"LRAnimationCellId";

@interface ViewController ()
<
   UITableViewDelegate,
   UITableViewDataSource,
   UIScrollViewDelegate
>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, assign) CGFloat lastScrollOffset;
/**设置cell角度 */
@property (nonatomic, assign) CGFloat angle;
/**设置cell锚点 */
@property (nonatomic, assign) CGPoint cellAnchorPoint;

@property(strong, nonatomic)  UIWindow *window;

@property(strong, nonatomic)  UIButton *button1;

@property(strong, nonatomic)  UIButton *button2;

@property(strong, nonatomic)  UIButton *button3;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self init_ui];
    
    //需要在rootviewcontroller生成后覆盖window，否则会奔溃
    [self performSelector:@selector(createButton) withObject:nil afterDelay:1];
}

- (void) viewWillDisappear:(BOOL)animated
{
    if ( self.window ) {
        [self.window resignKeyWindow];
        self.window = nil;
    }
}

- (void) init_ui
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.rowHeight = LRRowHeight;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bak"]];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (void) createButton
{
    self.button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button1 setTitle:@"悬浮按钮1" forState:UIControlStateNormal];
    self.button1.layer.cornerRadius = 10;
    self.button1.layer.masksToBounds = YES;
    self.button1.frame = CGRectMake(0, 0, 80, 40);
    self.button1.backgroundColor = [UIColor redColor];
    [self.button1 addTarget:self action:@selector(onClick1) forControlEvents:UIControlEventTouchUpInside];
    
    self.button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button2 setTitle:@"悬浮按钮2" forState:UIControlStateNormal];
    self.button2.layer.cornerRadius = 10;
    self.button2.layer.masksToBounds = YES;
    self.button2.frame = CGRectMake(0, 50, 80, 40);
    self.button2.backgroundColor = [UIColor redColor];
    [self.button2 addTarget:self action:@selector(onClick2) forControlEvents:UIControlEventTouchUpInside];
    
    self.button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button3 setTitle:@"悬浮按钮3" forState:UIControlStateNormal];
    self.button3.layer.cornerRadius = 10;
    self.button3.layer.masksToBounds = YES;
    self.button3.frame = CGRectMake(0, 100, 80, 40);
    self.button3.backgroundColor = [UIColor redColor];
    [self.button3 addTarget:self action:@selector(onClick3) forControlEvents:UIControlEventTouchUpInside];
    
    self.window = [[UIWindow alloc] initWithFrame:CGRectMake(ScreenWidth - 80, ScreenHeight * 0.6, 80, 140)];
    self.window.windowLevel = UIWindowLevelAlert + 1;
    self.window.backgroundColor = [UIColor clearColor];
    [self.window addSubview:self.button1];
    [self.window addSubview:self.button2];
    [self.window addSubview:self.button3];
    [self.window makeKeyAndVisible];//关键语句,显示window
}

- (void) onClick1
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"点击了按钮1" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (void) onClick2
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"点击了按钮2" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (void) onClick3
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"点击了按钮3" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return LRCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LRCellId];
    if ( !cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LRCellId"];
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, LRRowHeight)];
        [image setTag:1000];
        [cell addSubview:image];
    }

    UIImageView *image = (UIImageView *)[cell viewWithTag:1000];
    image.image = LRGetImage(indexPath.row + 1);
    
    [self setAnimate:cell];
    
    return cell;
}

/**
 * 此方法的效果是单独存在的, 可以拿出去单独使用
 */
#if 0
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DRotate(transform, 0, 0, 0, 1);//渐变
    transform = CATransform3DTranslate(transform, -200, 0, 0);//左边水平移动
    //        transform = CATransform3DScale(transform, 0, 0, 0);//由小变大
    
    cell.layer.transform = transform;
    cell.layer.opacity = 0.0;
    
    [UIView animateWithDuration:0.6 animations:^{
        cell.layer.transform = CATransform3DIdentity;
        cell.layer.opacity = 1;
    }];
}
#endif

//设置动画
- (void) setAnimate:(UITableViewCell *) cell
{
    CATransform3D transform = CATransform3DMakeRotation(_angle, 0.0, 0.5, 0.3);
    /**
     
     struct CATransform3D
     {
     CGFloat m11, m12, m13, m14;
     CGFloat m21, m22, m23, m24;
     CGFloat m31, m32, m33, m34;
     CGFloat m41, m42, m43, m44;
     };
     
     typedef struct CATransform3D CATransform3D;
     
     m34:实现透视效果(意思就是:近大远小), 它的值默认是0, 这个值越小越明显
     
     */
    transform.m34 = -1.0/500.0; // 设置透视效果
    cell.layer.transform = transform;
    
    cell.layer.anchorPoint = _cellAnchorPoint;
    
    [UIView animateWithDuration:0.6 animations:^{
        
        cell.layer.transform = CATransform3DIdentity;
    }];
}

//滚动监听
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView != self.tableView) return;
    
    CGFloat y = scrollView.contentOffset.y;
    
    if (y > _lastScrollOffset) {//用户往上拖动
        // x=0 y=0 左
        // x=1 y=0 -angle 右
        _angle = - kAngle;
        _cellAnchorPoint = CGPointMake(1, 0);
        
    } else {//用户往下拖动
        // x=0 y=1 -angle 左
        // x=1 y=1 右
        _angle =  - kAngle;
        _cellAnchorPoint = CGPointMake(0, 1);
    }
    //存储最后的y值
    _lastScrollOffset = y;
    
    [UIView animateWithDuration:0.6 animations:^{
        
        self.window.frame = CGRectMake(ScreenWidth, ScreenHeight * 0.6, 80, 140);
    }];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0.6 animations:^{
        
        self.window.frame = CGRectMake(ScreenWidth - 80, ScreenHeight * 0.6, 80, 140);
    }];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
{
    [UIView animateWithDuration:0.6 animations:^{
        
        self.window.frame = CGRectMake(ScreenWidth - 80, ScreenHeight * 0.6, 80, 140);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
