//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "UIKit+AFNetworking.h"
#import "ComposeViewController.h"
#import "DetailsViewController.h"


@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>


@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    // Get timeline
    [self fetchTweets];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchTweets) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void) fetchTweets {
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            for (Tweet *tweet in tweets) {
                NSString *text = tweet.text;
                //NSLog(@"%@", text);
            }
            self.arrayOfTweets = [NSMutableArray arrayWithArray:tweets];
            [self.tableView reloadData];
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
    [self.refreshControl endRefreshing];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
 */
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if([segue.identifier isEqual:@"detailSegue"])
    {
        NSIndexPath *myPath = [self.tableView indexPathForCell:sender];
        Tweet *dataToPass = self.arrayOfTweets[myPath.row];
        DetailsViewController *detailVC = [segue destinationViewController];
        detailVC.tweet = dataToPass;
    }
    else if ([segue.identifier isEqual:@"composeSegue"])
    {
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
    }
     /*
      -(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
          NSIndexPath *myPath = [self.tableView indexPathForCell:sender];
          NSDictionary *dataToPass = self.filteredMovies[myPath.row];
          DetailsViewController *detailVC = [segue destinationViewController];
          detailVC.detailDict = dataToPass;
          
          // (NSIndexPath *)indexPathForCell:(UITableViewCell *)cell;
          // Get the new view controller using [segue destinationViewController].
          // Pass the selected object to the new view controller.
      }
      */
}


- (IBAction)didTapLogout:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [[APIManager shared] logout];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfTweets.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
    (NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    Tweet *tweet = self.arrayOfTweets[indexPath.row];
    cell.tweet = tweet;
    NSString *URLString = tweet.user.profilePicture;
    cell.text.text = tweet.text;
    NSLog(@"%@", tweet.text);
    cell.username.text = tweet.user.name;
    NSLog(@"%@", tweet.user.name);
    NSString *at = @"@";
    cell.handle.text = [NSString stringWithFormat:@"%@%@", at, tweet.user.screenName];
    //cell.handle.text = tweet.user.screenName;
    cell.timeLabel.text = tweet.createdAtString;
    [cell refreshData];
    //[cell.favButton setTitle:[NSString stringWithFormat:@"%i",tweet.favoriteCount] forState:UIControlStateNormal];
    //[cell.retweetButton setTitle:[NSString stringWithFormat:@"%i",tweet.retweetCount] forState:UIControlStateNormal];
    
    NSURL *url = [NSURL URLWithString:URLString];
    [cell.profilePhoto setImageWithURL:url];
    
    return cell;
}

- (void)didTweet:(Tweet *)tweet
{
    [self.arrayOfTweets insertObject:tweet atIndex:0];
    [self.tableView reloadData];
    [self.presentedViewController dismissViewControllerAnimated:YES completion:^{}];
}

@end
