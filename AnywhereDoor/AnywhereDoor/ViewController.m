//
//  ViewController.m
//  AnywhereDoor
//
//  Created by Leppard on 9/19/15.
//  Copyright © 2015 Leppard. All rights reserved.
//

#import "ViewController.h"
#import "Definition.h"
#import "ISRDataHelper.h"
#import "iflyMSC/IFlySpeechRecognizerDelegate.h"
#import "iflyMSC/IFlySpeechRecognizer.h"
#import "AFNetworking.h"
#import "RecordTimingView.h"
#import "Masonry.h"

@interface ViewController () <IFlySpeechRecognizerDelegate>

//不带界面的识别对象
@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;
@property (nonatomic, strong) NSString *resultStr;
@property (nonatomic, strong) UILabel *resultLabel;
@property (nonatomic, strong) RecordTimingView *recordView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUpViews];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self initRecognizer];//初始化识别对象
}


-(void)viewWillDisappear:(BOOL)animated
{
    [_iFlySpeechRecognizer cancel]; //取消识别
    [_iFlySpeechRecognizer setDelegate:nil];
    [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
    
    [super viewWillDisappear:animated];
}

#pragma mark - Private Methods -

- (void)initRecognizer
{
    if (_iFlySpeechRecognizer == nil) {
        _iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
        
        [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
        
        //设置听写模式
        [_iFlySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
        
        //设置音频来源为麦克风
        [_iFlySpeechRecognizer setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
        
        //设置听写结果格式为json
        [_iFlySpeechRecognizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
        
        //保存录音文件，保存在sdk工作路径中，如未设置工作路径，则默认保存在library/cache下
        [_iFlySpeechRecognizer setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    }
    _iFlySpeechRecognizer.delegate = self;
}

- (void)setUpViews
{
    UIButton *btn = [[UIButton alloc] init];
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(startRecording:) forControlEvents:UIControlEventTouchDown];
    [btn addTarget:self action:@selector(stopRecording:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.recordView];
    [self.view addSubview:self.resultLabel];
    [self.view addSubview:btn];
    
    [self.recordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view.mas_width);
        make.height.equalTo(@100);
        make.centerY.equalTo(self.view.mas_centerY);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view.mas_width);
        make.height.equalTo(@50);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_top);
    }];
}

- (void)startRecording:(id)sender
{
    [self.recordView startRecording];
    [_iFlySpeechRecognizer startListening];
}

- (void)stopRecording:(id)sender
{
    [self.recordView stopRecording];
    [_iFlySpeechRecognizer stopListening];
}

/*识别结果返回代理
 @param resultArray 识别结果
 @ param isLast 表示是否最后一次结果
 */
- (void)onResults:(NSArray *)results isLast:(BOOL)isLast
{
    NSMutableString *result = [[NSMutableString alloc] init];
    NSDictionary *dic = [results objectAtIndex:0];
    
    for (NSString *key in dic) {
        [result appendFormat:@"%@",key];
    }
    NSString * resultFromJson = [ISRDataHelper stringFromJson:result];
    self.resultLabel.text = [NSString stringWithFormat:@"%@%@",self.resultLabel.text,resultFromJson];
    [self sendGetRequestWithResult:resultFromJson];
}


/*识别会话错误返回代理
 @ param  error 错误码
 */
- (void)onError: (IFlySpeechError *) error
{
    
}

- (void)sendGetRequestWithResult:(NSString *)result
{
    NSString *transStr = [result stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *params = @{@"content":transStr};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:ROOT_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark - getter & setter -

- (NSString *)resultStr
{
    if (!_resultStr) {
        _resultStr = [NSString stringWithFormat:@""];
    }
    return _resultStr;
}

- (UILabel *)resultLabel
{
    if (!_resultLabel) {
        _resultLabel = [[UILabel alloc] init];
        _resultLabel.text = @"";
    }
    return _resultLabel;
}

- (RecordTimingView *)recordView
{
    if (!_recordView) {
        _recordView = [[RecordTimingView alloc] init];
    }
    return _recordView;
}

@end
