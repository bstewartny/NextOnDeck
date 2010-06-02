//
//  Note.h
//  NextOnDeck
//
//  Created by Robert Stewart on 4/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Note : NSObject <NSCoding>{
	NSString * text;
}
@property(nonatomic,retain) NSString * text;
@end
