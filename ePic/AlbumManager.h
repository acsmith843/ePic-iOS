//
//  AlbumManager.h
//  ePic
//
//  Created by Adam Smith on 6/17/13.
//  Copyright (c) 2013 acs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlbumManager : NSObject

- (void)createAlbum:(NSDictionary *)albumDic completion:(void (^)(BOOL success))callbackBlock;;

@end
