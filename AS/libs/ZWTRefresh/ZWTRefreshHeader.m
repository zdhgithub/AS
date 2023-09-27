//
//  ZWTRefreshHeader.m
//  ZWTUIKit
//
//  Created by 李名扬 on 2019/9/2.
//

#import "ZWTRefreshHeader.h"
//#import "ZWTSkinTool.h"
//#import "SmartKitTools.h"

@implementation ZWTRefreshHeader

+ (ZWTRefreshHeader *)zwt_headerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock {
    
    ZWTRefreshHeader *header = [ZWTRefreshHeader headerWithRefreshingBlock:refreshingBlock];
    // Set the ordinary state of animated images
    header.lastUpdatedTimeLabel.hidden = YES;
    
    // Hide the status
    header.stateLabel.hidden = YES;
    
    if (true) {//[SmartKitTools isqh]

    }else{
        NSMutableArray *refresh = [NSMutableArray array];
      
        for (int i = 0; i < 40; i++) {
            NSString *refreshIcon = [NSString stringWithFormat:@"zwt_refresh_icon_%d",i];
            UIImage *image = [UIImage imageNamed:refreshIcon];
            [refresh addObject:image];
        }
        
        [header setImages:refresh duration:0.7 forState:MJRefreshStateIdle];
        // Set the pulling state of animated images（Enter the status of refreshing as soon as loosen）
        [header setImages:refresh duration:0.7  forState:MJRefreshStatePulling];
        // Set the refreshing state of animated images
        [header setImages:refresh duration:0.7  forState:MJRefreshStateRefreshing];
    }
    
    // Set header

    // Hide the time
    header.lastUpdatedTimeLabel.hidden = YES;
    
    // Hide the status
    header.stateLabel.hidden = YES;
    return header;
}

- (void)zwt_endRefreshing {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self endRefreshing];
    });
}

-(void)setState:(MJRefreshState)state {
    
    if (true) {//[SmartKitTools isqh]
        MJRefreshCheckState

        // 根据状态做事情
        if (state == MJRefreshStatePulling || state == MJRefreshStateRefreshing) {
            [self startAnimation];
        } else if (state == MJRefreshStateIdle) {
            [self stopAnimation];
        }
    }
}

-(void)startAnimation {
    CABasicAnimation *animation= [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.toValue = [NSNumber numberWithFloat:M_PI*2];
    animation.duration = 1.0;
    animation.cumulative = YES;
    animation.repeatCount = INT_MAX;
    self.gifView.image = [UIImage imageNamed:@"loading_header"];
    [self.gifView.layer addAnimation:animation forKey:@"ZWTHubLoadAnimation"];
}
-(void)stopAnimation {
    [self.gifView.layer removeAllAnimations];
}

@end
