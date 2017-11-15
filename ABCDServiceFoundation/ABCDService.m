#import "ABCDServiceManager.h"
#import "ABCDService.h"
#import "ABCDService+Private.h"

@implementation ABCDService
- (instancetype)init {
    return [self initWithIdentifier:nil];
}

- (instancetype)initWithIdentifier:(NSString *)identifier {
    self = [super init];
    if (self) {
        _identifier = identifier;
    }
    return self;
}

- (BOOL)shouldFinish {
    return [self.currentThread isCancelled];
}

- (void)private_setCurrentThread:(NSThread *)thread {
        _currentThread = thread;
}

- (void)private_setServiceManager:(ABCDServiceManager *)serviceManager {
    @synchronized(self) {
        _serviceManager = serviceManager;
    }
}

- (void)private_start {
    [self start];
}

- (void)private_finish {
    [self.currentThread cancel];
}

- (void)start {
    /* no op */
}

- (void)finish {
    [self.serviceManager finishService:self];
}
@end
