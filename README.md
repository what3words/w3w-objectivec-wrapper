#what3words Objective-C-wrapper

Use the what3words API in your application (see http://developer.what3words.com/api)


## Installation

This will require AFNetworking included, if you aren't already using it:
https://github.com/AFNetworking/AFNetworking

Copy the what3words.h and what3words.m files into your Xcode project


## Usage

### what3words object

You will need to initialize an what3words object with your api key:
```
what3words *w3w = [[what3words alloc] initWithWithApiKey:@"YOURAPIKEY"];
```

### Get the available languages
This method takes an what3wordsCompletion completion block:  
<b>- (void)getLanguagesWithCompletion:(what3wordsCompletion)completion;</b>

Usage:
```
[w3w getLanguagesWithCompletion:^(NSDictionary *result, NSError *error) {
    NSLog(@"languages: %@", result);
}];
```


### Convert words to position  
<b>- (void)wordsToPosition:(id)words withCompletion:(what3wordsCompletion)completion;</b>  
words argument can be one of the following:
- an NSString ex: @"table.lamp.chair"
- an NSArray ex: @[ @"table", @"lamp", @"chair" ]

Usage:
```
[w3w wordsToPosition:@[ @"table", @"chair", @"lamp" ]
      withCompletion:^(NSDictionary *result, NSError *error) {
    NSLog(@"aici: %@", result);
}];
```

### Convert position into 3 words  
<b>- (void)positionToWords:(id)position withCompletion:(what3wordsCompletion)completion;</b>  
position argument can be one of the following:
- an NSString ex: @"43.23,23.20"
- an NSArray ex: @[ @(43.23), @(23.20) ]

Usage:
```
[w3w positionToWords:@"43.23,23.20"
      withCompletion:^(NSDictionary *result, NSError *error) {
    NSLog(@"aici: %@", result);
}];
```
