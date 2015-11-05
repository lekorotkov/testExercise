//
//  ProgressView.m
//  Korotkov_Test_Project
//
//  Created by Alexey Korotkov on 4.11.15.
//  Copyright © 2015 Alexey Korotkov. All rights reserved.
//

#import "ProgressView.h"

static const CGFloat kArrowLength = 20.f;
static const CGFloat kAlphaComponent = 0.3f;

@implementation ProgressView

- (void)drawRect:(CGRect)rect {
    CGPoint firstPoint = CGPointMake(self.bounds.size.width - kArrowLength, 0);
    CGPoint secondPoint = CGPointMake(self.bounds.size.width, self.bounds.size.height / 2);
    CGPoint thirdPoint = CGPointMake(self.bounds.size.width - kArrowLength, self.bounds.size.height);
    
    UIBezierPath *triangle = [UIBezierPath bezierPath];
    [triangle moveToPoint:firstPoint];
    [triangle addLineToPoint:secondPoint];
    [triangle addLineToPoint:thirdPoint];
    [[[UIColor blueColor] colorWithAlphaComponent:kAlphaComponent] setFill];
    [triangle closePath];
    [triangle fill];
    
    UIBezierPath *rectangle = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, self.bounds.size.width - kArrowLength, self.bounds.size.height)];
    [[[UIColor blueColor] colorWithAlphaComponent:kAlphaComponent] setFill];
    [rectangle fill];
}

@end
