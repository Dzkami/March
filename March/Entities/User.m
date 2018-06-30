//
//  User.m
//  March
//
//  Created by Dzkami on 2018/6/29.
//  Copyright © 2018 Dzkami. All rights reserved.
//

#import "User.h"
@interface User() {
    NSString *_userId;
    NSString *_userName;
    NSString *_password;
}
@end

@implementation User
- (id)initWithId:(NSString *)userId name:(NSString *)userName andPassword:(NSString *)password {
    self = [super init];
    if(self) {
        _userId = userId;
        _userName = userName;
        _password = password;
    }
    
    return self;
}

- (NSString *)userId {
    return _userId;
}

- (void)setUserId:(NSString *)userId {
    _userId = userId;
}

- (NSString *)userName {
    return _userName;
}

- (void)setUserName:(NSString *)userName {
    _userName = userName;
}

- (NSString *)password{
    return _password;
}

- (void)setPassword:(NSString *)password {
    _password = password;
}

@end
