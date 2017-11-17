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

#import "FizzBuzzDetector.h"

@implementation FizzBuzzModel
- (instancetype)initWithInteger:(NSUInteger)integer type:(FizzBuzzType)type {
    self = [super init];
    if (self) {
        _integer = integer;
        _type = type;
    }
    return self;
}
@end

@implementation FizzBuzzDetector {
    RACReplaySubject<FizzBuzzModel *> *_detectedNumbers;
}

+ (NSString *)defaultIdentifier {
    return @"com.aabbccdouble.FizzBuzzDetector";
}

- (instancetype)init {
    return [self initWithIdentifier:[FizzBuzzDetector defaultIdentifier]];
}

- (instancetype)initWithIdentifier:(NSString *)identifier {
    self = [super initWithIdentifier:identifier];
    if (self) {
        _detectedNumbers = [RACReplaySubject replaySubjectWithCapacity:1];
    }
    return self;
}

- (void)start {
    [super start];
    
    NSUInteger integer = 0;
    while (integer != NSUIntegerMax) {
        if (self.shouldFinish) {
            break;
        }
        
        BOOL isFizz = integer % 3 == 0;
        BOOL isBuzz = integer % 5 == 0;
        
        FizzBuzzType type = FizzBuzzTypeNone;
        if (isFizz) {
            type |= FizzBuzzTypeFizz;
        }
        
        if (isBuzz) {
            type |= FizzBuzzTypeBuzz;
        }
        
        FizzBuzzModel *fizzBuzz = [[FizzBuzzModel alloc] initWithInteger:integer type:type];
        [_detectedNumbers sendNext:fizzBuzz];
        
        integer++;
    }
    
    [_detectedNumbers sendCompleted];
}
@end
