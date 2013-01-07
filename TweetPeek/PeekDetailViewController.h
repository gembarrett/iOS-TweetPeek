//
//  PeekDetailViewController.h
//  TweetPeek
//
//  Created by Gem Barrett on 24/02/2012.
//  Copyright (c) 2012 Gem Designs. All rights reserved.
//

#import <UIKit/UIKit.h>

//extends UIViewController
@interface PeekDetailViewController : UIViewController

@property (strong, nonatomic) NSDictionary *tweet;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
