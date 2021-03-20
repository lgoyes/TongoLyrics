//
//  DBLocalStorageRepository.m
//  LyricSnitcher
//
//  Created by Luis Goyes Garces on 19/03/21.
//

#import <UIKit/UIKit.h>
#import "DBLocalStorageRepository.h"
#import "AppDelegate.h"

@implementation DBLocalStorageRepository
- (instancetype)init
{
    self = [super init];
    if (self) {
        AppDelegate * delegate = (AppDelegate*) UIApplication.sharedApplication.delegate;
        _context = delegate.persistentContainer.viewContext;
    }
    return self;
}
- (void)create:(Lyrics *)item {
    NSManagedObject * object = [NSEntityDescription insertNewObjectForEntityForName:@"DBLyrics" inManagedObjectContext:_context];
    
}

- (void)deleteBySong:(NSString *)song andArtist:(NSString *)artist {
    
}

- (NSArray *)list {
    return @[];
//    NSFetchRequest * request = NSFetchRequest
}

- (void)readBySong:(NSString *)song andArtist:(NSString *)artist {
    
}

- (void)updateBySong:(NSString *)song andArtist:(NSString *)artist item:(Lyrics *)item {
    
}

@end
