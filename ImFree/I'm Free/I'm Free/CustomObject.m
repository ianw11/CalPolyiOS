//
//  CustomObject.m
//  I'm Free
//
//  Created by Ian Washburne on 2/19/15.
//  Copyright (c) 2015 Ian Washburne. All rights reserved.
//

#import "CustomObject.h"
#import <Parse/Parse.h>

@implementation CustomObject

- (void) someMethod {
   //NSLog(@"SomeMethod Ran");
   
   // [Optional] Power your app with Local Datastore. For more info, go to
   // https://parse.com/docs/ios_guide#localdatastore/iOS
   [Parse enableLocalDatastore];
   
   // Initialize Parse.
   [Parse setApplicationId:@"IRL0T2KM6IP9GjaXU4ai7NAHLNnqli1iVVaPfV1U"
                 clientKey:@"ADfT5SkIThn2a4uEAg1Vf5ZjiIAEx6S863jgguQn"];
   
   // [Optional] Track statistics around application opens.
   //[PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
}

@end