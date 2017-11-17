#import "ABCDThreadedService.h"
#import "ABCDThreadedService+Private.h"
#import "ABCDService+Private.h"

@implementation ABCDThreadedService
- (BOOL)shouldFinish {
    return [self.thread isCancelled];
}

- (void)private_start {
    _thread = [[NSThread alloc] initWithTarget:self selector:@selector(start) object:nil];
    [_thread start];
}

- (void)private_finish {
    [self.thread cancel];
}

- (void)restart {
    if ([self.thread isFinished]) {
        [self private_start];
    }
}

- (void)private_setThread:(NSThread *)thread {
    _thread = thread;
}
@end
