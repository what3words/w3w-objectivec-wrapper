//
//  W3wGeocoder.h
//  what3words
//
//  Created by Dave Duprey on 18/02/2019.
//  Copyright © 2019 What3Words. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

#define API_URL @"https://api.what3words.com/v3/"

enum Format { JSON, GEOJSON };
enum InputType { VOCONHYBRID, NMDPASR };


@interface W3wError : NSObject { }
@property NSString *code;
@property NSString *message;
-(id)initWithCode:(NSString *)the_code message:(NSString *)the_message;
@end

@interface W3wPlace : NSObject { }
@property NSString *country;
@property CLLocationCoordinate2D southWest;
@property CLLocationCoordinate2D northEast;
@property NSString *nearestPlace;
@property CLLocationCoordinate2D coordinates;
@property NSString *words;
@property NSString *language;
@property NSString *map;
-(id)initWithResult:(NSDictionary *)result;
@end

@interface W3wLine : NSObject { }
@property CLLocationCoordinate2D start;
@property CLLocationCoordinate2D end;
-(id)initWithResult:(NSDictionary *)result;
@end

@interface W3wLanguage : NSObject { }
@property NSString *name;
@property NSString *code;
@property NSString *nativeName;
-(id)initWithResult:(NSDictionary *)result;
@end


@interface W3wSuggestion : NSObject { }
@property NSString *country;
@property NSString *nearestPlace;
@property NSString *words;
@property NSNumber *distanceToFocusKm;
@property NSString *language;
-(id)initWithResult:(NSDictionary *)result;
@end


@interface AutoSuggestOption : NSObject { }
@property NSString *key;
@property NSString *value;

+(AutoSuggestOption *)fallBackLanguage:(NSString *)language;
+(AutoSuggestOption *)numberResults:(int)number_results;
+(AutoSuggestOption *)focus:(CLLocationCoordinate2D)focus;
+(AutoSuggestOption *)numberFocusResults:(int)number_focus_results;
+(AutoSuggestOption *)inputType:(enum InputType)input_type;
+(AutoSuggestOption *)clipToCountry:(NSString *)country;
+(AutoSuggestOption *)clipToCircle:(CLLocationCoordinate2D)centre radius:(double)kilometers;
+(AutoSuggestOption *)clipToBoundingBox:(float)south_lat west_lng:(float)west_lng north_lat:(float)north_lat east_lng:(float)east_lng;
+(AutoSuggestOption *)clipToPolygon:(NSArray *)polygon;

-(id)initAsFallbackLanguage:(NSString *)language;
-(id)initAsNumberResults:(int)number_results;
-(id)initAsFocus:(CLLocationCoordinate2D)focus;
-(id)initAsNumberFocusResults:(int)number_focus_results;
-(id)initAsInputType:(enum InputType)format;
-(id)initAsClipToCountry:(NSString *)country;
-(id)initAsClipToCircle:(CLLocationCoordinate2D)centre radius:(double)kilometers;
-(id)initAsClipToPolygon:(NSArray *)polygon;

@end


@interface W3wGeocoder : NSObject {
  NSString *apiUrl;
  NSString *apiKey;
  NSString *versionHeader;
}

-(id)initWithApiKey:(NSString *)key;

-(void)convertToCoordinates:(NSString *)words format:(enum Format)format completion:(void (^)(W3wPlace *place, W3wError *error))completion;
-(void)convertToCoordinates:(NSString *)words completion:(void (^)(W3wPlace *place, W3wError *error))completion;

-(void)convertTo3wa:(CLLocationCoordinate2D)coordinates language:(NSString *)language format:(enum Format)format completion:(void (^)(W3wPlace *place, W3wError *error))completion;
-(void)convertTo3wa:(CLLocationCoordinate2D)coordinates completion:(void (^)(W3wPlace *place, W3wError *error))completion;
-(void)convertTo3wa:(CLLocationCoordinate2D)coordinates language:(NSString *)language completion:(void (^)(W3wPlace *place, W3wError *error))completion;

-(void)gridSection:(double)south_lat west_lng:(double)west_lng north_lat:(double)north_lat east_lng:(double)east_lng format:(enum Format)format completion:(void (^)(NSArray *grid, W3wError *error))completion;
-(void)gridSection:(double)south_lat west_lng:(double)west_lng north_lat:(double)north_lat east_lng:(double)east_lng completion:(void (^)(NSArray *grid, W3wError *error))completion;

-(void)availableLanguages:(void (^)(NSArray *grid, W3wError *error))completion;

-(void)autosuggest:(NSString *)input parameters:(NSArray *)parameters completion:(void (^)(NSArray *suggestions, W3wError *error))completion;
-(void)autosuggest:(NSString *)input parameter:(AutoSuggestOption *)parameter completion:(void (^)(NSArray *suggestions, W3wError *error))completion;
-(void)autosuggest:(NSString *)input completion:(void (^)(NSArray *suggestions, W3wError *error))completion;

+(NSString *)stringForFormat:(enum Format)format;
+(NSString *)stringForInputType:(enum InputType)input_type;

-(void)performRequest:(NSString *)path params:(NSDictionary *)params completion:(void (^)(NSDictionary *result, W3wError *error))completion;

-(void)figureOutVersions;
@end


NS_ASSUME_NONNULL_END
