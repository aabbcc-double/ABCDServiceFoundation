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

#import "FizzBuzzPrinter.h"
#import "FizzBuzzDetector.h"

@interface FizzBuzzPrinter() {
    RACScopedDisposable *_disposable;
    NSLock *_arrayLock;
    NSMutableArray *_stringsToPrint;
}
@end

@implementation FizzBuzzPrinter
- (instancetype)init {
    return [self initWithIdentifier:@"com.aabbccdouble.FizzBuzzPrinter"];
}

- (instancetype)initWithIdentifier:(NSString *)identifier {
    self = [super initWithIdentifier:identifier];
    if (self) {
        _disposable = nil;
        _arrayLock = [[NSLock alloc] init];
        _stringsToPrint = [NSMutableArray array];
    }
    return self;
}

- (void)start {
    [super start];
    
    for (;;) {
        if (self.shouldFinish) {
            break;
        }
        
        if (_disposable == nil) {
            FizzBuzzDetector *detector = (FizzBuzzDetector *)[self.serviceManager firstServiceWithIdentifier:[FizzBuzzDetector defaultIdentifier]];
            if (detector != nil) {
                _disposable = [[detector.detectedNumbers subscribeNext:^(FizzBuzzModel *model) {
                    if (model.type != FizzBuzzTypeNone) {
                        NSMutableString *fizzBuzzString = [NSMutableString string];
                        if ((model.type & FizzBuzzTypeFizz) == FizzBuzzTypeFizz) {
                            [fizzBuzzString appendString:@"Fizz"];
                        }
                        
                        if ((model.type & FizzBuzzTypeBuzz) == FizzBuzzTypeBuzz) {
                            [fizzBuzzString appendString:@"Buzz"];
                        }
                        
                        [fizzBuzzString appendFormat:@" - %lu", model.integer];
                        [_arrayLock lock];
                        [_stringsToPrint addObject:fizzBuzzString];
                        [_arrayLock unlock];
                    }
                } completed:^{
                    _disposable = nil;
                }] asScopedDisposable];
            }
        }
        
        [_arrayLock lock];
        for (NSString *str in _stringsToPrint) {
            NSLog(@"%@", str);
        }
        [_stringsToPrint removeAllObjects];
        [_arrayLock unlock];
    }
}
@end
