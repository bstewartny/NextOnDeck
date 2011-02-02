#import <Foundation/Foundation.h>

@interface ProjectCollection : NSObject {
	NSMutableArray * projectArrays;
}
@property(nonatomic,retain) NSMutableArray * projectArrays;

- (NSArray*) projects;

@end
