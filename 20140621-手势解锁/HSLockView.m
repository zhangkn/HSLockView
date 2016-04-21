//
//  HSLockView.m
//  20140621-手势解锁
//
//  Created by devzkn on 4/21/16.
//  Copyright © 2016 hisun. All rights reserved.
//

#import "HSLockView.h"

@interface HSLockView ()
@property (nonatomic,strong) NSMutableArray *btns;//存储选中按钮
@property (nonatomic,assign) CGPoint pos;//当前手指的位置
@property (nonatomic,assign) BOOL isEnd;//手指是否停止移动



@end
@implementation HSLockView
- (NSMutableArray *)btns{
    if (nil == _btns) {
        _btns = [NSMutableArray array];
    }
    return _btns;
}

#if 0
- (void)awakeFromNib{
    //绘制九宫格
}
#endif

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        //绘制九宫格按钮
        [self addBtns];
    }
    return self;
    
}

/**
 绘制九宫格
 */
- (void)addBtns{
    UIImage *normalImage = [UIImage imageNamed:@"gesture_node_normal"];
    UIImage *highlightedImage = [UIImage imageNamed:@"gesture_node_highlighted"];

    for (int i=0; i<9; i++) {
        //绘制按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        //设置共性信息
        [btn setImage:normalImage forState:UIControlStateNormal];
        [btn setImage:highlightedImage forState:UIControlStateSelected];//选中状态要手动管理
        /**
         处理按钮点击事件：
         方式一：addTarget:self
         方式二；touches ，设置按钮为不可交互，交给VIew进行处理(事件的传递原理)
         */
        //添加监听方法，进行性手动管理选中状态
//        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchDown];
        [btn setUserInteractionEnabled:NO];

        [self addSubview:btn];
    }
}

#pragma  mark - 点击事件
#if 0
- (void)clickBtn:(UIButton*)btn{
    [btn setSelected:YES];
}
#endif

#pragma  mark - 使用touches方法 进行按钮的选中处理

/** 获取当前触摸点的坐标*/
- (CGPoint) getPosWithTouches:(NSSet *)touches{
    if (touches == nil) {
        return CGPointZero;
    }
    UITouch *touch = [touches anyObject];//Returns one of the objects in the set, or nil if the set contains no objects.
    return [touch locationInView:self];//当前触摸点
}

- (UIButton *) getButtonWithPos:(CGPoint)pos{
    UIButton *posBtn ;
    for (UIButton *btn in self.subviews) {
        BOOL flg = CGRectContainsPoint(btn.frame, pos);
        if (flg) {
             posBtn = btn;
            break;
        }
    }
    return posBtn;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    for (UIButton *btn in self.subviews) {
        [btn setSelected:NO];
    }
    self.isEnd = YES;
    [self setNeedsDisplay];


    
}

/**控制按钮的选择状态 */
#if 0
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
   
}
#endif

- (void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint pos = [self getPosWithTouches:touches];
    [self setPos:pos];
    UIButton *btn = [self getButtonWithPos:pos];
    if (btn && btn.selected == NO) {
        [btn setSelected:YES];
        if (![self.btns containsObject:btn]) {
            [self.btns addObject:btn];//存储选中按钮
        }
    }
    [self setNeedsDisplay];//绘制

}



#pragma mark - 画线

- (void)drawRect:(CGRect)rect{
    if (self.btns.count == 0) {
        return;
    }
    //开始绘制
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (int i=0; i<self.btns.count; i++) {
        UIButton *btn = self.btns[i];
        if (i==0) {
            [path moveToPoint:btn.center];
        }else{
            [path addLineToPoint:btn.center];
        }
    }
   
    if (!self.isEnd) {//移动的时候，进行绘制最后一个点到手指移动的线段
        [path addLineToPoint:self.pos];
    }
    //设置绘图状态
    [[UIColor greenColor]set];
    [path  setLineWidth:10];
    [path setLineCapStyle:kCGLineCapRound];
    [path  setLineJoinStyle:kCGLineJoinRound];
    
    [path stroke];
}



#pragma mark - layoutSubviews 设置子视图的位置信息

- (void)layoutSubviews{
    [super layoutSubviews];
    //设置位置信息
    CGFloat btnWidth = 74;
    CGFloat btnHeight = 74;
    CGFloat x = 0;
    CGFloat y = 0;
    int col = 0;//所在的列数
    int row = 0;//所在的行数
    int tolCol = 3;//总列数
    CGFloat viewWidth = CGRectGetWidth(self.frame);
    CGFloat viewHeight = CGRectGetHeight(self.frame);
    CGFloat rowMargin = (viewWidth - tolCol*btnWidth)*0.25;//间距
    CGFloat colMargin = (viewHeight - tolCol*btnHeight)*0.25;//间距

    for (int i =0; i<9; i++) {
        //绘制
        UIButton *btn = self.subviews[i];
        //计算所在的列数
        col = i % tolCol;
        row = i / tolCol;//所在行数
        x = col*(rowMargin+btnWidth)+rowMargin;//x 与所在的列相关
        y = row*(colMargin+btnHeight)+colMargin;
        [btn setFrame:CGRectMake(x, y, btnWidth, btnHeight)];
    }
    
}



@end
