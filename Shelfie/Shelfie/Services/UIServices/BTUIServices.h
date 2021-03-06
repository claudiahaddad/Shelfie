//
//  BTUIServices.h
//  Shelfie
//
//  Created by Connor Clancy on 7/31/18.
//  Copyright © 2018 BookTrader. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BTUIServices : NSObject

+ (UISearchBar *)createSearchBarWithDimensions:(CGRect)dimensions;
+ (UILabel *)BTCreateLabel:(NSString *)text withFont:(NSString *)font withSize:(CGFloat)size withColor:(UIColor *)color;

@end
