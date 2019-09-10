//
//  W3wGeocoder.m
//  what3words
//
//  Created by Dave Duprey on 18/02/2019.
//  Copyright © 2019 What3Words. All rights reserved.
//

#import "W3wGeocoder.h"
#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
    @import UIKit;
#endif


@implementation W3wGeocoder

/**
 You'll need to register for a what3words API key to access the API.
 Setup W3wGeocoder with your own apiKey.
 @param key What3Words api key
 */
- (id)initWithApiKey:(NSString *)key
  {
  if (self = [super init])
    {
    apiUrl = API_URL;
    apiKey = key;
    [self figureOutVersions];
    }

  return self;
  }


  /**
   Converts a 3 word address to a position, expressed as coordinates of latitude and longitude.
   - parameter words: A 3 word address as a string
   - parameter format: Return data format type; can be one of json (the default) or geojson
   - parameter completion: A W3wGeocodeResponseHandler completion handler
   */
-(void)convertToCoordinates:(NSString *)words format:(enum Format)format completion:(void (^)(W3wPlace *result, W3wError *error))completion
  {
  NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:words, @"words", [W3wGeocoder stringForFormat:format], @"format", nil];

  [self performRequest:@"convert-to-coordinates" params:params completion:^(NSDictionary *result, W3wError *error)
      {
      completion([[W3wPlace alloc] initWithResult:result], error);
      }];
  }


/// Alternate to convertTo3wa with default format
-(void)convertToCoordinates:(NSString *)words completion:(void (^)(W3wPlace *place, W3wError *error))completion
  {
  [self convertToCoordinates:words format:JSON completion:completion];
  }


  /**
   Returns a three word address from a latitude and longitude
   - parameter coordinates: A CLLocationCoordinate2D object
   - parameter language: A supported 3 word address language as an ISO 639-1 2 letter code. Defaults to en
   - parameter format: Return data format type; can be one of json (the default) or geojson
   - parameter completion: A W3wGeocodeResponseHandler completion handler
   */
-(void)convertTo3wa:(CLLocationCoordinate2D)coordinates language:(NSString *)language format:(enum Format)format completion:(void (^)(W3wPlace *result, W3wError *error))completion
  {
  NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys: [NSString stringWithFormat:@"%f,%f", coordinates.latitude, coordinates.longitude], @"coordinates", [W3wGeocoder stringForFormat:format], @"format", nil];

  if ([language length] > 0)
    [params setValue:language forKey:@"language"];

  [self performRequest:@"convert-to-3wa" params:params completion:^(NSDictionary *result, W3wError *error)
      {
      completion([[W3wPlace alloc] initWithResult:result], error);
      }];
  }

/// Alternate to convertTo3wa with default language and format
-(void)convertTo3wa:(CLLocationCoordinate2D)coordinates completion:(void (^)(W3wPlace *place, W3wError *error))completion
  {
  [self convertTo3wa:coordinates language:@"" format:JSON completion:completion];
  }

/// Alternate to convertTo3wa with default format
-(void)convertTo3wa:(CLLocationCoordinate2D)coordinates language:(NSString *)language completion:(void (^)(W3wPlace *place, W3wError *error))completion
  {
  [self convertTo3wa:coordinates language:language format:JSON completion:completion];
  }

/// Alternate to convertTo3wa with default language
-(void)convertTo3wa:(CLLocationCoordinate2D)coordinates format:(enum Format)format completion:(void (^)(W3wPlace *place, W3wError *error))completion
  {
  [self convertTo3wa:coordinates language:@"" format:format completion:completion];
  }


  /**
   Returns a section of the 3m x 3m what3words grid for a given area.
   - parameter bounding-box: Bounding box, as a lat,lng,lat,lng, for which the grid should be returned. The requested box must not exceed 4km from corner to corner, or a BadBoundingBoxTooBig error will be returned. Latitudes must be >= -90 and <= 90, but longitudes are allowed to wrap around 180. To specify a bounding-box that crosses the anti-meridian, use longitude greater than 180. Example value: "50.0,179.995,50.01,180.0005" .
   - parameter format: Return data format type; can be one of json (the default) or geojson Example value:format=Format.json
   - parameter completion: A W3wGeocodeResponseHandler completion handler
   */
-(void)gridSection:(double)south_lat west_lng:(double)west_lng north_lat:(double)north_lat east_lng:(double)east_lng format:(enum Format)format completion:(void (^)(NSArray *grid, W3wError *error))completion
  {
  NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys: [NSString stringWithFormat:@"%f,%f,%f,%f", south_lat, west_lng, north_lat, east_lng], @"bounding-box", [W3wGeocoder stringForFormat:format], @"format", nil];

  [self performRequest:@"grid-section" params:params completion:^(NSDictionary *result, W3wError *error)
      {
      NSMutableArray *grid = [[NSMutableArray alloc] init];
      
      for (NSDictionary *line in result[@"lines"])
        [grid addObject:[[W3wLine alloc] initWithResult:line]];
      
      completion(grid, error);
      }];
  }

/// Alternate to convertTo3wa with default format
-(void)gridSection:(double)south_lat west_lng:(double)west_lng north_lat:(double)north_lat east_lng:(double)east_lng completion:(void (^)(NSArray *grid, W3wError *error))completion
  {
  [self gridSection:south_lat west_lng:west_lng north_lat:north_lat east_lng:east_lng format:JSON completion:completion];
  }


/**
 Retrieves a list of the currently loaded and available 3 word address languages.
 - parameter completion: A W3wGeocodeResponseHandler completion handler
 */
-(void)availableLanguages:(void (^)(NSArray *languages, W3wError *error))completion
  {
  [self performRequest:@"available-languages" params:@{} completion:^(NSDictionary *result, W3wError *error)
      {
      NSMutableArray *languages = [[NSMutableArray alloc] init];
      
      for (NSDictionary *line in result[@"languages"])
        [languages addObject:[[W3wLanguage alloc] initWithResult:line]];
      
      completion(languages, error);
      }];
  }


/**
 Returns a list of 3 word addresses based on user input and other parameters.
 - parameter input: The full or partial 3 word address to obtain suggestions for. At minimum this must be the first two complete words plus at least one character from the third word.
 - options are provided by instantiating AutoSuggestOption objects in the varidic length parameter list.  Eg:
      -  autosuggest(input: "filled.count.soap", options: FallbackLanguage("en"), BoundingCircle(51.4243877, -0.3474524, 4.0), NumberResults(5), completion_handler)
 
 - option NumberResults(numberOfResults:String): The number of AutoSuggest results to return. A maximum of 100 results can be specified, if a number greater than this is requested, this will be truncated to the maximum. The default is 3
 - option Focus(focus:CLLocationCoordinate2D): This is a location, specified as a latitude (often where the user making the query is). If specified, the results will be weighted to give preference to those near the focus. For convenience, longitude is allowed to wrap around the 180 line, so 361 is equivalent to 1.
 - option NumberFocusResults(numberFocusResults:Int): Specifies the number of results (must be <= n-results) within the results set which will have a focus. Defaults to n-results. This allows you to run autosuggest with a mix of focussed and unfocussed results, to give you a "blend" of the two. This is exactly what the old V2 standarblend did, and standardblend behaviour can easily be replicated by passing n-focus-results=1, which will return just one focussed result and the rest unfocussed.
 - option BoundingCountry(country:String): Restricts autosuggest to only return results inside the countries specified by comma-separated list of uppercase ISO 3166-1 alpha-2 country codes (for example, to restrict to Belgium and the UK, use clip-to-country=GB,BE). Clip-to-country will also accept lowercase country codes. Entries must be two a-z letters. WARNING: If the two-letter code does not correspond to a country, there is no error: API simply returns no results. eg: "NZ,AU"
 - option BoundingBox(south_lat:Double, west_lng:Double, north_lat: Double, east_lng:Double): Restrict autosuggest results to a bounding box, specified by coordinates. Such as south_lat,west_lng,north_lat,east_lng, where: south_lat <= north_lat west_lng <= east_lng In other words, latitudes and longitudes should be specified order of increasing size. Lng is allowed to wrap, so that you can specify bounding boxes which cross the ante-meridian: -4,178.2,22,195.4 Example value: "51.521,-0.343,52.6,2.3324"
 - option BoundingCircle(lat:Double, lng:Double, kilometers:Double): Restrict autosuggest results to a circle, specified by lat,lng,kilometres. For convenience, longitude is allowed to wrap around 180 degrees. For example 181 is equivalent to -179. Example value: "51.521,-0.343,142"
 - option BoundingPolygon(polygon:[CLLocationCoordinate2D]): Restrict autosuggest results to a polygon, specified by a comma-separated list of lat,lng pairs. The polygon should be closed, i.e. the first element should be repeated as the last element; also the list should contain at least 4 entries. The API is currently limited to accepting up to 25 pairs. Example value: "51.521,-0.343,52.6,2.3324,54.234,8.343,51.521,-0.343"
 - option InputType(inputType:InputTypeEnum): For power users, used to specify voice input mode. Can be text (default), vocon-hybrid or nmdp-asr. See voice recognition section for more details.
 - option FallbackLanguage(language:String): For normal text input, specifies a fallback language, which will help guide AutoSuggest if the input is particularly messy. If specified, this parameter must be a supported 3 word address language as an ISO 639-1 2 letter code. For voice input (see voice section), language must always be specified.
 */
-(void)autosuggest:(NSString *)input parameters:(NSArray *)parameters completion:(void (^)(NSArray *suggestions, W3wError *error))completion
  {
  NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys: input, @"input", nil];
    {
    for (AutoSuggestOption *option in parameters)
      {
      if ([option isKindOfClass:[AutoSuggestOption class]]) // make sure its the right kind of object
        [params setObject:option.value forKey:option.key];
      }

    [self performRequest:@"autosuggest" params:params completion:^(NSDictionary *result, W3wError *error)
      {
      NSMutableArray *suggestions = [[NSMutableArray alloc] init];
      
      for (NSDictionary *line in result[@"suggestions"])
        [suggestions addObject:[[W3wSuggestion alloc] initWithResult:line]];
      
      completion(suggestions, error);
      }];
    }
  }


/// Alternate to autosuggest with one options (no need for the caller to make an array)
-(void)autosuggest:(NSString *)input parameter:(AutoSuggestOption *)parameter completion:(void (^)(NSArray *suggestions, W3wError *error))completion
  {
  [self autosuggest:input parameters:@[parameter] completion:completion];
  }


/// Alternate to autosuggest with no options
-(void)autosuggest:(NSString *)input completion:(void (^)(NSArray *suggestions, W3wError *error))completion
  {
  [self autosuggest:input parameters:@[] completion:completion];
  }


  // MARK: API Request


-(void)performRequest:(NSString *)path params:(NSDictionary *)params completion:(void (^)(NSDictionary *result, W3wError *error))completion
  {
  // put the parameters into an array
  NSMutableArray *queryItems = [[NSMutableArray alloc] init];
  [queryItems addObject:[[NSURLQueryItem alloc] initWithName:@"key" value:apiKey]];
  for (NSString *key in params)
    {
    NSString *value = [params objectForKey:key];
    [queryItems addObject:[[NSURLQueryItem alloc] initWithName:key value:value]];
    }

  // make an URLComponents object with the parameters
  NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:[NSString stringWithFormat:@"%@%@", API_URL, path]];
  urlComponents.queryItems = queryItems;

  // make the call
  if (urlComponents.URL != NULL)
    {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:urlComponents.URL];
    [request setValue:versionHeader forHTTPHeaderField:@"X-W3W-Wrapper"];
    [request setValue:bundleHeader forHTTPHeaderField:@"X-Ios-Bundle-Identifier"];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
      NSDictionary *json     = NULL;
      
      // handle the response
      if (data != NULL)
        {
        json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

        // if an error code is returned in the json, maybe bad input to the call...
        if (json[@"error"])
          completion(NULL, [[W3wError alloc] initWithCode:json[@"error"][@"code"] message:json[@"error"][@"message"]]);
        else
          {
          // call was good, returned data was useful
          completion(json, NULL);
          }
        }
      else
        {
        // if there was an error with the call, maybe no connection...
        if (error)
          completion(NULL, [[W3wError alloc] initWithCode:@"BadConnection" message:error.localizedDescription]);
        }
      }];
    
    [task resume];
    }

  }





// Establish the various version numbers in order to set an HTTP header for the URL session
-(void)figureOutVersions
  {
  #if TARGET_OS_IPHONE
    NSString *os_name = [[UIDevice currentDevice] systemName];
  #else
    NSString *os_name = @"Mac";
  #endif
  
  NSOperatingSystemVersion os_version   = [[NSProcessInfo processInfo] operatingSystemVersion];
  int                      objc_version = OBJC_API_VERSION;
  //NSString                 *api_version = [NSBundle bundleForClass:[W3wGeocoder class]].infoDictionary[@"CFBundleShortVersionString"];
  NSBundle *bundle = [NSBundle bundleForClass:[W3wGeocoder class]];
  NSDictionary *dictionary = bundle.infoDictionary;
  NSString *api_version = dictionary[@"CFBundleShortVersionString"];

  versionHeader = [NSString stringWithFormat:@"what3words-ObjC/%@ (ObjC %d; %@ %ld.%ld.%ld)", api_version, objc_version, os_name, (long)os_version.majorVersion, (long)os_version.minorVersion, (long)os_version.patchVersion];
  bundleHeader  = [[NSBundle mainBundle] bundleIdentifier];
  }





  // MARK: Utility


+(NSString *)stringForFormat:(enum Format)format
  {
  if (format == JSON)
    return @"json";
  else
    return @"geo-json";
  }

+(NSString *)stringForInputType:(enum InputType)input_type
  {
  if (input_type == VOCONHYBRID)
    return @"vocon-hybrid";
  else if (input_type == GENERIC_VOICE)
    return @"generic-voice";
  else
    return @"nmdp-asr";
  }


@end


@implementation AutoSuggestOption
@synthesize key;
@synthesize value;

+(AutoSuggestOption *)fallBackLanguage:(NSString *)language         { return [[AutoSuggestOption alloc] initAsFallbackLanguage:language]; }
+(AutoSuggestOption *)numberResults:(int)number_results             { return [[AutoSuggestOption alloc] initAsNumberResults:number_results]; }
+(AutoSuggestOption *)focus:(CLLocationCoordinate2D)focus           { return [[AutoSuggestOption alloc] initAsFocus:focus]; }
+(AutoSuggestOption *)numberFocusResults:(int)number_focus_results  { return [[AutoSuggestOption alloc] initAsNumberFocusResults:number_focus_results]; }
+(AutoSuggestOption *)inputType:(enum InputType)input_type          { return [[AutoSuggestOption alloc] initAsInputType:input_type]; }
+(AutoSuggestOption *)clipToCountry:(NSString *)country             { return [[AutoSuggestOption alloc] initAsClipToCountry:country]; }
+(AutoSuggestOption *)clipToPolygon:(NSArray *)polygon              { return [[AutoSuggestOption alloc] initAsClipToPolygon:polygon]; }
+(AutoSuggestOption *)preferLand:(BOOL)land                         { return [[AutoSuggestOption alloc] initAsPreferLand:land]; }

+(AutoSuggestOption *)clipToCircle:(CLLocationCoordinate2D)centre radius:(double)kilometers { return [[AutoSuggestOption alloc] initAsClipToCircle:centre radius:kilometers]; }

+(AutoSuggestOption *)clipToBoundingBox:(float)south_lat west_lng:(float)west_lng north_lat:(float)north_lat east_lng:(float)east_lng { return [[AutoSuggestOption alloc] initAsBoundingBox:south_lat west_lng:west_lng north_lat:north_lat east_lng:east_lng]; };


-(id)initAsBoundingBox:(float)south_lat west_lng:(float)west_lng north_lat:(float)north_lat east_lng:(float)east_lng
  {
  if (self = [super init])
    {
    key   = @"clip-to-bounding-box";
    value = [NSString stringWithFormat:@"%f,%f,%f,%f", south_lat, west_lng, north_lat, east_lng];
    }
  
  return self;
  }


-(id)initAsFallbackLanguage:(NSString *)language
  {
  if (self = [super init])
    {
    key   = @"language";
    value = language;
    }
  
  return self;
  }

-(id)initAsNumberResults:(int)number_results
  {
  if (self = [super init])
    {
    key   = @"n-results";
    value = [NSString stringWithFormat:@"%d", number_results];
    }
  
  return self;
  }

-(id)initAsFocus:(CLLocationCoordinate2D)focus
  {
  if (self = [super init])
    {
    key   = @"focus";
    value = [NSString stringWithFormat:@"%f,%f", focus.latitude, focus.longitude];
    }
  
  return self;
  }

-(id)initAsNumberFocusResults:(int)number_focus_results
  {
  if (self = [super init])
    {
    key   = @"n-focus-results";
    value = [NSString stringWithFormat:@"%d", number_focus_results];
    }
  
  return self;
  }

-(id)initAsInputType:(enum InputType)input_type
  {
  if (self = [super init])
    {
    key   = @"input-type";
    value = [W3wGeocoder stringForInputType:input_type];
    }
  
  return self;
  }

-(id)initAsClipToCountry:(NSString *)country
  {
  if (self = [super init])
    {
    key   = @"clip-to-country";
    value = country;
    }
  
  return self;
  }

-(id)initAsClipToCircle:(CLLocationCoordinate2D)centre radius:(double)kilometers
  {
  if (self = [super init])
    {
    key   = @"clip-to-circle";
    value = [NSString stringWithFormat:@"%f,%f,%f", centre.latitude, centre.longitude, kilometers];
    }
  
  return self;
  }


-(id)initAsClipToPolygon:(NSArray *)polygon
{
    if (self = [super init])
    {
        key   = @"clip-to-polygon";
        value = @"";
        
        for (CLLocation *coord in polygon)
            value = [value stringByAppendingFormat:@"%f,%f,", coord.coordinate.latitude, coord.coordinate.longitude];
    }
    
    // remove last comma if there was anything added to the string
    if (![value isEqualToString:@""])
        value = [value substringToIndex:[value length]-1];
    
    return self;
}


-(id)initAsPreferLand:(BOOL)land
  {
  if (self = [super init])
    {
    key   = @"prefer-land";
      
    if (land)
      value = @"true";
    else
      value = @"false";
    }
  
  return self;
  }


@end

@implementation W3wError
@synthesize code;
@synthesize message;

-(id)initWithCode:(NSString *)the_code message:(NSString *)the_message
  {
  if (self = [super init])
    {
    code    = the_code;
    message = the_message;
    }

  return self;
  }

@end


@implementation W3wPlace
@synthesize country;
@synthesize southWest;
@synthesize northEast;
@synthesize nearestPlace;
@synthesize coordinates;
@synthesize words;
@synthesize language;
@synthesize map;

-(id)initWithResult:(NSDictionary *)result
  {
  if (self = [super init])
    {
    country      = result[@"country"];
    nearestPlace = result[@"nearestPlace"];
    words        = result[@"words"];
    language     = result[@"language"];
    map          = result[@"map"];
    northEast    = CLLocationCoordinate2DMake([result[@"square"][@"northeast"][@"lat"] floatValue], [result[@"square"][@"northeast"][@"lng"] floatValue]);
    southWest    = CLLocationCoordinate2DMake([result[@"square"][@"southwest"][@"lat"] floatValue], [result[@"square"][@"southwest"][@"lng"] floatValue]);
    coordinates  = CLLocationCoordinate2DMake([result[@"coordinates"][@"lat"] floatValue], [result[@"coordinates"][@"lng"] floatValue]);
    }

  return self;
  }
@end


@implementation W3wLine
@synthesize start;
@synthesize end;

-(id)initWithResult:(NSDictionary *)result
  {
  if (self = [super init])
    {
    start  = CLLocationCoordinate2DMake([result[@"start"][@"lat"] floatValue], [result[@"start"][@"lng"] floatValue]);
    end    = CLLocationCoordinate2DMake([result[@"end"][@"lat"] floatValue], [result[@"end"][@"lng"] floatValue]);
    }

  return self;
  }

@end


@implementation W3wLanguage : NSObject { }
@synthesize name;
@synthesize code;
@synthesize nativeName;

-(id)initWithResult:(NSDictionary *)result
  {
  if (self = [super init])
    {
    name       = result[@"name"];
    code       = result[@"code"];
    nativeName = result[@"nativeName"];
    }

  return self;
  }
@end


@implementation W3wSuggestion : NSObject { }
@synthesize country;
@synthesize nearestPlace;
@synthesize words;
@synthesize distanceToFocusKm;
@synthesize language;

-(id)initWithResult:(NSDictionary *)result
  {
  if (self = [super init])
    {
    country           = result[@"country"];
    nearestPlace      = result[@"nearestPlace"];
    words             = result[@"words"];
    language          = result[@"language"];
    distanceToFocusKm = [NSNumber numberWithFloat:[result[@"distanceToFocusKm"] floatValue]];
    }

  return self;
  }

@end
