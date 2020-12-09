# <img valign='top' src="https://what3words.com/assets/images/w3w_square_red.png" width="64" height="64" alt="what3words">&nbsp;w3w-objective-c-wrapper

An Objective-C library to use the [what3words REST API](https://docs.what3words.com/api/v3/).

# Overview

The what3words Objective-C wrapper gives you programmatic access to 

* convert a 3 word address to coordinates 
* convert coordinates to a 3 word address
* autosuggest functionality which takes a slightly incorrect 3 word address, and suggests a list of valid 3 word addresses
* obtain a section of the 3m x 3m what3words grid for a bounding box.
* determine the currently support 3 word address languages.

## Authentication

To use this library you’ll need a what3words API key, which can be signed up for [here](https://what3words.com/select-plan).

# Installation

To use this library in your project manually just drag W3wGeocoder.m and  W3wGeocoder.h into the project tree

###Package Managers

Cocoapod 

```
platform :ios, '9.0'
use_frameworks!

target 'MyApp' do
    pod 'what3words', :git => 'https://github.com/what3words/w3w-objectivec-wrapper.git'
end
```      
Carthage

```
github "what3words/w3w-objectivec-wrapper"
```


### Import

Cocoapods or Manual:
      
```objective-c
#import "W3wGeocoder.h"
```
Carthage:

```objective-c
#import <what3words/what3words.h>
```

### Initialize

```objective-c
W3wGeocoder *api = [[W3wGeocoder alloc] initWithApiKey:@"Secret API Key"];
```

## Convert To 3 Word Address

Convert coordinates, expressed as latitude and longitude to a 3 word address.

This method takes the latitude and longitude as a CLLocationCoordinate2D object

The returned payload from the `convertTo3wa` method is described in the [what3words REST API documentation](https://docs.what3words.com/api/v3/#convert-to-3wa).

##### Code Example
```objective-c
CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake(51.521238, -0.203607);
  
[api convertTo3wa:coordinates completion:^(W3wPlace *place, W3wError *error)
    {
    NSLog(@"%@", place.words);
    }];
```


## Convert To Coordinates
Convert a 3 word address to a position, expressed as coordinates of latitude and longitude.

This method takes the words parameter as a string of 3 words `'table.book.chair'`

The returned payload from the `convertToCoordinates` method is described in the [what3words REST API documentation](https://docs.what3words.com/api/v3/#convert-to-coordinates).

##### Code Example
```objective-c
[api convertToCoordinates:@"index.home.raft" format:JSON completion:^(W3wPlace *place, W3wError *error)
    {
    NSLog(@"Coordinates are: (%f, %f)", place.coordinates.latitude, place.coordinates.longitude);
    }];
```

## AutoSuggest

Returns a list of 3 word addresses based on user input and other parameters.

This method provides corrections for the following types of input error:
* typing errors
* spelling errors
* misremembered words (e.g. singular vs. plural)
* words in the wrong order

The `autoSuggest` method determines possible corrections to the supplied 3 word address string based on the probability of the input errors listed above and returns a ranked list of suggestions. This method can also take into consideration the geographic proximity of possible corrections to a given location to further improve the suggestions returned.

### Input 3 word address

You will only receive results back if the partial 3 word address string you submit contains the first two words and at least the first character of the third word; otherwise an error message will be returned.

### Clipping and Focus

We provide various clip policies to allow you to specify a geographic area that is used to exclude results that are not likely to be relevant to your users. We recommend that you use the clipping to give a more targeted, shorter set of results to your user. If you know your user’s current location, we also strongly recommend that you use the `focus` to return results which are likely to be more relevant.

In summary, the clip policy is used to optionally restrict the list of candidate AutoSuggest results, after which, if focus has been supplied, this will be used to rank the results in order of relevancy to the focus.

The returned payload from the `autosuggest` method is described in the [what3words REST API documentation](https://docs.what3words.com/api/v2/#autosuggest-result).

### Usage

The first parameter `input` is the partial three words, or voice data.  It is followed by an array of AutoSuggestOption objects.  Alternate versions allow no option objects, or one with no array wrapper.  The last parameter is the completion block.

#### Code Example
```objective-c
[api autosuggest:@"geschaft.planter.carciofi" completion:^(NSArray *suggestions, W3wError *error)
    {
    W3wSuggestion *first_match = suggestions[0];
    NSLog(@"%@", first_match.words);
    }];
```


#### Code Example Two
```objective-c
[api autosuggest:@"fun.with.code" parameters:@[[AutoSuggestOption focus:CLLocationCoordinate2DMake(51.4243877, -0.3474524)], [AutoSuggestOption numberResults:6]] completion:^(NSArray *suggestions, W3wError *error)
    {
    W3wSuggestion *first_match = suggestions[0];
    NSLog(@"%@", first_match.words);
    }];
```

## Available Languages

This function returns the currently supported languages.  It will return the two letter code ([ISO 639](https://en.wikipedia.org/wiki/ISO_639)), and the name of the language both in that language and in English.

The returned payload from the `convertTo3wa` method is described in the [what3words REST API documentation](https://docs.what3words.com/api/v3/#available-languages)

##### Code Example
```objective-c
[api availableLanguages:^(NSArray *languages, W3wError *error)
    {
    W3wLanguage *language = languages[0];
    NSLog(@"First language returned: %@", language.name);
    }];
```

##### Example: Limit the search to 4 suggestions in Germany.
```objective-c
[api autosuggest:@"geschaft.planter.carciofi" parameters:@[ [AutoSuggestOption clipToCountry:@"DE"], [AutoSuggestOption numberResults:4]] completion:^(NSArray *suggestions, W3wError *error)
    {
    W3wSuggestion *first_match = suggestions[0];
    NSLog(@"%@", first_match.words);
    }];
```


## Grid Section

Returns a section of the 3m x 3m what3words grid for a given area. The requested box must not exceed 4km from corner to corner, or a BadBoundingBoxTooBig error will be returned. Latitudes must be >= -90 and <= 90, but longitudes are allowed to wrap around 180. To specify a bounding-box that crosses the anti-meridian, use longitude greater than 180. Example value: 50.0, 179.995, 50.01, 180.0005. 

The returned payload from the `gridSection` method is described in the [what3words REST API documentation](https://docs.what3words.com/api/v3/#grid-section)

##### Code Example
```objective-c
[api gridSection:52.208867 west_lng:0.117540 north_lat:52.207988 east_lng:0.116126 format:JSON completion:^(NSArray *grid, W3wError *error)
    {
    W3wLine *first_line = grid[0];
    NSLog(@"First line goes from (%.5f,%.5f) to (%.5f,%.5f)", first_line.start.latitude, first_line.start.longitude, first_line.end.latitude, first_line.end.longitude);
    }];
```



## Handling Errors

All functions call the completion block with `error` as the second parameter.  If there are no errors, it's value is NULL.  Be sure to check it for possible problems.

```php
[api convertToCoordinates:@"aaaa.bbbb.cccc" format:JSON completion:^(NSDictionary *result, W3wError *error)
    {
    if (error)
        NSLog(@"There was an %@ error: %@", error.code, error.message);
    }];
```

Error values are listed in the [what3words REST API documentation](https://docs.what3words.com/api/v3/#error-handling). 
