//
//  WebClient.h
//  LyricSnitcher
//
//  Created by Luis David Goyes on 1/04/22.
//

#ifndef WebClient_h
#define WebClient_h

#import <Foundation/Foundation.h>
#import "Endpoint.h"

@protocol WebClient <NSObject>
- (void) performRequestWithEndpoint:(Endpoint*)endpoint onSuccess:(void (^) (NSDictionary* response))onSuccess onError:(void (^) (NSError* error))onError;
@end

#endif /* WebClient_h */
