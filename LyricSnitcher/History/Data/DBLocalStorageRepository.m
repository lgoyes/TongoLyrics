//
//  DBLocalStorageRepository.m
//  LyricSnitcher
//
//  Created by Luis Goyes Garces on 19/03/21.
//

#import <UIKit/UIKit.h>
#import "DBLocalStorageRepository.h"
#import "AppDelegate.h"
#import "DBLyrics+CoreDataClass.h"

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
    DBLyrics * dbLyrics = (DBLyrics *)[NSEntityDescription insertNewObjectForEntityForName:@"DBLyrics" inManagedObjectContext:_context];
    dbLyrics.artist = item.artist;
    dbLyrics.song = item.song;
    dbLyrics.lyrics = item.lyrics;
    dbLyrics.date = item.date;
    NSError * error;
    if (![_context save:&error]) {
        NSLog(@"Failed to save - error: %@", [error localizedDescription]);
    }
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
