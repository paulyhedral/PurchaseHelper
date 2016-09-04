//
//  UIControl+RepresentedObject.m
//  Pilgrimage
//
//  Created by Paul Schifferer on 8/30/12.
//  Copyright (c) 2012 Pilgrimage Software. All rights reserved.
//

#import "UIControl+RepresentedObject.h"

#import <objc/runtime.h>


@implementation UIView (RepresentedObject)

static char kRepresentedObjectKey;

- (void)setRepresentedObject:(id<NSObject>)object {
	id assocObject = [self representedObject];
	if(assocObject != object) {
//		[assocObject release];
		objc_setAssociatedObject(self, &kRepresentedObjectKey, object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
}

- (id<NSObject>)representedObject {
	return objc_getAssociatedObject(self, &kRepresentedObjectKey);
}

@end
