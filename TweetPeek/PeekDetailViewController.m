//
//  PeekDetailViewController.m
//  TweetPeek
//
//  Created by Gem Barrett on 24/02/2012.
//  Copyright (c) 2012 Gem Designs. All rights reserved.
//

#import "PeekDetailViewController.h"
#import "UILabel+VAlign.h"
#import "GTMHTTPFetcher.h"
#import "UIApplication+NetworkActivityIndicatorManager.h"

@interface PeekDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileBackgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *userFollowersCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *userFollowingCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;


- (void)configureView;
@end

@implementation PeekDetailViewController
@synthesize profileBackgroundImageView = _profileBackgroundImageView;
@synthesize profileImageView = _profileImageView;
@synthesize userNameLabel = _userNameLabel;
@synthesize userDescriptionLabel = _userDescriptionLabel;
@synthesize userFollowersCountLabel = _userFollowersCountLabel;
@synthesize userFollowingCountLabel = _userFollowingCountLabel;
@synthesize textLabel = _textLabel;

@synthesize tweet = _tweet;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;

#pragma mark - Managing the detail item

- (void)setTweet:(NSDictionary *)tweet
{
    if (_tweet != tweet) {
        _tweet = tweet;
        
        // Update the view.
        [self configureView];
        
    }
}

- (void)configureView
{
    // Update the user interface for the tweet.

    if (self.tweet) {
        
        NSString *userProfileBackgroundImageURLString = [self.tweet valueForKeyPath:@"user.profile_background_image_url"];
        NSString *userProfileImageURLString = [self.tweet valueForKeyPath:@"user.profile_image_url"];
        NSString *userName = [self.tweet valueForKeyPath:@"user.name"];
        NSString *userDescription = [self.tweet valueForKeyPath:@"user.description"];
        
        if ((NSNull *)userDescription == [NSNull null]) {
            userDescription = @"No description.";
        }
        
        NSNumber *userFollowersCount = [self.tweet valueForKeyPath:@"user.followers_count"];
        NSNumber *userFollowingCount = [self.tweet valueForKeyPath:@"user.friends_count"];
        NSString *text = [self.tweet valueForKeyPath:@"text"];
        
        //configure the components
        self.userNameLabel.text = userName;
        self.userDescriptionLabel.text = userDescription;
        self.userFollowersCountLabel.text = [userFollowersCount stringValue];
        self.userFollowingCountLabel.text = [userFollowingCount stringValue];
        self.textLabel.text = text;
        
        //fix for lack of vertical alignment in UILabels
        [self.userDescriptionLabel setVerticalAlignmentTop];
        [self.textLabel setVerticalAlignmentTop];
        
        //until new images load, show nothing
        self.profileImageView.image = nil;
        self.profileBackgroundImageView.image = nil;
        
        //load profile and background images and display them
        //create http fetcher
        GTMHTTPFetcher *userProfileImageFetcher = [GTMHTTPFetcher fetcherWithURLString:userProfileImageURLString];
        [UIApplication dataOperationStarted];
        //grab user profile image and display
        [userProfileImageFetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
            [UIApplication dataOperationEnded];
            UIImage *userProfileImage = [UIImage imageWithData:data];
            self.profileImageView.image = userProfileImage;
        }];
        //create http fetcher

        GTMHTTPFetcher *userProfileBackgroundImageFetcher = [GTMHTTPFetcher fetcherWithURLString:userProfileBackgroundImageURLString];
        [UIApplication dataOperationStarted];
        //grab user background image and display
        [userProfileBackgroundImageFetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
            [UIApplication dataOperationEnded];
            UIImage *userProfileBackgroundImage = [UIImage imageWithData:data];
            self.profileBackgroundImageView.image = userProfileBackgroundImage;
        }]; 
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)viewDidUnload
{
    [self setProfileBackgroundImageView:nil];
    [self setProfileImageView:nil];
    [self setUserNameLabel:nil];
    [self setUserDescriptionLabel:nil];
    [self setUserFollowersCountLabel:nil];
    [self setUserFollowingCountLabel:nil];
    [self setTextLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.detailDescriptionLabel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
