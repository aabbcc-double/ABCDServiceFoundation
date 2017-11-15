#import "ABCDService.h"

@interface ABCDService ()
- (void)private_setCurrentThread:(NSThread *)thread;
- (void)private_setServiceManager:(ABCDServiceManager *)serviceManager;

- (void)private_start;
- (void)private_finish;
@end
