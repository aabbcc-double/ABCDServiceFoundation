/*
 MIT License
 
 Copyright (c) 2017 Shakhzod Ikromov (GRiMe2D) <aabbcc.double@gmail.com>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

#import "ABCDServiceManager.h"
#import "ABCDService+Private.h"
#import "ABCDThreadedService+Private.h"

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
    if ([_runningServices containsObject:service] == NO) {
        [_runningServices addObject:service];
    }
    [service private_setServiceManager:self];
    [service private_start];
}

- (void)finishService:(ABCDService *)service {
    if ([service isKindOfClass:[ABCDThreadedService class]]) {
        [service performSelectorOnMainThread:@selector(private_finish) withObject:nil waitUntilDone:NO];
    } else {
        [service performSelectorInBackground:@selector(private_finish) withObject:nil];
    }
    
    [_runningServices removeObject:service];
}

- (void)dealloc {
    NSArray *services = [_runningServices copy];
    
    for (ABCDService *service in services) {
        [self finishService:service];
    }
}
@end
