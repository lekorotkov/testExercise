//
//  ProgressTableViewCell.h
//  Korotkov_Test_Project
//
//  Created by Alexey Korotkov on 3.11.15.
//  Copyright © 2015 Alexey Korotkov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgressView.h"
#import "CompletedView.h"

@interface ProgressTableViewCell : UITableViewCell

@property (nonatomic, strong) ProgressView *progressOverlapView;
@property (nonatomic, strong) CompletedView *completedOverlapView;

@property (nonatomic, assign) int downloadIndex;

@property (nonatomic) NSURLSessionTaskState state;

@property (nonatomic) CGFloat fractionCompleted;

@property (nonatomic) NSUInteger index;
@property (weak, atomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@end
