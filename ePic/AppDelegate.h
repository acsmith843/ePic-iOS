//
//  AppDelegate.h
//  ePic
//
//  Created by Adam Smith on 6/10/13.
//  Copyright (c) 2013 acs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "User.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

extern NSString *const FBSessionStateChangedNotification;

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) User *currentUser;

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
- (void) closeSession;
+ (NSString *)FBErrorCodeDescription:(FBErrorCode) code;

@end
