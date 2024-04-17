#import "TestHelper.h"
#import "EXPFailTest.h"

@interface EXPExpectFailTest : XCTestCase
@property (nonatomic, strong) XCTIssue *issue;
@property (assign) NSUInteger lineNumber;
@end

@implementation EXPExpectFailTest

// This test is dependent on the LOC with the failure on
static NSInteger EXPFailTestLine = 25;

- (void) recordIssue:(XCTIssue *)issue
{
  if (issue.sourceCodeContext.location.lineNumber != EXPFailTestLine) {
    [super recordIssue:issue];
  } else {
    self.issue = issue;
  }
}

- (void)test_ExpectFailToFail
{
  failure(@"Expect Fail to Fail");

  assertEquals(self.issue.type, XCTIssueTypeAssertionFailure);
  assertEqualObjects(self.issue.compactDescription, @"Expect Fail to Fail");
  assertNil(self.issue.detailedDescription);
  assertNil(self.issue.detailedDescription);
  assertNil(self.issue.associatedError);
  assertEquals(self.issue.attachments.count, 0);
  XCTSourceCodeContext *context = self.issue.sourceCodeContext;
  XCTSourceCodeLocation *location = context.location;
  assertTrue([location.fileURL.path hasSuffix:@"EXPFailTest.m"]);
  assertEquals(location.lineNumber, EXPFailTestLine);
}

@end

@implementation TestCaseClassWithoutFailMethod

- (void)fail {
  EXPFail(self, 777, "test.m", @"epic fail");
}

@end

@implementation TestCaseClassWithFailMethod
@synthesize exception=_exception;

- (void)dealloc {
  self.exception = nil;
  [super dealloc];
}

- (void)failWithException:(NSException *)exception {
  self.exception = exception;
}

@end

@implementation TestCaseClassWithRecordFailureMethod

@synthesize
  description=_description,
  fileName=_fileName,
  lineNumber=_lineNumber,
  expected=_expected;

- (void)dealloc {
  self.description = nil;
  self.fileName = nil;
  [super dealloc];
}

- (void)recordFailureWithDescription:(NSString *)description inFile:(NSString *)filename atLine:(NSUInteger)lineNumber expected:(BOOL)expected {
  self.description = description;
  self.fileName = filename;
  self.lineNumber = lineNumber;
  self.expected = expected;
}

@end

@implementation TestCaseClassWithRecordIssueMethod

@synthesize
  issue=_issue;

- (void)recordIssue:(XCTIssue *)issue
{
  self.issue = issue;
}

@end
    
@interface EXPFailTest : XCTestCase
@end

@implementation EXPFailTest

- (void)test_EXPFailWithTestCaseClassThatDoesNotHaveFailureMethod {
  // it throws the exception directly
  TestCaseClassWithoutFailMethod *testCase = [TestCaseClassWithoutFailMethod new];
  @try {
    [testCase fail];
  } @catch(NSException *exception) {
    assertEqualObjects([exception name], @"Expecta Error");
    assertEqualObjects([exception reason], @"test.m:777 epic fail");
  }
  [testCase release];
}

- (void)test_EXPFailWithTestCaseClassThatHasFailureMethod {
    // it calls recordFailureWithDescription:inFile:atLine:expected: method
  TestCaseClassWithRecordFailureMethod *testCase = [TestCaseClassWithRecordFailureMethod new];
  assertNil(testCase.description);
  assertNil(testCase.fileName);
  [testCase fail];
  assertEqualObjects(testCase.description, @"epic fail");
  assertEqualObjects(testCase.fileName, @"test.m");
  assertEqualObjects(@(testCase.lineNumber), @777);
  assertEquals(testCase.expected, NO);
  [testCase release];
}

- (void)test_EXPFailWithTestCaseClassThatHasRecordIssueMethod {
    // it calls recordIssue:
  TestCaseClassWithRecordIssueMethod *testCase = [TestCaseClassWithRecordIssueMethod new];
  assertNil(testCase.issue);
  [testCase fail];
  XCTIssue* issue = testCase.issue;
  assertEquals(issue.type, XCTIssueTypeAssertionFailure);
  assertEqualObjects(issue.compactDescription, @"epic fail");
  assertNil(issue.detailedDescription);
  assertNil(issue.associatedError);
  assertEquals(issue.attachments.count, 0);
  XCTSourceCodeContext *context = issue.sourceCodeContext;
  XCTSourceCodeLocation *location = context.location;
  assertTrue([location.fileURL.path hasSuffix:@"test.m"]);
  assertEquals(location.lineNumber, 777);
  [testCase release];
}

@end
