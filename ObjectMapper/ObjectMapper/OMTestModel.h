//
//  OMTestModel.h
//  ObjectMapper
//
//  Created by Fabian Canas on 7/12/13.
//  Copyright (c) 2013 Fabian Canas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMTestModel : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *favoriteWord;
@property (nonatomic, assign) NSInteger favoriteNumber;
@property (nonatomic, strong) OMTestModel *favoriteModel;
@property (nonatomic, strong) NSColor *favoriteColor;
@end
