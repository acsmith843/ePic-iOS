//
//  User.h
//  ePic
//
//  Created by Adam Smith on 6/11/13.
//  Copyright (c) 2013 acs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *eMail;
@property (nonatomic, strong) NSString *facebookId;
@property (nonatomic, strong) NSMutableArray *albums;

@end
