//
//  what3words.m
//  w3wWrapper
//
//  Created by what3words on 08/01/15.
//  Copyright (c) 2015 what3words. All rights reserved.
//

#import "what3words.h"
#import <AFNetworking/AFNetworking.h>

NSString *const kwhat3wordsApiUrl = @"http://api.what3words.com/";

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@interface what3words()

@property (nonatomic, strong) NSString *apiKey;

@end


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation what3words


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
- (void)getLanguagesWithCompletion:(what3wordsCompletion)completion
{
  NSString *url = [kwhat3wordsApiUrl stringByAppendingString:@"get-languages"];
  [self postRequestToUrl:url params:nil completion:completion];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)wordsToPosition:(id)words withCompletion:(what3wordsCompletion)completion
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
  
  NSString *url = [kwhat3wordsApiUrl stringByAppendingString:@"w3w"];
  [self postRequestToUrl:url
                  params:@{ @"string" : wordsString }
              completion:completion];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)positionToWords:(id)position withCompletion:(what3wordsCompletion)completion
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
  
  NSString *url = [kwhat3wordsApiUrl stringByAppendingString:@"position"];
  [self postRequestToUrl:url
                  params:@{ @"position" : positionString }
              completion:completion];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)postRequestToUrl:(NSString *)url
                  params:(NSDictionary *)params
              completion:(what3wordsCompletion)completion
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
