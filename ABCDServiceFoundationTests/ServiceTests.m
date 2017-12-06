#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>
#import "ABCDServiceManager.h"
#import "ABCDService.h"

@interface ServiceTests : XCTestCase
@end
@implementation ServiceTests
- (void)testRunning {
    ABCDServiceManager *serviceManager = [[ABCDServiceManager alloc] init];
    
    ABCDService *service = [[ABCDService alloc] init];
    [serviceManager startService:service];
    
    XCTAssertEqual(service.serviceManager, serviceManager);
    XCTAssertEqual(serviceManager.runningServices.count, 1);
    XCTestExpectation *ex = [self expectationWithDescription:@"Waiting"];
    [ex setInverted:YES];
    [self waitForExpectations:@[ex] timeout:1];
    XCTAssertEqual(service.serviceManager, serviceManager);
    XCTAssertEqual(serviceManager.runningServices.count, 1);
    
    [serviceManager startService:service];
    XCTAssertEqual(service.serviceManager, serviceManager);
    XCTAssertEqual(serviceManager.runningServices.count, 1);
    
    [service finish];
    XCTAssertNil(service.serviceManager);
    ex = [self expectationWithDescription:@"Waiting"];
    [ex setInverted:YES];
    [self waitForExpectations:@[ex] timeout:1];
    XCTAssertTrue(service.shouldFinish);
    XCTAssertEqual(serviceManager.runningServices.count, 0);
}
@end
