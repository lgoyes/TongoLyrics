//
//  SimplifiedEntriesManager.m
//  LyricSnitcher
//
//  Created by Luis Goyes Garces on 21/03/21.
//

#import "SimplifiedEntriesManager.h"
#import "Lyrics.h"

@implementation SimplifiedEntriesManager
+ (id)sharedManager {
    static SimplifiedEntriesManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
    
}
- (id)init {
    if (self = [super init]) {
        Lyrics * defaultEntry = [[Lyrics alloc] initWithLyrics:@"dummy-string-for-lyrics" artist:@"dummy-string-for-artist" song:@"dummy-string-for-song" andDate:[NSDate now]];
        _entries = [@[defaultEntry] mutableCopy];
    }
    return self;
}
@end
