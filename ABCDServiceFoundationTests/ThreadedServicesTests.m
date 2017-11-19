#import <XCTest/XCTest.h>

#import "ABCDServiceManager.h"
#import "ABCDThreadedService.h"

#if !(BYPASS_THREAD_COUNT_TESTING)
#import <mach/mach_init.h>
#import <mach/thread_policy.h>
#import <mach/task.h>
#import <mach/vm_map.h>

/**
 * @return -1 on error, else the number of threads for the current process
 */
static int getThreadsCount()
{
    thread_array_t threadList;
    mach_msg_type_number_t threadCount;
    task_t task;
    
    kern_return_t kernReturn = task_for_pid(mach_task_self(), getpid(), &task);
    if (kernReturn != KERN_SUCCESS) {
        return -1;
    }
    
    kernReturn = task_threads(task, &threadList, &threadCount);
    if (kernReturn != KERN_SUCCESS) {
        return -1;
    }
    vm_deallocate (mach_task_self(), (vm_address_t)threadList, threadCount * sizeof(thread_act_t));
    
    return threadCount;
}
#endif

@interface LoopingService: ABCDThreadedService
@end

@implementation LoopingService
- (void)start {
    while (!self.shouldFinish) {
        /* no op */
    }
}
@end

@interface NoOpService: ABCDThreadedService
@end

@implementation NoOpService
- (void)start {
    /* no op */
}
@end

@interface ABCDServiceFoundationTests : XCTestCase
@end

@implementation ABCDServiceFoundationTests
- (void)setUp {
    [super setUp];
}

- (void)testThreadedService {
    ABCDServiceManager *serviceManager = [[ABCDServiceManager alloc] init];
    
    LoopingService *loopingService = [[LoopingService alloc] initWithIdentifier:nil];
#if !(BYPASS_THREAD_COUNT_TESTING)
    int initialThreadsCount = getThreadsCount();
    XCTAssertTrue(initialThreadsCount > 0);
#endif
    
    [serviceManager startService:loopingService];
#if !(BYPASS_THREAD_COUNT_TESTING)
    XCTAssertEqual(getThreadsCount(), initialThreadsCount + 1);
#endif
    
    [serviceManager finishService:loopingService];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Waiting for unrolling"];
    expectation.inverted = YES;
    [self waitForExpectations:@[expectation] timeout:2];
#if !(BYPASS_THREAD_COUNT_TESTING)
    XCTAssertEqual(getThreadsCount(), initialThreadsCount);
#endif
}

- (void)testDeallocFinishingServices {
    ABCDServiceManager *serviceManager = [[ABCDServiceManager alloc] init];
    
    LoopingService *loopingService = [[LoopingService alloc] initWithIdentifier:nil];
#if !(BYPASS_THREAD_COUNT_TESTING)
    int initialThreadsCount = getThreadsCount();
    XCTAssertTrue(initialThreadsCount > 0);
#endif
    
    [serviceManager startService:loopingService];
#if !(BYPASS_THREAD_COUNT_TESTING)
    XCTAssertEqual(getThreadsCount(), initialThreadsCount + 1);
#endif
    
    
    loopingService = [[LoopingService alloc] initWithIdentifier:nil];
    [serviceManager startService:loopingService];
#if !(BYPASS_THREAD_COUNT_TESTING)
    XCTAssertEqual(getThreadsCount(), initialThreadsCount + 2);
#endif

    XCTAssertEqual(serviceManager.runningServices.count, 2);
    
    [serviceManager startService:loopingService];
#if !(BYPASS_THREAD_COUNT_TESTING)
    XCTAssertEqual(getThreadsCount(), initialThreadsCount + 2);
#endif
    
    XCTAssertEqual(serviceManager.runningServices.count, 2);
    
    serviceManager = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"Waiting for unrolling"];
    expectation.inverted = YES;
    [self waitForExpectations:@[expectation] timeout:2];
#if !(BYPASS_THREAD_COUNT_TESTING)
    XCTAssertEqual(getThreadsCount(), initialThreadsCount);
#endif
}

- (void)testAutoExitingService {
    ABCDServiceManager *serviceManager = [[ABCDServiceManager alloc] init];
    
    NoOpService *noOpService = [[NoOpService alloc] init];
    XCTAssertEqual(noOpService.identifier, nil);
    
#if !(BYPASS_THREAD_COUNT_TESTING)
    int initialThreadsCount = getThreadsCount();
    XCTAssertTrue(initialThreadsCount > 0);
#endif

    [serviceManager startService:noOpService];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Waiting for unrolling"];
    expectation.inverted = YES;
    [self waitForExpectations:@[expectation] timeout:2];
#if !(BYPASS_THREAD_COUNT_TESTING)
    XCTAssertEqual(getThreadsCount(), initialThreadsCount);
#endif
    
    XCTAssertEqual(serviceManager.runningServices.count, 0);
}

- (void)tearDown {
    [super tearDown];
}
@end
