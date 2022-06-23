//
//  DetailsViewController.m
//  twitter
//
//  Created by Rachna Gupta on 6/23/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "DetailsViewController.h"
#import "Tweet.h"
#import "UIImageView+AFNetworking.h"
#import "UIKit+AFNetworking.h"
#import "APIManager.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController
- (IBAction)didTapFavorite:(id)sender {
    if(self.tweet.favorited==NO)
    {
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
            }
        }];
    }
    else if(self.tweet.favorited==YES)
    {
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
            }
        }];
    }
    [self refreshData];
}
- (IBAction)didTapRetweet:(id)sender {
    if(self.tweet.retweeted==NO)
    {
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
            }
        }];
    }
    else if(self.tweet.retweeted==YES)
    {
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
            }
        }];
    }
    [self refreshData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *URLString = self.tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    [self.profPhoto setImageWithURL:url];
    self.text.text = self.tweet.text;
    NSLog(@"%@", self.tweet.text);
    self.username.text = self.tweet.user.name;
    NSString *at = @"@";
    self.handle.text = [NSString stringWithFormat:@"%@%@", at, self.tweet.user.screenName];
    //cell.handle.text = tweet.user.screenName;
    self.date.text = self.tweet.createdAtString;
    // Do any additional setup after loading the view.
    [self refreshData];
}
-(void)refreshData {
    if(self.tweet.favorited==YES)
    {
        [self.favButton setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
    }
    else if(self.tweet.favorited==NO)
    {
        [self.favButton setImage:[UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
    }
    if(self.tweet.retweeted==YES)
    {
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateNormal];
    }
    else if(self.tweet.retweeted==NO)
    {
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
    }
    self.favCount.text = @(self.tweet.favoriteCount).stringValue;
    self.retweetCount.text = @(self.tweet.retweetCount).stringValue;
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
