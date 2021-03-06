/*
 Copyright 2017-present the Material Components for iOS authors. All Rights Reserved.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import <XCTest/XCTest.h>
#import "MaterialDialogs.h"

#import "MDCAlertControllerView+Private.h"

#pragma mark - Subclasses for testing

static NSString *const MDCAlertControllerSubclassValueKey = @"MDCAlertControllerSubclassValueKey";

@interface MDCAlertControllerSubclass : MDCAlertController
@property(nonatomic, assign) NSInteger value;
@end

@implementation MDCAlertControllerSubclass

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    _value = [aDecoder decodeIntegerForKey:MDCAlertControllerSubclassValueKey];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
  [super encodeWithCoder:aCoder];
  [aCoder encodeInteger:self.value forKey:MDCAlertControllerSubclassValueKey];
}

@end

#pragma mark - Tests

@interface MDCAlertControllerTests : XCTestCase

@end

@implementation MDCAlertControllerTests

- (void)testInit {
  // Given
  MDCAlertController *alert = [[MDCAlertController alloc] init];

  // Then
  XCTAssertNotNil(alert.actions);
  XCTAssertNil(alert.title);
  XCTAssertNil(alert.message);
}

- (void)testAlertControllerWithTitleMessage {
  // Given
  MDCAlertController *alert = [MDCAlertController alertControllerWithTitle:@"title"
                                                                   message:@"message"];

  // Then
  XCTAssertNotNil(alert.actions);
  XCTAssertEqualObjects(alert.title, @"title");
  XCTAssertEqualObjects(alert.message, @"message");
}

- (void)testSubclassEncodingFails {
  // Given
  MDCAlertControllerSubclass *subclass = [[MDCAlertControllerSubclass alloc] init];
  subclass.value = 7;
  subclass.title = @"title";
  subclass.message = @"message";
  subclass.modalInPopover = YES;

  // When
  NSData *archive = [NSKeyedArchiver archivedDataWithRootObject:subclass];
  MDCAlertControllerSubclass *unarchivedSubclass =
      [NSKeyedUnarchiver unarchiveObjectWithData:archive];

  // Then
  XCTAssertEqual(unarchivedSubclass.value, subclass.value);
  XCTAssertNil(unarchivedSubclass.title);
  XCTAssertNil(unarchivedSubclass.message);
  XCTAssertEqual(unarchivedSubclass.isModalInPopover, NO);
}

- (void)testAlertControllerTyphography {
  MDCAlertController *alert = [MDCAlertController alertControllerWithTitle:@"title"
                                                                   message:@"message"];
  UIFont *testFont = [UIFont boldSystemFontOfSize:30];
  alert.titleFont = testFont;
  alert.messageFont = testFont;
  alert.buttonFont = testFont;

  MDCAlertControllerView *view = (MDCAlertControllerView *)alert.view;
  XCTAssertEqual(view.titleLabel.font, testFont);
  XCTAssertEqual(view.messageLabel.font, testFont);
  for (UIButton *button in view.actionButtons) {
    XCTAssertEqual(button.titleLabel.font, testFont);
  }
}

- (void)testAlertControllerColorSetting {
  MDCAlertController *alert = [MDCAlertController alertControllerWithTitle:@"title"
                                                                   message:@"message"];
  UIColor *testColor = [UIColor redColor];
  alert.titleColor = testColor;
  alert.messageColor = testColor;
  alert.buttonTitleColor = testColor;

  MDCAlertControllerView *view = (MDCAlertControllerView *)alert.view;
  XCTAssertEqual(view.titleLabel.textColor, testColor);
  XCTAssertEqual(view.messageLabel.textColor, testColor);
  for (UIButton *button in view.actionButtons) {
    XCTAssertEqual([button titleColorForState:UIControlStateNormal], testColor);
  }
}

- (void)testAlertControllerSettingTitleAndMessage {
  NSString *title = @"title";
  NSString *message = @"message";
  MDCAlertController *alert = [MDCAlertController alertControllerWithTitle:title
                                                                   message:message];
  alert.titleFont = [UIFont systemFontOfSize:25];

  MDCAlertControllerView *view = (MDCAlertControllerView *)alert.view;
  XCTAssertEqual(view.titleLabel.text, title);
  XCTAssertEqual(view.messageLabel.text, message);
}

@end
