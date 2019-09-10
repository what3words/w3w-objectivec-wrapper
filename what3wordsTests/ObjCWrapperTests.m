//
//  ObjCWrapperTests.m
//  what3wordsTests
//
//  Created by Dave Duprey on 18/02/2019.
//  Copyright © 2019 What3Words. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "W3wGeocoder.h"

@interface ObjCWrapperTests : XCTestCase
  {
    W3wGeocoder *api;
  }

@end

@implementation ObjCWrapperTests

- (void)setUp {

  api = [[W3wGeocoder alloc] initWithApiKey:@"<Your Secret Key>"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testconvertToCoordinates {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Convert to Coords"];
  
    NSString *words = @"index.home.raft";
  
    [api convertToCoordinates:words format:JSON completion:^(W3wPlace *place, W3wError *error)
      {
      // handle the response
      XCTAssertTrue([place.words isEqualToString:words]);
      [expectation fulfill];
      }];

    [self waitForExpectationsWithTimeout:3.0 handler:nil];
    }


- (void)testconvertTo3wa {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Convert to 3wa"];
  
    CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake(51.521238, -0.203607);
  
    [api convertTo3wa:coordinates completion:^(W3wPlace *place, W3wError *error)
      {
      XCTAssertNil(error);
      XCTAssertTrue([place.words isEqualToString:@"index.home.raft"]);
      [expectation fulfill];
      }];

    [self waitForExpectationsWithTimeout:3.0 handler:nil];
    }


- (void)testconvertTo3waLanguage {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Convert to 3wa"];
  
    CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake(51.521238, -0.203607);
  
    [api convertTo3wa:coordinates language:@"de" completion:^(W3wPlace *place, W3wError *error)
      {
      XCTAssertNil(error);
      XCTAssertTrue([place.words isEqualToString:@"welche.tischtennis.bekannte"]);
      [expectation fulfill];
      }];

    [self waitForExpectationsWithTimeout:3.0 handler:nil];
    }


- (void)testGridSection {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Grid Section"];
  
    [api gridSection:52.208867 west_lng:0.117540 north_lat:52.207988 east_lng:0.116126 format:JSON completion:^(NSArray *grid, W3wError *error)
      {
      XCTAssertNil(error);
      XCTAssertEqual([grid count], 96);
      XCTAssertNotNil(grid);
      
      [expectation fulfill];
      }];

    [self waitForExpectationsWithTimeout:3.0 handler:nil];
    }



-(void)testLanguages {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Available Languages"];
  
    [api availableLanguages:^(NSArray *languages, W3wError *error)
      {
      XCTAssertNil(error);
      XCTAssertGreaterThan([languages count], 10);
      XCTAssertNotNil(languages);
      
      [expectation fulfill];
      }];

    [self waitForExpectationsWithTimeout:3.0 handler:nil];
    }


-(void)testAutosuggestCountry {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Auto Suggest"];

    [api autosuggest:@"geschaft.planter.carciofi" parameters:@[[AutoSuggestOption clipToCountry:@"de"], [AutoSuggestOption numberResults:5]] completion:^(NSArray *suggestions, W3wError *error)
      {
      XCTAssertNil(error);

      XCTAssertGreaterThan([suggestions count], 0);
      
      if ([suggestions count] > 0)
        {
        W3wSuggestion *first_match = suggestions[0];

        // handle the response
        XCTAssertTrue(suggestions.count == 5);
        XCTAssertTrue([first_match.words isEqualToString:@"rischiare.piante.carciofi"]);
        }

      [expectation fulfill];
      }];

    [self waitForExpectationsWithTimeout:3.0 handler:nil];
    }



-(void)testAutoSuggest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Auto Suggest"];

    [api autosuggest:@"geschaft.planter.carciofi" completion:^(NSArray *suggestions, W3wError *error)
      {
      XCTAssertNil(error);

      XCTAssertGreaterThan([suggestions count], 0);
      
      if ([suggestions count] > 0)
        {
        // handle the response
        W3wSuggestion *first_match = suggestions[0];

        XCTAssertTrue(suggestions.count == 3);
        XCTAssertTrue([first_match.words isEqualToString:@"esche.piante.carciofi"]);
        }

      [expectation fulfill];
      }];

    [self waitForExpectationsWithTimeout:3.0 handler:nil];
    }


-(void)testAutoSuggestVoice {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Auto Suggest"];

    NSString *voice_data = @"%7B%22_isInGrammar%22%3A%22yes%22%2C%22_isSpeech%22%3A%22yes%22%2C%22_hypotheses%22%3A%5B%7B%22_score%22%3A342516%2C%22_startRule%22%3A%22whatthreewordsgrammar%23_main_%22%2C%22_conf%22%3A6546%2C%22_endTimeMs%22%3A6360%2C%22_beginTimeMs%22%3A1570%2C%22_lmScore%22%3A300%2C%22_items%22%3A%5B%7B%22_type%22%3A%22terminal%22%2C%22_score%22%3A34225%2C%22_orthography%22%3A%22tend%22%2C%22_conf%22%3A6964%2C%22_endTimeMs%22%3A2250%2C%22_beginTimeMs%22%3A1580%7D%2C%7B%22_type%22%3A%22terminal%22%2C%22_score%22%3A47670%2C%22_orthography%22%3A%22artichokes%22%2C%22_conf%22%3A7176%2C%22_endTimeMs%22%3A3180%2C%22_beginTimeMs%22%3A2260%7D%2C%7B%22_type%22%3A%22terminal%22%2C%22_score%22%3A43800%2C%22_orthography%22%3A%22poached%22%2C%22_conf%22%3A6181%2C%22_endTimeMs%22%3A4060%2C%22_beginTimeMs%22%3A3220%7D%5D%7D%2C%7B%22_score%22%3A342631%2C%22_startRule%22%3A%22whatthreewordsgrammar%23_main_%22%2C%22_conf%22%3A6498%2C%22_endTimeMs%22%3A6360%2C%22_beginTimeMs%22%3A1570%2C%22_lmScore%22%3A300%2C%22_items%22%3A%5B%7B%22_type%22%3A%22terminal%22%2C%22_score%22%3A34340%2C%22_orthography%22%3A%22tent%22%2C%22_conf%22%3A6772%2C%22_endTimeMs%22%3A2250%2C%22_beginTimeMs%22%3A1580%7D%2C%7B%22_type%22%3A%22terminal%22%2C%22_score%22%3A47670%2C%22_orthography%22%3A%22artichokes%22%2C%22_conf%22%3A7176%2C%22_endTimeMs%22%3A3180%2C%22_beginTimeMs%22%3A2260%7D%2C%7B%22_type%22%3A%22terminal%22%2C%22_score%22%3A43800%2C%22_orthography%22%3A%22poached%22%2C%22_conf%22%3A6181%2C%22_endTimeMs%22%3A4060%2C%22_beginTimeMs%22%3A3220%7D%5D%7D%2C%7B%22_score%22%3A342668%2C%22_startRule%22%3A%22whatthreewordsgrammar%23_main_%22%2C%22_conf%22%3A6474%2C%22_endTimeMs%22%3A6360%2C%22_beginTimeMs%22%3A1570%2C%22_lmScore%22%3A300%2C%22_items%22%3A%5B%7B%22_type%22%3A%22terminal%22%2C%22_score%22%3A34225%2C%22_orthography%22%3A%22tend%22%2C%22_conf%22%3A6964%2C%22_endTimeMs%22%3A2250%2C%22_beginTimeMs%22%3A1580%7D%2C%7B%22_type%22%3A%22terminal%22%2C%22_score%22%3A47670%2C%22_orthography%22%3A%22artichokes%22%2C%22_conf%22%3A7176%2C%22_endTimeMs%22%3A3180%2C%22_beginTimeMs%22%3A2260%7D%2C%7B%22_type%22%3A%22terminal%22%2C%22_score%22%3A41696%2C%22_orthography%22%3A%22perch%22%2C%22_conf%22%3A5950%2C%22_endTimeMs%22%3A4020%2C%22_beginTimeMs%22%3A3220%7D%5D%7D%2C%7B%22_score%22%3A342670%2C%22_startRule%22%3A%22whatthreewordsgrammar%23_main_%22%2C%22_conf%22%3A6474%2C%22_endTimeMs%22%3A6360%2C%22_beginTimeMs%22%3A1570%2C%22_lmScore%22%3A300%2C%22_items%22%3A%5B%7B%22_type%22%3A%22terminal%22%2C%22_score%22%3A34379%2C%22_orthography%22%3A%22tinge%22%2C%22_conf%22%3A6705%2C%22_endTimeMs%22%3A2250%2C%22_beginTimeMs%22%3A1580%7D%2C%7B%22_type%22%3A%22terminal%22%2C%22_score%22%3A47670%2C%22_orthography%22%3A%22artichokes%22%2C%22_conf%22%3A7176%2C%22_endTimeMs%22%3A3180%2C%22_beginTimeMs%22%3A2260%7D%2C%7B%22_type%22%3A%22terminal%22%2C%22_score%22%3A43800%2C%22_orthography%22%3A%22poached%22%2C%22_conf%22%3A6181%2C%22_endTimeMs%22%3A4060%2C%22_beginTimeMs%22%3A3220%7D%5D%7D%2C%7B%22_score%22%3A342783%2C%22_startRule%22%3A%22whatthreewordsgrammar%23_main_%22%2C%22_conf%22%3A6426%2C%22_endTimeMs%22%3A6360%2C%22_beginTimeMs%22%3A1570%2C%22_lmScore%22%3A300%2C%22_items%22%3A%5B%7B%22_type%22%3A%22terminal%22%2C%22_score%22%3A34340%2C%22_orthography%22%3A%22tent%22%2C%22_conf%22%3A6772%2C%22_endTimeMs%22%3A2250%2C%22_beginTimeMs%22%3A1580%7D%2C%7B%22_type%22%3A%22terminal%22%2C%22_score%22%3A47670%2C%22_orthography%22%3A%22artichokes%22%2C%22_conf%22%3A7176%2C%22_endTimeMs%22%3A3180%2C%22_beginTimeMs%22%3A2260%7D%2C%7B%22_type%22%3A%22terminal%22%2C%22_score%22%3A41696%2C%22_orthography%22%3A%22perch%22%2C%22_conf%22%3A5950%2C%22_endTimeMs%22%3A4020%2C%22_beginTimeMs%22%3A3220%7D%5D%7D%2C%7B%22_score%22%3A342822%2C%22_startRule%22%3A%22whatthreewordsgrammar%23_main_%22%2C%22_conf%22%3A6402%2C%22_endTimeMs%22%3A6360%2C%22_beginTimeMs%22%3A1570%2C%22_lmScore%22%3A300%2C%22_items%22%3A%5B%7B%22_type%22%3A%22terminal%22%2C%22_score%22%3A34379%2C%22_orthography%22%3A%22tinge%22%2C%22_conf%22%3A6705%2C%22_endTimeMs%22%3A2250%2C%22_beginTimeMs%22%3A1580%7D%2C%7B%22_type%22%3A%22terminal%22%2C%22_score%22%3A47670%2C%22_orthography%22%3A%22artichokes%22%2C%22_conf%22%3A7176%2C%22_endTimeMs%22%3A3180%2C%22_beginTimeMs%22%3A2260%7D%2C%7B%22_type%22%3A%22terminal%22%2C%22_score%22%3A41696%2C%22_orthography%22%3A%22perch%22%2C%22_conf%22%3A5950%2C%22_endTimeMs%22%3A4020%2C%22_beginTimeMs%22%3A3220%7D%5D%7D%5D%2C%22_resultType%22%3A%22NBest%22%7D";

    NSArray *parameters = @[
      [AutoSuggestOption inputType:VOCONHYBRID],
      [AutoSuggestOption numberResults:3],
      [AutoSuggestOption fallBackLanguage:@"en"],
      [AutoSuggestOption focus:CLLocationCoordinate2DMake(51.4243877, -0.3474524)]
      ];

    [api autosuggest:voice_data.stringByRemovingPercentEncoding parameters:parameters completion:^(NSArray *suggestions, W3wError *error)
      {
      XCTAssertNil(error);

      if (suggestions.count > 0)
        {
        W3wSuggestion *first_match = suggestions[0];
        NSString *expected_result = @"tend.artichokes.perch";

        XCTAssertTrue([first_match.words isEqualToString:expected_result]);
        }

      XCTAssertTrue(suggestions.count == 3);

      [expectation fulfill];
      }];

    [self waitForExpectationsWithTimeout:3.0 handler:nil];
    }



-(void)testAutoSuggestGenericVoice {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Auto Suggest"];

  [api autosuggest:@"filled count soap" parameters:@[ [AutoSuggestOption inputType:GENERIC_VOICE], [AutoSuggestOption fallBackLanguage:@"en"] ] completion:^(NSArray *suggestions, W3wError *error)
   {
     XCTAssertNil(error);
     
     if (suggestions.count > 0)
     {
       W3wSuggestion *first_match = suggestions[0];
       NSString *expected_result = @"filled.count.soap";
       
       XCTAssertTrue([first_match.words isEqualToString:expected_result]);
     }
     
     XCTAssertTrue(suggestions.count == 3);
     
     [expectation fulfill];
   }];
  
  [self waitForExpectationsWithTimeout:3.0 handler:nil];
}





-(void)testAutoSuggestBoundingBox {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Auto Suggest"];

    [api autosuggest:@"thing.thing.thing" parameter:[AutoSuggestOption clipToBoundingBox:51.521 west_lng:-0.323 north_lat:52.6 east_lng:2.3324] completion:^(NSArray *suggestions, W3wError *error)
      {
      XCTAssertNil(error);

      if (suggestions.count > 0)
        {
        W3wSuggestion *first_match = suggestions[0];
        NSString *expected_result = @"things.thinks.thing";

        XCTAssertTrue([first_match.words isEqualToString:expected_result]);
        }

      XCTAssertTrue(suggestions.count == 3);

      [expectation fulfill];
      }];

    [self waitForExpectationsWithTimeout:3.0 handler:nil];
    }


-(void)testAutoSuggestPreferLand {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Auto Suggest"];
  
  [api autosuggest:@"bisect.nourishment.genuineness" parameter:[AutoSuggestOption preferLand:false] completion:^(NSArray *suggestions, W3wError *error)
   {
     XCTAssertNil(error);
     
     if (suggestions.count > 2)
     {
       W3wSuggestion *first_match = suggestions[0];
       NSString *expected_result = @"ZZ";
       
       XCTAssertTrue([first_match.country isEqualToString:expected_result]);
     }
     
     XCTAssertTrue(suggestions.count == 3);
     
     [expectation fulfill];
   }];
  
  [self waitForExpectationsWithTimeout:3.0 handler:nil];
}




-(void)testAutoSuggestPolygon {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Auto Suggest"];

    NSArray *polygon = @[
      [[CLLocation alloc] initWithLatitude:51.0 longitude:0.0],
      [[CLLocation alloc] initWithLatitude:51.0 longitude:0.1],
      [[CLLocation alloc] initWithLatitude:51.1 longitude:0.1],
      [[CLLocation alloc] initWithLatitude:51.1 longitude:0.0],
      [[CLLocation alloc] initWithLatitude:51.0 longitude:0.0],
    ];

    [api autosuggest:@"scenes.irritated.sparkle" parameter:[AutoSuggestOption clipToPolygon:polygon] completion:^(NSArray *suggestions, W3wError *error)
      {
      XCTAssertNil(error);

      if (suggestions.count > 0)
        {
        W3wSuggestion *first_match = suggestions[0];
        NSString *expected_result = @"scenes.irritated.sparkles";

        XCTAssertTrue([first_match.words isEqualToString:expected_result]);
        }

      [expectation fulfill];
      }];

    [self waitForExpectationsWithTimeout:3.0 handler:nil];
    }



-(void)testAutoSuggestBoundingCircle {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Auto Suggest"];

    [api autosuggest:@"mitiger.tarir.prolong" parameter:[AutoSuggestOption clipToCircle:CLLocationCoordinate2DMake(51.521238, -0.203607) radius:1.0] completion:^(NSArray *suggestions, W3wError *error)
      {
      XCTAssertNil(error);

      if (suggestions.count > 0)
        {
        W3wSuggestion *first_match = suggestions[0];
        NSString *expected_result = @"mitiger.tarir.prolonger";

        XCTAssertTrue([first_match.words isEqualToString:expected_result]);
        }

      [expectation fulfill];
      }];

    [self waitForExpectationsWithTimeout:3.0 handler:nil];
    }


-(void)testAutoSuggestFocus {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Auto Suggest"];

    [api autosuggest:@"geschaft.planter.carciofi" parameter:[AutoSuggestOption focus:CLLocationCoordinate2DMake(51.4243877, -0.34745)] completion:^(NSArray *suggestions, W3wError *error)
      {
      XCTAssertNil(error);

      if (suggestions.count > 0)
        {
        W3wSuggestion *first_match = suggestions[0];
        NSString *expected_result = @"restate.piante.carciofo";

        XCTAssertTrue([first_match.words isEqualToString:expected_result]);
        }

      [expectation fulfill];
      }];

    [self waitForExpectationsWithTimeout:3.0 handler:nil];
    }



-(void)testAutoSuggestFocusNumberResults {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Auto Suggest"];

    NSArray *parameters = @[
      [AutoSuggestOption focus:CLLocationCoordinate2DMake(51.4243877, -0.34745)],
      [AutoSuggestOption numberResults:6],
      [AutoSuggestOption numberFocusResults:1]
      ];

    [api autosuggest:@"geschaft.planter.carciofi" parameters:parameters completion:^(NSArray *suggestions, W3wError *error)
      {
      XCTAssertNil(error);

      if (suggestions.count > 2)
        {
        W3wSuggestion *first_match = suggestions[0];
        NSString *expected_result = @"restate.piante.carciofo";
        XCTAssertTrue([first_match.words isEqualToString:expected_result]);
        XCTAssertLessThan([first_match.distanceToFocusKm integerValue], 100);

        W3wSuggestion *third_match = suggestions[2];
        XCTAssertGreaterThan([third_match.distanceToFocusKm integerValue], 100);
        }

      [expectation fulfill];
      }];

    [self waitForExpectationsWithTimeout:3.0 handler:nil];
    }



-(void)testAutoSuggestNumberResults {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Auto Suggest"];

    [api autosuggest:@"poi.poi.poi" parameter:[AutoSuggestOption numberResults:10] completion:^(NSArray *suggestions, W3wError *error)
      {
      XCTAssertNil(error);
      XCTAssertTrue(suggestions.count == 10);
      [expectation fulfill];
      }];

    [self waitForExpectationsWithTimeout:3.0 handler:nil];
    }



-(void)testAutoSuggestFallbackLanguage {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Auto Suggest"];

    [api autosuggest:@"aaa.aaa.aaa" parameter:[AutoSuggestOption fallBackLanguage:@"de"] completion:^(NSArray *suggestions, W3wError *error)
      {
      XCTAssertNil(error);

      if (suggestions.count > 0)
        {
        W3wSuggestion *first_match = suggestions[0];
        NSString *expected_result = @"saal.saal.saal";

        XCTAssertTrue([first_match.words isEqualToString:expected_result]);
        }

      [expectation fulfill];
      }];

    [self waitForExpectationsWithTimeout:3.0 handler:nil];
    }





-(void)testBadWords {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Convert to Coords"];
  
    NSString *words = @"aaa.bbb.ccc";
  
    [api convertToCoordinates:words format:JSON completion:^(W3wPlace *place, W3wError *error)
      {
      XCTAssertTrue([error.code isEqualToString:@"BadWords"]);
      [expectation fulfill];
      }];

    [self waitForExpectationsWithTimeout:3.0 handler:nil];
    }






- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
