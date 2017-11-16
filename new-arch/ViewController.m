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
