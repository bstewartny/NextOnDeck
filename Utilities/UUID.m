//
//  UUID.m
//  NextOnDeck
//
//  Created by Robert Stewart on 3/31/11.
//  Copyright 2011 OmegaMuse, LLC. All rights reserved.
//

#import "UUID.h"


@implementation UUID

+ (NSString *)GetUUID
{
	CFUUIDRef theUUID = CFUUIDCreate(NULL);
	CFStringRef string = CFUUIDCreateString(NULL, theUUID);
	CFRelease(theUUID);
	return [(NSString *)string autorelease];
}

@end
