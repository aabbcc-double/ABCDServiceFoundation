#import "ViewController.h"
#import <ABCDServiceFoundation/ABCDServiceFoundation.h>

@interface CounterService: ABCDService
@property (nonatomic, readonly) NSUInteger currentInteger;
@end

@implementation CounterService
- (instancetype)init {
    return [self initWithIdentifier:@"com.aabbccdouble.counter-service"];
}

- (instancetype)initWithIdentifier:(NSString *)identifier {
    self = [super initWithIdentifier:identifier];
    if (self) {
        _currentInteger = 0;
    }
    return self;
}

- (void)start {
    for (;;) {
        if (self.shouldFinish) {
            break;
        }
        
        _currentInteger++;
        NSLog(@"CounterService: %lu", (unsigned long)self.currentInteger);
        
        if (self.currentInteger > 1000) {
            [self finish];
        }
    }
}
@end

@interface CheckService: ABCDService
@end

@implementation CheckService
- (void)start {
    for (;;) {
        if (self.shouldFinish) {
            break;
        }
        
        CounterService *service = (CounterService *)[self.serviceManager firstServiceWithIdentifier:@"com.aabbccdouble.counter-service"];
        if (service == nil) {
            [self finish];
        }
        
        if (service.currentInteger >= 10) {
            [service finish];
            [self finish];
        }
    }
}
@end

@interface ViewController ()
@property (nonatomic) ABCDServiceManager *serviceManager;
@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    ABCDServiceManager *serviceManager = [[ABCDServiceManager alloc] init];
    CounterService *countingService = [[CounterService alloc] init];
    CheckService *checkService = [[CheckService alloc] init];
    
    [serviceManager startService:countingService];
    [serviceManager startService:checkService];
    self.serviceManager = serviceManager;
}
@end
