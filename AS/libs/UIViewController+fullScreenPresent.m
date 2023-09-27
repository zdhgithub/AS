//
//  UIViewController+fullScreenPresent.m
//  mx2app
//
//  Created by dh on 10/12/22.
//

#import "UIViewController+fullScreenPresent.h"
#import "DHTools.h"

@implementation UIViewController (fullScreenPresent)

//+ (void)load {
//    [super load];
//    dh_swizzleMethod([self class], @selector(presentViewController:animated:completion:), @selector(override_presentViewController:animated:completion:));
//}


#pragma mark - Swizzling
- (void)override_presentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(void (^ __nullable)(void))completion{
    if(@available(iOS 13.0, *)){
        if (viewControllerToPresent.modalPresentationStyle ==  UIModalPresentationPageSheet){
            viewControllerToPresent.modalPresentationStyle = UIModalPresentationFullScreen;
        }
    }
    
    [self override_presentViewController:viewControllerToPresent animated:flag completion:completion];
}

@end
