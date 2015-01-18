#what3words Objective-C-wrapper

Use the what3words API in your application (see http://what3words.com/api/reference)


## Installation

This will require AFNetworking included, if you aren't already using it:
https://github.com/AFNetworking/AFNetworking

Copy the What3Words.h and What3Words.m files into your Xcode project


## Usage

### What3Words object

You will need to initialize an What3Words object with your api key:
```
What3Words *w3w = [[What3Words alloc] initWithWithApiKey:@"YOURAPIKEY"];
```

### Get the available languages
This method takes an What3WordsCompletion completion block:  
<b>- (void)getLanguagesWithCompletion:(What3WordsCompletion)completion;</b>

Usage:
```
[w3w getLanguagesWithCompletion:^(NSDictionary *result, NSError *error) {
    NSLog(@"languages: %@", result);
}];
```


### Convert words to position  
<b>- (void)wordsToPosition:(id)words withCompletion:(What3WordsCompletion)completion;</b>  
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
<b>- (void)positionToWords:(id)position withCompletion:(What3WordsCompletion)completion;</b>  
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
