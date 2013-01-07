//
//  UILabel+VAlign.m
//  TweetPeek
//
//  Created by Gem Barrett on 24/02/2012.
//  Copyright (c) 2012 Gem Designs. All rights reserved.
//

// UILabel(VAlign).m
#import "UILabel+VAlign.h"
@implementation UILabel (VAlign)
- (void) setVerticalAlignmentTop
{
    CGSize textSize = [self.text sizeWithFont:self.font
                            constrainedToSize:self.frame.size
                                lineBreakMode:self.lineBreakMode];
    
    CGRect textRect = CGRectMake(self.frame.origin.x,
                                 self.frame.origin.y,
                                 self.frame.size.width,
                                 textSize.height);
    [self setFrame:textRect];
    [self setNeedsDisplay];
}

@end