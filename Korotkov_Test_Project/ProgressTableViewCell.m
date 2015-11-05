//
//  ProgressTableViewCell.m
//  Korotkov_Test_Project
//
//  Created by Alexey Korotkov on 3.11.15.
//  Copyright © 2015 Alexey Korotkov. All rights reserved.
//

#import "ProgressTableViewCell.h"

@interface ProgressTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *stateInfoLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation ProgressTableViewCell

- (void)setState:(NSURLSessionTaskState)state {
    if (state == _state && state == NSURLSessionTaskStateCompleted) {
        return;
    }
    
    _state = state;
    
    [self.progressOverlapView removeFromSuperview];
    [self.completedOverlapView removeFromSuperview];
    
    switch (state) {
        case NSURLSessionTaskStateRunning: {
            self.progressLabel.hidden = NO;
            self.progressView.hidden = NO;
            self.stateInfoLabel.hidden = YES;
            self.activityIndicator.hidden = YES;
        }
        break;
        case NSURLSessionTaskStateSuspended: {
            self.stateInfoLabel.text = @"Waiting";
            self.stateInfoLabel.hidden = NO;
            self.activityIndicator.hidden = NO;
            [self.activityIndicator startAnimating];
            self.progressLabel.hidden = YES;
            self.progressView.hidden = YES;
        }
        break;
        case NSURLSessionTaskStateCanceling: {
            self.progressLabel.hidden = YES;
            self.progressView.hidden = YES;
        }
        break;
        case NSURLSessionTaskStateCompleted: {
            self.stateInfoLabel.text = @"Completed!!!";
            self.stateInfoLabel.hidden = NO;
            self.activityIndicator.hidden = YES;
            self.progressLabel.hidden = YES;
            self.progressView.hidden = YES;

            self.completedOverlapView = [[CompletedView alloc] initWithFrame:self.contentView.frame];
            [self addSubview:self.completedOverlapView];
        }
        break;
    }
}

- (void)setFractionCompleted:(CGFloat)fractionCompleted {
    [self.progressOverlapView removeFromSuperview];
    self.progressOverlapView = [[ProgressView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width * fractionCompleted + 20.f, self.contentView.frame.size.height)];
    self.progressOverlapView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.progressOverlapView];
}

@end
