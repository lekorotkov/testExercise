//
//  NumberOfActiveDownloadsView.h
//  Korotkov_Test_Project
//
//  Created by Alexey Korotkov on 4.11.15.
//  Copyright © 2015 Alexey Korotkov. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface NumberOfActiveDownloadsView : UIView

@property (nonatomic, strong) IBInspectable UIColor *outlineColor;

@property (nonatomic, strong) IBInspectable UIColor *counterColor;
@property (nonatomic) IBInspectable NSInteger counter;

@end
