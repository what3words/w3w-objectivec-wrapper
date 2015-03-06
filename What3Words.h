//
//  what3words.h
//  w3wWrapper
//
//  Created by what3words on 08/01/15.
//  Copyright (c) 2015 what3words. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^what3wordsCompletion)(NSDictionary *result, NSError *error);

@interface what3words : NSObject

/**
 * Default language: 'en'
 * Change to your default language
 */
@property (nonatomic, strong) NSString *language;

// Init with your own apiKey
- (instancetype)initWithWithApiKey:(NSString *)apiKey;

// Get the available languages
- (void)getLanguagesWithCompletion:(what3wordsCompletion)completion;

/**
 * Convert 3 words or OneWord into position
 * Takes words either as NSString, or NSArray of words
 * Ex: @"table.lamp.chair" or @[ @"table", @"lamp", @"chair" ]
 */
- (void)wordsToPosition:(id)words withCompletion:(what3wordsCompletion)completion;

/**
 * Convert a position into 3 words
 * Takes position either as NSString, or array of 2 values
 * Ex: @"43.23,23.20" or @[ @(43.23), @(23.20) ]
 */
- (void)positionToWords:(id)position withCompletion:(what3wordsCompletion)completion;

@end
