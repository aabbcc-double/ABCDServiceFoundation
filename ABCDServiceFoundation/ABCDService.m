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
#import "ABCDService.h"
#import "ABCDService+Private.h"

@implementation ABCDService {
    BOOL _shouldFinish;
}

- (instancetype)init {
    return [self initWithIdentifier:nil];
}

- (instancetype)initWithIdentifier:(NSString *)identifier {
    self = [super init];
    if (self) {
        _identifier = identifier;
        _shouldFinish = NO;
    }
    return self;
}

- (BOOL)shouldFinish {
    return _shouldFinish;
}

- (void)private_setServiceManager:(ABCDServiceManager *)serviceManager {
    _serviceManager = serviceManager;
}

- (void)private_start {
    [self start];
}

- (void)private_finish {
    _shouldFinish = YES;
}

- (void)start {
    /* no op */
}

- (void)finish {
    [self.serviceManager performSelectorOnMainThread:@selector(finishService:) withObject:self waitUntilDone:YES];
}
@end
