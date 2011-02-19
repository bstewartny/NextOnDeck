#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class Project;
@interface NextOnDeckAppDelegate : NSObject <UIApplicationDelegate> 
{    
    UIWindow *window;
	NSManagedObjectModel *managedObjectModel;
	NSManagedObjectContext *managedObjectContext;	    
	NSPersistentStoreCoordinator *persistentStoreCoordinator;
}
@property (nonatomic, retain) IBOutlet UIWindow *window;

- (void) loadArchivedData;

- (void) saveData;

- (void) showInbox;

- (void) showNextOnDeck;

- (void) showProject:(Project*)project;

@end
