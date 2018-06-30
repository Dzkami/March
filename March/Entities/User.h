//
//  User.h
//  March
//
//  Created by Dzkami on 2018/6/29.
//  Copyright © 2018 Dzkami. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
- (id)initWithId:(NSString *)userId name:(NSString *)name andPassword:(NSString *)password;
- (NSString *)userId;
- (void)setUserId:(NSString *)userId;
- (NSString *)userName;
- (void)setUserName:(NSString *)userName;
- (NSString *)password;
- (void)setPassword:(NSString *)password;
@end
