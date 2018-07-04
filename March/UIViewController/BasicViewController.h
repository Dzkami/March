//
//  BasicViewController.h
//  March
//
//  Created by Dzkami on 2018/6/29.
//  Copyright © 2018 Dzkami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SqliteUtil.h"
#import "Util.h"

@interface BasicViewController : UIViewController
- (void)presentViewController:(UIViewController *)viewControllerToPresent
                     animated:(BOOL)animated
                   completion:(void (^)(void))completion
                    pushStyle:(BOOL)isPushStyle;
@end
