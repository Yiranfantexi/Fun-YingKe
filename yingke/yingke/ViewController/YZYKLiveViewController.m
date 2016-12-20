//
//  YZYKLiveViewController.m
//  yingke
//
//  Created by yanzhen on 16/12/12.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import "YZYKLiveViewController.h"
#import "YZYKPreView.h"
#import "YZMediaTool.h"
#import "YZYKLiveAddress.h"
#import "LFLiveKit.h"
#import "YZYingKeMacro.h"

@interface YZYKLiveViewController ()<LFLiveSessionDelegate>
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIButton *startLiveBtn;

@property (nonatomic, strong) YZYKPreView *preView;
@property (nonatomic, strong) LFLiveSession *session;
@end

@implementation YZYKLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _preView = [[YZYKPreView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    [self.view addSubview:_preView];
    [self.view insertSubview:_preView atIndex:1];
    
    [YZMediaTool requestAccessForVideo];
    [YZMediaTool requestAccessForAudio];
    
    _session = [[LFLiveSession alloc] initWithAudioConfiguration:[LFLiveAudioConfiguration defaultConfiguration]  videoConfiguration:[LFLiveVideoConfiguration defaultConfigurationForQuality:LFLiveVideoQuality_Medium3]];
    _session.delegate = self;
    _session.showDebugInfo = NO;
    _session.preView = _preView;
#pragma mark - 可以自定义视频参数--YZMediaTool
    _session.running = YES;
}

- (NSString *)userLiveAddress{
    NSString *address = [YZYKLiveAddress getSelfLiveAddress];
    if (address.length > 0) return address;
    address = @"Funny_";
    address = [address stringByAppendingString:[NSString currentTime]];
    address = [address stringByAppendingFormat:@"_%@",[NSUUID UUID]];
    [YZYKLiveAddress saveSelfLiveAddress:address];
    return address;
}

- (IBAction)startLive:(UIButton *)sender {
    if (!sender.selected) {
        LFLiveStreamInfo *stream = [[LFLiveStreamInfo alloc] init];
        stream.url = [NSString stringWithFormat:YK_Live_Header,[self userLiveAddress]];
        [self.session startLive:stream];
    }else{
        [self.session stopLive];
    }
    sender.selected = !sender.selected;
    
}

- (IBAction)switchCamera:(id)sender {
    AVCaptureDevicePosition devicePositon = self.session.captureDevicePosition;
    self.session.captureDevicePosition = (devicePositon == AVCaptureDevicePositionBack) ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack;
}


- (IBAction)closeLive:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - LFLiveSessionDelegate
/** live status changed will callback */
- (void)liveSession:(nullable LFLiveSession *)session liveStateDidChange:(LFLiveState)state{
    NSArray *status = @[@"准备中",@"连接中",@"已连接",@"已断开",@"连接出错",@"刷新中"];
    self.stateLabel.text = status[state];
}
/** live debug info callback */
- (void)liveSession:(nullable LFLiveSession *)session debugInfo:(nullable LFLiveDebug *)debugInfo{
    
}
/** callback socket errorcode */
- (void)liveSession:(nullable LFLiveSession *)session errorCode:(LFLiveSocketErrorCode)errorCode{
    NSLog(@"TTTT-errorCode:%zd",errorCode);
}
@end
