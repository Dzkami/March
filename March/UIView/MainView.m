//
//  MainView.m
//  March
//
//  Created by Dzkami on 2018/6/30.
//  Copyright © 2018 Dzkami. All rights reserved.
//

#import "MainView.h"

@interface MainView () {
    CGPoint startTouchPoint;
}
@end

@implementation MainView

- (id)init {
    self = [super init];
    if(self) {
//        [self addGesture];
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 50) / 2, SCREEN_HEIGHT / 2, 50, 30)];
        [lb setText:@"zaizaizai"];
        [self addSubview:lb];
    }
    
    return self;
}

@end
