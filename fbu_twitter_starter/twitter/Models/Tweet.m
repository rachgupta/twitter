//
//  Tweet.m
//  twitter
//
//  Created by Rachna Gupta on 6/20/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "Tweet.h"
#import "User.h"

@implementation Tweet

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];

    if (self) {
        // Is this a re-tweet?
        NSDictionary *originalTweet = dictionary[@"retweeted_status"];
        if (originalTweet != nil) {
            NSDictionary *userDictionary = dictionary[@"user"];
            self.retweetedByUser = [[User alloc] initWithDictionary:userDictionary];

            // Change tweet to original tweet
            dictionary = originalTweet;
        }
        self.idStr = dictionary[@"id_str"];
        if([dictionary valueForKey:@"full_text"] != nil) {
            self.text = dictionary[@"full_text"]; // uses full text if Twitter API provided it
        } else {
            self.text = dictionary[@"text"]; // fallback to regular text that Twitter API provided
        }
        self.favoriteCount = [dictionary[@"favorite_count"] intValue];
        self.favorited = [dictionary[@"favorited"] boolValue];
        self.retweetCount = [dictionary[@"retweet_count"] intValue];
        self.retweeted = [dictionary[@"retweeted"] boolValue];

        // TODO: initialize user
        NSDictionary *user = dictionary[@"user"];
        self.user = [[User alloc] initWithDictionary:user];

        // TODO: Format and set createdAtString
        NSString *createdAtOriginalString = dictionary[@"created_at"];
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
        // Configure the input format to parse the date string
        dateformatter.dateFormat = @"E MMM d HH:mm:ss Z y";
        // Convert String to Date
        NSDate *date = [dateformatter dateFromString:createdAtOriginalString];
        // Configure output format
        dateformatter.dateStyle = NSDateFormatterShortStyle;
        dateformatter.timeStyle = NSDateFormatterNoStyle;
        NSDateFormatter *timeformatter = [[NSDateFormatter alloc]init];
        timeformatter.dateFormat = @"hh:mm";
        // Convert Date to String
        self.createdAtString = [dateformatter stringFromDate:date];
        self.createdAtDate = date;
        self.createdAtTime = [timeformatter stringFromDate: date];
    }
    return self;
}
+ (NSMutableArray *)tweetsWithArray:(NSArray *)dictionaries {
    NSMutableArray *tweets = [NSMutableArray array];
    for (NSDictionary *dictionary in dictionaries) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:dictionary];
        [tweets addObject:tweet];
    }
    return tweets;
}
@end
