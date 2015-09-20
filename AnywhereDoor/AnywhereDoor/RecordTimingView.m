//
//  RecordTimingView.m
//  Baixing
//
//  Created by Leppard on 9/6/15.
//  Copyright (c) 2015 Baixing. All rights reserved.
//

#import "RecordTimingView.h"
#import <Masonry.h>

@interface RecordTimingView()

@property (strong, nonatomic) UIImageView *bgView;
@property (strong, nonatomic) UIImage *rippleImage;
@property (weak, nonatomic) NSTimer *rippleTimer;
@property (strong, nonatomic) NSTimer *recordTimer;
@property (strong, nonatomic) UILabel *recordLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (assign, nonatomic) int timeCount;
@property (assign, nonatomic) CGFloat rippleRadius;

@end

@implementation RecordTimingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        [self setUpViewsWithConstraints];
    }
    return self;
}

#pragma mark - common methods -

- (void)setUpViewsWithConstraints
{
    UIButton *btn = [[UIButton alloc] init];
    [btn addTarget:self action:@selector(dismissView:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:btn];
    [self addSubview:self.bgView];
    [self addSubview:self.recordLabel];
    [self addSubview:self.timeLabel];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.height.and.width.equalTo(@90);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@21);
        make.center.equalTo(self);
    }];
    [self.recordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@14);
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(2);
    }];
}

- (void)dismissView:(id)sender
{
    [self removeFromSuperview];
}

- (void)startRecording
{
    self.timeCount = 0;
    self.recordLabel.text = @"录音中";
    self.rippleRadius = 1;
    [self startRippleAnimation];
    [self updateTimeLabel];
}

- (void)startRippleAnimation
{
    if (self.rippleTimer) {
        return;
    }
    self.rippleTimer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(rippleTrigger:) userInfo:nil repeats:YES];
    self.recordTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTimeLabel) userInfo:nil repeats:YES];
}

- (void)updateTimeLabel
{
    self.timeCount ++;
    self.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d", self.timeCount/60, self.timeCount%60];
}

- (void)stopRecording
{
    if (self.rippleTimer) {
        [self.rippleTimer invalidate];
        self.rippleTimer = nil;
    }
    if (self.recordTimer) {
        [self.recordTimer invalidate];
        self.recordTimer = nil;
    }
    self.recordLabel.text = @"完成";
}

- (void)setRadius:(CGFloat)radius
{
    self.rippleRadius = radius;
}

- (void)rippleTrigger:(NSTimer *)timer
{
    CGFloat radius = 90;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2-radius/2, self.frame.size.height/2-radius/2, radius, radius)];
    [imageView setImage:self.rippleImage];
    
    [self addSubview:imageView];
    
    [UIView animateWithDuration:3.0f animations:^{
        imageView.frame = CGRectMake(self.frame.size.width/2-radius*self.rippleRadius, self.frame.size.height/2-radius*self.rippleRadius, radius*self.rippleRadius*2, radius*self.rippleRadius*2);
        imageView.alpha = 0;
    } completion:^(BOOL finished) {
        [imageView removeFromSuperview];
    }];
}

#pragma mark - getter & setter -

- (UIImage *)rippleImage
{
    if (!_rippleImage) {
        CGGradientRef gradient;
        CGColorSpaceRef colorSpace;
        size_t locations_num = 5;
        
        CGFloat locations[5] = {0.0, 0.4, 0.5, 0.7, 1.0};
        
        CGFloat components[20] = {
            1.0, 1.0, 1.0, 0,
            1.0, 1.0, 1.0, 0,
            255/255.0, 68/255.0, 102/255.0, 0.0,
            255/255.0, 68/255.0, 102/255.0, 0.3,
            255/255.0, 68/255.0, 102/255.0, 0.9
        };
        
        colorSpace = CGColorSpaceCreateDeviceRGB();
        
        gradient = CGGradientCreateWithColorComponents (colorSpace, components,
                                                        locations, locations_num);
        CGPoint startPoint, endPoint;
        //这个半径随意定的
        CGFloat radius = self.frame.size.width;
        
        startPoint.x = radius*2;
        startPoint.y = radius*2;
        endPoint.x = radius*2;
        endPoint.y = radius*2;
        
        UIGraphicsBeginImageContext(CGSizeMake(radius*4, radius*4));
        CGContextRef imageContext = UIGraphicsGetCurrentContext();
        CGContextSetAllowsAntialiasing(imageContext, TRUE);
        
        CGContextDrawRadialGradient(imageContext, gradient, startPoint, 0, endPoint, radius*2, 0);
        
        _rippleImage = UIGraphicsGetImageFromCurrentImageContext();
        
        CGColorSpaceRelease(colorSpace);
        CGGradientRelease(gradient);
        UIGraphicsEndImageContext();
    }
    return _rippleImage;
}

- (UIImageView *)bgView
{
    if (!_bgView) {
        UIGraphicsBeginImageContext(CGSizeMake(90, 90));
        CGContextRef imageContext = UIGraphicsGetCurrentContext();
        CGContextSetAllowsAntialiasing(imageContext, TRUE);
        CGRect rect = CGRectMake(0, 0, 90, 90);
        CGContextSetFillColorWithColor(imageContext, [UIColor colorWithRed:255/255.0 green:68/255.0 blue:102/255.0 alpha:1.0].CGColor);
        CGContextFillEllipseInRect(imageContext, rect);
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        _bgView = [[UIImageView alloc] initWithImage:image];
    }
    return _bgView;
}

- (UILabel *)recordLabel
{
    if (!_recordLabel) {
        _recordLabel = [[UILabel alloc] init];
        _recordLabel.textColor = [UIColor whiteColor];
        _recordLabel.font = [UIFont systemFontOfSize:12];
        _recordLabel.text = @"";
    }
    return _recordLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:18];
        _timeLabel.text = @"00:00";
    }
    return _timeLabel;
}

@end