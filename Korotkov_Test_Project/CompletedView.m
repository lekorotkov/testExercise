//
//  CompletedView.m
//  Korotkov_Test_Project
//
//  Created by Alexey Korotkov on 4.11.15.
//  Copyright © 2015 Alexey Korotkov. All rights reserved.
//

#import "CompletedView.h"

@interface CompletedView ()

@property (nonatomic, strong) UIImageView *firstStarImageView;
@property (nonatomic, strong) UIImageView *secondStarImageView;

@end

@implementation CompletedView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor greenColor]colorWithAlphaComponent:0.3f];
        
        _firstStarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star"]];
        _secondStarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star"]];
        
        _firstStarImageView.frame = CGRectMake(self.bounds.size.width/4 - _firstStarImageView.bounds.size.width/2, self.bounds.size.height / 6,25.f, 25.f);
        _secondStarImageView.frame = CGRectMake(self.bounds.size.width * 3 / 4 - _secondStarImageView.bounds.size.width/2, self.bounds.size.height / 6, 25.f, 25.f);
        
        [self addSubview:_firstStarImageView];
        [self addSubview:_secondStarImageView];
    }
    return self;
}

@end
