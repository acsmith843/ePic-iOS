//
//  User.h
//  ePic
//
//  Created by Adam Smith on 6/11/13.
//  Copyright (c) 2013 acs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *eMail;
@property (nonatomic, strong) NSString *facebookId;
@property (nonatomic, strong) NSMutableArray *albums;

@end
