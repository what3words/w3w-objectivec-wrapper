//
//  What3Words.h
//  W3wWrapper
//
//  Created by What3Words on 08/01/15.
//  Copyright (c) 2015 What3Words. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^What3WordsCompletion)(NSDictionary *result, NSError *error);

@interface What3Words : NSObject

/**
 * Default language: 'en'
 * Change to your default language
 */
@property (nonatomic, strong) NSString *language;

// Init with your own apiKey
- (instancetype)initWithWithApiKey:(NSString *)apiKey;

// Get the available languages
- (void)getLanguagesWithCompletion:(What3WordsCompletion)completion;

/**
 * Convert 3 words or OneWord into position
 * Takes words either as NSString, or NSArray of words
 * Ex: @"table.lamp.chair" or @[ @"table", @"lamp", @"chair" ]
 */
- (void)wordsToPosition:(id)words withCompletion:(What3WordsCompletion)completion;

/**
 * Convert a position into 3 words
 * Takes position either as NSString, or array of 2 values
 * Ex: @"43.23,23.20" or @[ @(43.23), @(23.20) ]
 */
- (void)positionToWords:(id)position withCompletion:(What3WordsCompletion)completion;

@end
