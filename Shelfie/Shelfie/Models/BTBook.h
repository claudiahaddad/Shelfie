//
//  Book.h
//  Shelfie
//
//  Created by Connor Clancy on 7/27/18.
//  Copyright © 2018 BookTrader. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <JSONModel/JSONModel.h>

@interface BTBook : PFObject <PFSubclassing>

@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *messengerId;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *author;
@property (strong, nonatomic) NSString *isbn;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *coverURL;
@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;
@property (nonatomic, assign) BOOL sell;
@property (nonatomic, assign) BOOL trade;
@property (nonatomic, assign) BOOL gift;
@property (nonatomic, assign) BOOL location;
@property (nonatomic, assign) BOOL own;

+ (BTBook *) createBookWithUserId:(NSString *)userId title:(NSString *)title author:(NSString *)author
                         isbn:(NSString *)isbn date:(NSString *)date coverURL:(NSString *)coverURL
                     latitude:(NSNumber *)latitude longitude:(NSNumber *)longitude
                          own:(BOOL)own gift:(BOOL)gift trade:(BOOL)trade sell:(BOOL)sell;

@end
