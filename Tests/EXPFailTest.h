// Test case class without failWithException: method
@interface TestCaseClassWithoutFailMethod : NSObject
- (void)fail;


@end

// Test case class with failWithException: method
@interface TestCaseClassWithFailMethod : TestCaseClassWithoutFailMethod {
  NSException *_exception;
}

@property (nonatomic, retain) NSException *exception;
- (void)failWithException:(NSException *)exception;

@end

// Test case class with recordFailureWithDescription:inFile:atLine:expected: method
@interface TestCaseClassWithRecordFailureMethod : TestCaseClassWithoutFailMethod {
  NSString *_description;
  NSString *_fileName;
  NSUInteger _lineNumber;
  BOOL _expected;
}

@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *fileName;
@property (assign) NSUInteger lineNumber;
@property (assign) BOOL expected;

- (void)recordFailureWithDescription:(NSString *)description inFile:(NSString *)filename atLine:(NSUInteger)lineNumber expected:(BOOL)expected;

@end

// Test case class with recordIssue: method
@interface TestCaseClassWithRecordIssueMethod : TestCaseClassWithoutFailMethod {
  XCTIssue *_issue;
}

@property (nonatomic, strong) XCTIssue *issue;

- (void)recordIssue:(XCTIssue *)issue;

@end
