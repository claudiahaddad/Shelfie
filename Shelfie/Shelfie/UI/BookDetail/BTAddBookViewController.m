//
//  BTAddBookViewController.m
//  Shelfie
//
//  Created by Claudia Haddad on 7/26/18.
//  Copyright © 2018 BookTrader. All rights reserved.
//

#import "BTAddBookViewController.h"
#import "BTBarcodeViewController.h"
#import "SWRevealViewController.h"
#import "GOBook.h"
#import "UIImageView+AFNetworking.h"
#import "BTPostManager.h"
#import "BTUserDefaults.h"
#import "BTUserManager.h"
#import "BTBookAPIManager.h"
#import "BTCompletedRequestViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <JSONModel/JSONModel.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface BTAddBookViewController () <BarcodeViewControllerDelegate>

@property (strong, nonatomic) GOBook *book;
@property (strong, nonatomic) NSString *coverURL;

@property (strong, nonatomic) IBOutlet UIButton *buySellButton;
@property (strong, nonatomic) IBOutlet UIButton *tradeButton;
@property (strong, nonatomic) IBOutlet UIButton *giftButton;
@property (strong, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) IBOutlet UILabel *sliderLabel;
@property (strong, nonatomic) IBOutlet UILabel *authorLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UIImageView *bookCover;
@property (strong, nonatomic) IBOutlet UILabel *buySellLabel;
@property (strong, nonatomic) IBOutlet UILabel *giftLabel;
@property (strong, nonatomic) IBOutlet UIView *distanceView;
@property (strong, nonatomic) IBOutlet UIButton *submitButton;

@property (nonatomic, assign) BOOL buySell;
@property (nonatomic, assign) BOOL trade;
@property (nonatomic, assign) BOOL gift;
@property (nonatomic, assign) BOOL own;
@property (nonatomic, assign) BOOL sell;
@end

@implementation BTAddBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [super setDelegate:self];
   
    if (self.have) {
        self.own = true;
        self.distanceView.hidden = YES;
        self.submitButton.frame = CGRectMake(127,540,120,47);

    } else {
        self.buySellLabel.text = @"buy?";
        self.giftLabel.text = @"be gifted?";
        self.submitButton.frame = CGRectMake(127,600,120,47);
    }
}

- (void)makeBook:(NSDictionary *)book {
    NSDictionary *bookDictionary = book[@"items"][0][@"volumeInfo"];
    self.book = [GOBook new];
    self.book.title = bookDictionary[@"title"];
    self.book.imageLinks = bookDictionary[@"imageLinks"];
    self.book.authors = bookDictionary[@"authors"];
    self.book.date = bookDictionary[@"publishedDate"];
    NSString *formattedDate = [self.book.date substringToIndex:4];
    self.coverURL = self.book.imageLinks[@"thumbnail"];
    self.titleLabel.text = self.book.title;
    self.authorLabel.text = self.book.authors[0];
    self.dateLabel.text = formattedDate;
    [self.bookCover setImageWithURL:[NSURL URLWithString:self.coverURL]];
    self.bookCover.layer.shadowRadius = 2;
    self.bookCover.layer.shadowOpacity = 0.8;
}

- (IBAction)sellClicked:(id)sender {
    if (!self.buySell) {
        self.buySell = true;
        self.trade = false;
        self.gift = false;
        [self.buySellButton setImage:[UIImage imageNamed:@"iconmonstr-circle-1-240.png"] forState:UIControlStateNormal];
        [self.giftButton setImage:[UIImage imageNamed:@"iconmonstr-circle-thin-32.png"] forState:UIControlStateNormal];
        [self.tradeButton setImage:[UIImage imageNamed:@"iconmonstr-circle-thin-32.png"] forState:UIControlStateNormal];
    } else if (self.buySell) {
        self.buySell = false;
        self.trade = true;
        self.gift = true;
        [self.buySellButton setImage:[UIImage imageNamed:@"iconmonstr-circle-thin-32.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)tradeClicked:(id)sender {
    if (!self.trade) {
        self.trade = true;
        self.buySell= false;
        self.gift = false;
        [self.tradeButton setImage:[UIImage imageNamed:@"iconmonstr-circle-1-240.png"] forState:UIControlStateNormal];
         [self.giftButton setImage:[UIImage imageNamed:@"iconmonstr-circle-thin-32.png"] forState:UIControlStateNormal];
         [self.buySellButton setImage:[UIImage imageNamed:@"iconmonstr-circle-thin-32.png"] forState:UIControlStateNormal];
    } else if (self.trade) {
        self.trade = false;
        self.gift = true;
        self.buySell = true;
        [self.tradeButton setImage:[UIImage imageNamed:@"iconmonstr-circle-thin-32.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)giftClicked:(id)sender {
    if (!self.gift) {
        self.gift = true;
        self.trade = false;
        self.buySell = false;
        [self.giftButton setImage:[UIImage imageNamed:@"iconmonstr-circle-1-240.png"] forState:UIControlStateNormal];
        [self.tradeButton setImage:[UIImage imageNamed:@"iconmonstr-circle-thin-32.png"] forState:UIControlStateNormal];
        [self.buySellButton setImage:[UIImage imageNamed:@"iconmonstr-circle-thin-32.png"] forState:UIControlStateNormal];
    } else if (self.gift) {
        self.gift = false;
        self.trade = true;
        self.buySell = true;
        [self.giftButton setImage:[UIImage imageNamed:@"iconmonstr-circle-thin-32.png"] forState:UIControlStateNormal];
    }
}
- (IBAction)sliderValueChanged:(id)sender {
    self.sliderLabel.text = [NSString stringWithFormat:@"%.0f miles", self.slider.value];
}


- (IBAction)submitClicked:(id)sender {
    CLLocationCoordinate2D currentLocation = [BTUserDefaults getCurrentLocation];
    BTBook *submittedBook = [BTBook createBookWithUserId:[FBSDKAccessToken currentAccessToken].userID title:self.book.title author:self.book.authors[0] isbn:self.isbn date:self.book.date coverURL:self.coverURL latitude:@(currentLocation.latitude) longitude:@(currentLocation.longitude) own:self.own gift:self.gift trade:self.trade sell:self.sell];

    if (self.own) {
        [[BTUserManager shared] addToBooksHave:submittedBook];
    } else {
        [[BTUserManager shared] addToBooksWant:submittedBook];
    }
    [BTUserManager getUserWithID:[FBSDKAccessToken currentAccessToken].userID completion:^(BTUser *owner) {
        [[BTUserManager shared] setUser:owner];
    }];
    [self performSegueWithIdentifier:@"publishSegue" sender:nil];
    
}

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([[segue identifier] isEqualToString:@"publishSegue"]) {
         BTCompletedRequestViewController *publishViewController = [segue destinationViewController];
         publishViewController.bookTitle = self.titleLabel.text;
         publishViewController.coverURL = self.coverURL;
         publishViewController.date = self.dateLabel.text;
         publishViewController.author = self.authorLabel.text;
     }
 }
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
*/


@end
