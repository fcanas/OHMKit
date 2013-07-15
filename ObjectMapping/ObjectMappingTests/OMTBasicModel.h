//
//  OMTBasicModel.h
//  ObjectMapping
//
//  Created by Fabian Canas on 7/14/13.
//  Copyright (c) 2013 Fabian Canas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OMTBasicModel : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *favoriteWord;
@property (nonatomic, assign) NSInteger favoriteNumber;
@property (nonatomic, strong) UIColor *favoriteColor;
@property (nonatomic, strong) OMTBasicModel *favoriteModel;
@end
