//
//  Album.h
//  ePic
//
//  Created by Adam Smith on 6/12/13.
//  Copyright (c) 2013 acs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Album : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *ownerId;
@property (nonatomic, strong) NSString *ownerName;
@property (nonatomic, strong) NSMutableArray *images;

@end
