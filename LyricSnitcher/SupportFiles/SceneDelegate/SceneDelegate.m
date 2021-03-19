//
//  SceneDelegate.m
//  LyricSnitcher
//
//  Created by Luis Goyes Garces on 18/03/21.
//

#import "SceneDelegate.h"
#import "AppDelegate.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    [(AppDelegate *)UIApplication.sharedApplication.delegate saveContext];
}


@end
