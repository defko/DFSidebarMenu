//
//  GPUImageiOSImageEffect.h
//  HolaTaxi
//
//  Created by Kiss Tamás on 12/03/14.
//  Copyright (c) 2014 defko@me.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPUImageFilterGroup.h"
#import "GPUImagePicture.h"

@class GPUImageSaturationFilter;
@class GPUImageGaussianBlurFilter;
@class GPUImageSolidColorGenerator;
@class GPUImageAlphaBlendFilter;

typedef enum {
    GPUImageIOSImageEffectTypeLight,
    GPUImageIOSImageEffectTypeExtraLight,
    GPUImageIOSImageEffectTypeDark
} GPUImageIOSImageEffectType;

@interface GPUImageiOSImageEffect : GPUImageFilterGroup

/** A radius in pixels to use for the blur, with a default of 12.0. This adjusts the sigma variable in the Gaussian distribution function.
 */
@property (readwrite, nonatomic) CGFloat blurRadiusInPixels;

/** Saturation ranges from 0.0 (fully desaturated) to 2.0 (max saturation), with 0.8 as the normal level
 */
@property (readwrite, nonatomic) CGFloat saturation;

/** The degree to which to downsample, then upsample the incoming image to minimize computations within the Gaussian blur, default of 4.0
 */
@property (readwrite, nonatomic) CGFloat downsampling;

@property (readwrite, nonatomic) GPUImageIOSImageEffectType effectType;

@end

