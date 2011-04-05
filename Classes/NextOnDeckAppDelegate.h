#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#define kDropBoxKey @"dvnxhtylkttdjyn"
#define kDropBoxSecret @"xvfh5xajiatsxw1"
#define kInboxUID @"ndhjgyehfkdirjghdufh"

@class Project;
@class DBRestClient;
@interface NextOnDeckAppDelegate : NSObject <UIApplicationDelegate> 
{    
    UIWindow *window;
	NSManagedObjectModel *managedObjectModel;
	NSManagedObjectContext *managedObjectContext;	    
	NSPersistentStoreCoordinator *persistentStoreCoordinator;
	
	DBRestClient* restClient;
	NSString * metadataHash;
	NSDate * lastSyncDate;
	NSDateFormatter * formatter;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic,retain) DBRestClient * restClient;

- (BOOL) isPhone;

- (void) loadArchivedData;

- (void) saveData;

- (void) showInbox;

- (void) showNextOnDeck;

- (void) showProject:(Project*)project;

- (BOOL) isDate:(NSDate*)a laterThan:(NSDate*)b;

@end
