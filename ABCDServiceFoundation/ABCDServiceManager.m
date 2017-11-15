#import "ABCDServiceManager.h"
#import "ABCDService+Private.h"

@implementation ABCDServiceManager {
    NSMutableArray<ABCDService *> *_runningServices;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _runningServices = [NSMutableArray array];
    }
    return self;
}

- (ABCDService *)firstServiceWithIdentifier:(NSString *)identifier {
    for (ABCDService *service in self.runningServices) {
        if ([identifier isEqualToString:service.identifier]) {
            return service;
        }
    }
    
    return nil;
}

- (NSArray<ABCDService *> *)servicesWithIdentifier:(NSString *)identifier {
    NSMutableArray *array = [NSMutableArray array];
    [self.runningServices enumerateObjectsUsingBlock:^(ABCDService * _Nonnull service, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([identifier isEqualToString:service.identifier]) {
            [array addObject:service];
        }
    }];
    
    return array;
}

- (void)startService:(ABCDService *)service {
    [_runningServices addObject:service];
    
    NSThread *thread = [[NSThread alloc] initWithTarget:service selector:@selector(start) object:nil];
    [service private_setCurrentThread:thread];
    [service private_setServiceManager:self];
    [thread start];
}

- (void)finishService:(ABCDService *)service {
    [service performSelectorOnMainThread:@selector(private_finish) withObject:nil waitUntilDone:NO];
    
    [_runningServices removeObject:service];
}
@end
