//
//  RESTClient.m
//  LyricSnitcher
//
//  Created by Luis David Goyes on 1/04/22.
//

#import "RESTClient.h"

@implementation RESTClient

- (void)performRequestWithEndpoint:(Endpoint*)endpoint onSuccess:(void (^)(NSDictionary *))onSuccess onError:(void (^)(NSError *))onError {
    
    NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.timeoutIntervalForRequest = 10;
    NSURLSession * session = [NSURLSession sessionWithConfiguration: configuration];
    NSURL * url = [NSURL URLWithString:endpoint.url];
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:endpoint.httpMethod];
    if(endpoint.body != nil && [NSJSONSerialization isValidJSONObject:endpoint.body]) {
        NSData * httpBodyData = [NSJSONSerialization dataWithJSONObject:endpoint.body options:0 error:nil];
        [request setHTTPBody:httpBodyData];
    }
    
    NSURLSessionDataTask * dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
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
            
            if (onSuccess != nil) {
                onSuccess(dataDictionary);
                return;
            }
        });
    }];
    [dataTask resume];
}

@end
