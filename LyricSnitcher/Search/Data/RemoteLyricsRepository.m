//
//  RemoteLyricsRepository.m
//  LyricSnitcher
//
//  Created by Luis Goyes Garces on 18/03/21.
//

#import "RemoteLyricsRepository.h"

@interface RemoteLyricsRepository()
@property (nonatomic) NSString * apiBaseURL;
@end

@implementation RemoteLyricsRepository
-(instancetype)init {
    self = [super init];
    if (self) {
        _apiBaseURL = @"https://api.lyrics.ovh/v1";
    }
    return self;
}
- (NSString *)formatStringURLForArtist:(NSString *)artist andSong:(NSString *)song {
    NSString * formattedArtist = [artist stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString * formattedSong = [song stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString * fullEndpoint = [NSString stringWithFormat:@"%@/%@/%@", _apiBaseURL, formattedArtist, formattedSong];
    return fullEndpoint;
}
- (NSURL *)getURLForArtist:(NSString *)artist andSong:(NSString *)song {
    NSString * fullEndpoint = [self formatStringURLForArtist:artist andSong:song];
    NSURL * url = [NSURL URLWithString:fullEndpoint];
    return url;
}
- (void)fetchLyricsForArtist:(NSString *)artist andSong:(NSString *)song onError:(void (^)(NSError * _Nonnull))onError onSuccess:(void (^)(APILyrics * _Nonnull))onSuccess {
    NSURL * url = [self getURLForArtist:artist andSong:song];
    NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.timeoutIntervalForRequest = 10;
    NSURLSession * session = [NSURLSession sessionWithConfiguration: configuration];
    NSURLSessionDataTask * dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error != nil && onError != nil) {
                onError(error);
                return;
            }
            
            NSError * conversionError = nil;
            NSDictionary * dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&conversionError];
            if (conversionError != nil && onError != nil) {
                onError(error);
                return;
            }
            
            NSString * lyrics = dataDictionary[@"lyrics"];
            
            APILyrics * parsedResponse = [[APILyrics alloc]initWithLyrics:lyrics];
            if (onSuccess!= nil) {
                onSuccess(parsedResponse);
                return;
            }
        });
    }];
    [dataTask resume];
}
@end
