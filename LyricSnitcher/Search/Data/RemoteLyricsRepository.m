//
//  RemoteLyricsRepository.m
//  LyricSnitcher
//
//  Created by Luis Goyes Garces on 18/03/21.
//

#import "RemoteLyricsRepository.h"
#import "RESTClient.h"

@interface RemoteLyricsRepository()
@property (strong, nonatomic) NSString * apiBaseURL;
@end

@implementation RemoteLyricsRepository
-(instancetype)init {
    self = [super init];
    if (self) {
        _apiBaseURL = @"https://api.lyrics.ovh/v1";
        _webClient = [RESTClient new];
    }
    return self;
}
- (NSString *)formatStringURLForArtist:(NSString *)artist andSong:(NSString *)song {
    NSString * formattedArtist = [artist stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString * formattedSong = [song stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString * fullEndpoint = [NSString stringWithFormat:@"%@/%@/%@", _apiBaseURL, formattedArtist, formattedSong];
    return fullEndpoint;
}

- (void)fetchLyricsForArtist:(NSString *)artist andSong:(NSString *)song onError:(void (^)(NSError *))onError onSuccess:(void (^)(Lyrics *))onSuccess {
    NSString * fullEndpoint = [self formatStringURLForArtist:artist andSong:song];
    Endpoint * endpoint = [Endpoint new];
    endpoint.body = nil;
    endpoint.url = fullEndpoint;
    endpoint.httpMethod = @"GET";
    [_webClient performRequestWithEndpoint:endpoint onSuccess:^(NSDictionary *response) {
        if (response[@"error"]) {
            NSError* error = [NSError errorWithDomain:NSURLErrorDomain code:1 userInfo:@{ NSLocalizedDescriptionKey: @"No lyrics found."}];
            onError(error);
            return;
        }
        
        NSDate * now = [NSDate now];
        NSString * lyrics = response[@"lyrics"];
        APILyrics * apiLyrics = [[APILyrics alloc]initWithLyrics:lyrics];
        Lyrics * mappedResponse = [self mapAPIResponse:apiLyrics withArtist:artist song:song andDate:now];
        onSuccess(mappedResponse);
    } onError:^(NSError *error) {
        onError(error);
    }];
}

- (Lyrics *)mapAPIResponse:(APILyrics *)response withArtist:(NSString *)artist song:(NSString *)song andDate:(NSDate *)date {
    Lyrics * mappedResponse = [[Lyrics alloc] initWithLyrics:response.lyrics artist:artist song:song andDate:date];
    return mappedResponse;
}

@end
