//
//  PeekMasterViewController.m
//  TweetPeek
//
//  Created by Gem Barrett on 24/02/2012.
//  Copyright (c) 2012 Gem Designs. All rights reserved.
//

#import "PeekMasterViewController.h"

#import "PeekDetailViewController.h"

#import "CJSONDeserializer.h"

#import "GTMHTTPFetcher.h"

@interface PeekMasterViewController ()

@property (nonatomic, strong) NSArray *tweets;

@end

@implementation PeekMasterViewController

@synthesize tweets = _tweets;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    /* code for edit and add new buttons
     self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
     */
    self.title = @"Public Timeline";
    
    //load the Twitter data
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    GTMHTTPFetcher *tweetFetcher = [GTMHTTPFetcher fetcherWithURLString:@"http://api.twitter.com/1/statuses/public_timeline.json"];
    [tweetFetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        self.tweets = [[CJSONDeserializer deserializer] deserializeAsArray:data error:nil];
        [self.tableView reloadData];
    }];
    
    /*JSON file for texting
    NSString *jsonFile = [[NSBundle mainBundle] pathForResource:@"public_timeline" ofType:@"json"];
    
    NSData *tweetData = [NSData dataWithContentsOfFile:jsonFile];
    
    self.tweets = [[CJSONDeserializer deserializer] deserializeAsArray:tweetData error:nil];
    NSLog(@"Tweets = %@", self.tweets);
    
    //NSString *tweetDataAsString = [[NSString alloc]initWithData:tweetData encoding:NSUTF8StringEncoding];
    //NSLog(@"Tweet data as string: %@", tweetDataAsString);
     */
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tweets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    //get the values from the data
    NSDictionary *tweet = [self.tweets objectAtIndex:indexPath.row];
    NSString *tweetText = [tweet valueForKey:@"text"];
    
    NSString *userName = [tweet valueForKeyPath:@"user.name"];
    //NSDictionary *user = [tweet valueForKey:@"user"];
    //NSString *userName = [user valueForKey:@"name"];
    
    //configure the cell
    cell.textLabel.text = tweetText;
    cell.detailTextLabel.text = userName;
    return cell;
}

#pragma mark - UITableViewDelegate methods


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"Segue: %@", segue);
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        NSDictionary *tweet = [self.tweets objectAtIndex:indexPath.row];
        
        [segue.destinationViewController setTweet:tweet];
    }
}

@end
