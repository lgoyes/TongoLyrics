//
//  AppDelegate.h
//  LyricSnitcher
//
//  Created by Luis Goyes Garces on 18/03/21.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

