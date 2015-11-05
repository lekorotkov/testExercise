//
//  NumberOfActiveDownloadsView.m
//  Korotkov_Test_Project
//
//  Created by Alexey Korotkov on 4.11.15.
//  Copyright © 2015 Alexey Korotkov. All rights reserved.
//

#import "NumberOfActiveDownloadsView.h"

static const CGFloat kArcWidth = 15.f;
static const CGFloat kOutlineWidth = 1.f;
static const CGFloat kMarkerWidth = 2.f;
static const CGFloat kMarkerSize = 3.f;
static const int kMaxSimultaneousDownloads = 8;

@implementation NumberOfActiveDownloadsView

- (void)drawRect:(CGRect)rect {
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    
    CGFloat radius = MAX(self.bounds.size.width, self.bounds.size.height);
    
    CGFloat arcWidth = kArcWidth;
    CGFloat startAngle = 3 * M_PI / 4;
    CGFloat endAngle = M_PI / 4;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                        radius:radius/2 - arcWidth/2
                                                    startAngle:startAngle
                                                      endAngle:endAngle
                                                     clockwise:YES];
    
    
    path.lineWidth = arcWidth;
    [_counterColor setStroke];
    [path stroke];
    
    CGFloat angleDifference = 2 * M_PI - startAngle + endAngle;
    
    CGFloat arcLengthPerDownload = angleDifference / kMaxSimultaneousDownloads;
    
    CGFloat outlineEndAngle = arcLengthPerDownload * self.counter + startAngle;
    
    UIBezierPath *outlinePath = [UIBezierPath bezierPathWithArcCenter:center
                                                               radius:self.bounds.size.width / 2 - kOutlineWidth / 2
                                                           startAngle:startAngle
                                                             endAngle:outlineEndAngle
                                                            clockwise:YES];
    [outlinePath addArcWithCenter:center
                           radius:self.bounds.size.width / 2 - arcWidth + kOutlineWidth / 2
                       startAngle:outlineEndAngle
                         endAngle:startAngle
                        clockwise:false];
    
    [outlinePath closePath];
    
    [self.outlineColor setStroke];
    outlinePath.lineWidth = kOutlineWidth;
    [outlinePath stroke];
    
    struct CGContext *context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    [self.outlineColor setFill];
    
    CGFloat markerWidth = kMarkerWidth;
    CGFloat markerSize = kMarkerSize;
    
    UIBezierPath *markerPath = [UIBezierPath bezierPathWithRect:CGRectMake(-markerWidth/2, 0, markerWidth, markerSize)];
    
    CGContextTranslateCTM(context, rect.size.width / 2, rect.size.height / 2);
    
    for (int i = 0; i < _counter + 1; i++) {
        CGContextSaveGState(context);
        
        CGFloat angle = arcLengthPerDownload * i + startAngle - M_PI/2;
        CGContextRotateCTM(context, angle);
        CGContextTranslateCTM(context,
                              0,
                              rect.size.height/2 - markerSize);
        [_outlineColor setFill];
        [markerPath fill];
        
        CGContextRestoreGState(context);
    }
    
    CGContextRestoreGState(context);
}

@end
