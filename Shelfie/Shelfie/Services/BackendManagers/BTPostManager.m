//
//  BTPostManager.m
//  Shelfie
//
//  Created by Connor Clancy on 7/27/18.
//  Copyright © 2018 BookTrader. All rights reserved.
//

#import "BTPostManager.h"

@implementation BTPostManager

+ (id) shared {
    static BTPostManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

+ (void) addBookToDatabaseWithUserId:(NSString *)userId title:(NSString *)title author:(NSString *)author
                                isbn:(NSString *)isbn date:(NSString *)date coverURL:(NSString *)coverURL
                            latitude:(NSNumber *)latitude longitude:(NSNumber *)longitude
                                 own:(BOOL)own gift:(BOOL)gift trade:(BOOL)trade sell:(BOOL)sell
                          completion:(PFBooleanResultBlock)completion {
    BTBook *book = [BTBook new];
    book.userId = userId;
    book.title = title;
    book.author = author;
    book.isbn = isbn;
    book.date = date;
    book.coverURL = coverURL;
    book.latitude = latitude;
    book.longitude = longitude;
    book.own = own;
    book.gift = gift;
    book.trade = trade;
    book.sell = sell;
    [book saveInBackgroundWithBlock:completion];
};

+ (void)addUserToDatabase:(NSString *) userId withName:(NSString *) name withProfilePicture:(NSString *) profilePicture withBooks:(NSMutableArray *) booksHave withWantBooks:(NSMutableArray *) booksWant withSellBooks:(NSMutableArray *) booksSell withTradeBooks:(NSMutableArray *) booksTrade withCompletion:(PFBooleanResultBlock)completion {
    BTUser *newUser = [BTUser new];
    newUser.userId = userId;
    newUser.name = name;
    newUser.picture = profilePicture;
    newUser.booksWant = booksWant;
    newUser.booksHave = booksHave;
    newUser.booksSell = booksSell;
    newUser.booksTrade = booksTrade;
    [newUser saveInBackgroundWithBlock:completion];
};

- (void)removeBookFromDatabase:(BTBook *)book {
    [book deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"deleted");
        } else {
            NSLog(@"%@", error);
        }
    }];
}

@end
