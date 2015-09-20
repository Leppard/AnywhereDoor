//
//  RecordTimingView.h
//  Baixing
//
//  Created by Leppard on 9/6/15.
//  Copyright (c) 2015 Baixing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordTimingView : UIView

// 默认的rippleRadius表示ripple宽度倍数，默认是1
- (void)setRadius:(CGFloat)radius;

- (void)startRecording;

- (void)stopRecording;

@end
