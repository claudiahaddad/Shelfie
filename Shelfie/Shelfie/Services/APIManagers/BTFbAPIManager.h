//
//  BTFbAPIManager.h
//  Shelfie
//
//  Created by Chaliana Rolon on 7/30/18.
//  Copyright © 2018 BookTrader. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTUserManager.h"

@interface BTFbAPIManager : NSObject

+ (instancetype) shared;

- (void) login: (BTLoginViewController *) loginController;

+ (void) logout;

@end
