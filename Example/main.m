//
//  main.m
//  Example
//
//  Created by Dave Duprey on 08/03/2019.
//  Copyright © 2019 What3Words. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Sources/W3wGeocoder.h"
#import <CoreLocation/CoreLocation.h>


int main(int argc, const char * argv[]) {
  @autoreleasepool {

  W3wGeocoder *api = [[W3wGeocoder alloc] initWithApiKey:@"<Your Secret Key>"];

  AutoSuggestOption *france = [AutoSuggestOption clipToCountry:@"FR"];
  AutoSuggestOption *place  = [AutoSuggestOption focus:CLLocationCoordinate2DMake(48.856618, 2.3522411)];
  AutoSuggestOption *count  = [AutoSuggestOption numberResults:10];

  [api autosuggest:@"hangry.selfie.x" parameters:@[france, place, count] completion:^(NSArray *suggestions, W3wError *error)
    {
    if (error)
        NSLog(@"There was an %@ error: %@", error.code, error.message);
    else
      {
      NSLog(@"Suggestions Returned:");
      for (W3wSuggestion *suggestion in suggestions)
        {
        NSLog(@"%@ is near %@", suggestion.words, suggestion.nearestPlace);
        }
      }
      
    }];
  }
  
  // Wait to allow the above call to finish
  // The wait is only nessesary because this is a command line app. Command line apps don't wait for asychronous calls to finish
  // A better way to handle this is with semaphore, but as example code, we felt this would neeslessly muddy up the example
  [NSThread sleepForTimeInterval:15.0];
  
  return 0;
}
