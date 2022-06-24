//
//  ComposeViewController.m
//  twitter
//
//  Created by Rachna Gupta on 6/23/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "Tweet.h"
#import "APIManager.h"

@interface ComposeViewController ()

@end

@implementation ComposeViewController
- (IBAction)closeCompose:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
- (IBAction)tweetPost:(id)sender {
    [[APIManager shared]postStatusWithText:self.textToPost.text completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error composing Tweet: %@", error.localizedDescription);
        }
        else{
            [self.delegate didTweet:tweet];
            NSLog(@"Compose Tweet Success!");
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textToPost.delegate = self;
    self.textToPost.layer.borderWidth = 2.0f;
    self.textToPost.layer.borderColor = [[UIColor grayColor] CGColor];
    self.textToPost.layer.cornerRadius = 5;
    // Do any additional setup after loading the view.
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    int characterLimit = 140;

    // Construct what the new text would be if we allowed the user's latest edit
    NSString *newText = [self.textToPost.text stringByReplacingCharactersInRange:range withString:text];
    // TODO: Update character count label
    NSInteger *numLeft =(140-newText.length);
    self.charCount.text = [NSString stringWithFormat:@"%d chars left", numLeft];;
    // Should the new text should be allowed? True/False
    return newText.length < characterLimit;
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
