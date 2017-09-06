//
//  UIImage+Blur.h
//  ASDepthModal
//
//  Created by Shady A. Elyaski on 3/20/13.
//  Copyright (c) 2013 Mash ltd. All rights reserved.
//  Code used from https://github.com/rnystrom/RNBlurModalView
//

#import <UIKit/UIKit.h>

@interface UIImage (Blur)

-(UIImage *)boxblurImageWithBlur:(CGFloat)blur;

/* blur the current image with a box blur algoritm and tint with a color */
- (UIImage*)drn_boxblurImageWithBlur:(CGFloat)blur withTintColor:(UIColor*)tintColor;

- (UIImage *)blurredImageWithRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor *)tintColor;
@end
