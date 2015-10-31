//
//  UIControl+RepresentedObject.h
//  Pilgrimage
//
//  Created by Paul Schifferer on 8/30/12.
//  Copyright (c) 2012 Pilgrimage Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIView (RepresentedObject)

@property (nonatomic, retain) id<NSObject> representedObject;

@end
