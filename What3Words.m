//
//  What3Words.m
//  W3wWrapper
//
//  Created by What3Words on 08/01/15.
//  Copyright (c) 2015 What3Words. All rights reserved.
//

#import "What3Words.h"
#import <AFNetworking/AFNetworking.h>

NSString *const kWhat3WordsApiUrl = @"http://api.what3words.com/";

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@interface What3Words()

@property (nonatomic, strong) NSString *apiKey;

@end


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation What3Words


////////////////////////////////////////////////////////////////////////////////////////////////////
- (instancetype)initWithWithApiKey:(NSString *)apiKey
{
  self = [super init];
  if (self) {
    self.language = @"en";
    self.apiKey = apiKey;
  }
  return self;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)getLanguagesWithCompletion:(What3WordsCompletion)completion
{
  NSString *url = [kWhat3WordsApiUrl stringByAppendingString:@"get-languages"];
  [self postRequestToUrl:url params:nil completion:completion];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)wordsToPosition:(id)words withCompletion:(What3WordsCompletion)completion
{
  if (!([words isKindOfClass:[NSArray class]] || [words isKindOfClass:[NSString class]])) {
    NSLog(@"You need to provide either an NSArray or NSString");
    if (completion) {
      completion(nil, nil);
    }
    return;
  }
  
  NSString *wordsString = (NSString *)words;
  if ([words isKindOfClass:[NSArray class]]) {
    NSArray *array = (NSArray *)words;
    wordsString = [array componentsJoinedByString:@"."];
  }
  
  NSString *url = [kWhat3WordsApiUrl stringByAppendingString:@"w3w"];
  [self postRequestToUrl:url
                  params:@{ @"string" : wordsString }
              completion:completion];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)positionToWords:(id)position withCompletion:(What3WordsCompletion)completion
{
  if (!([position isKindOfClass:[NSArray class]] || [position isKindOfClass:[NSString class]])) {
    NSLog(@"You need to provide either an NSArray or NSString");
    if (completion) {
      completion(nil, nil);
    }
    return;
  }
  
  NSString *positionString = (NSString *)position;
  if ([position isKindOfClass:[NSArray class]]) {
    NSArray *array = (NSArray *)position;
    positionString = [array componentsJoinedByString:@","];
  }
  
  NSString *url = [kWhat3WordsApiUrl stringByAppendingString:@"position"];
  [self postRequestToUrl:url
                  params:@{ @"position" : positionString }
              completion:completion];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)postRequestToUrl:(NSString *)url
                  params:(NSDictionary *)params
              completion:(What3WordsCompletion)completion
{
  if (!_apiKey) {
    if (completion) {
      completion(nil, nil);
    }
    return;
  }
  
  NSMutableDictionary *apiParams = [NSMutableDictionary dictionary];
  apiParams[@"key"] = _apiKey;
  apiParams[@"lang"] = _language;
  
  if (params) {
    [apiParams addEntriesFromDictionary:params];
  }
  
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  [manager POST:url
     parameters:apiParams
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
          if (completion) {
            completion(responseObject, nil);
          }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          if (completion) {
            completion(nil, error);
          }
        }];
}

@end
