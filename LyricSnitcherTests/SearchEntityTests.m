//
//  SearchEntityTests.m
//  LyricSnitcherTests
//
//  Created by Luis Goyes Garces on 19/03/21.
//

#import <XCTest/XCTest.h>
#import "SearchEntity.h"

@interface SearchEntityTests : XCTestCase
@property SearchEntity * sut;
@end

@implementation SearchEntityTests
- (BOOL)setUpWithError:(NSError *__autoreleasing  _Nullable *)error {
    [super setUpWithError:error];
    _sut = [[SearchEntity alloc] init];
    return true;
}

-(BOOL)tearDownWithError:(NSError *__autoreleasing  _Nullable *)error {
    _sut = nil;
    [super tearDownWithError:error];
    return true;
}
@end
