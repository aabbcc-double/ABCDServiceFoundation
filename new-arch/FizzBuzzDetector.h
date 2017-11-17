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

#import <ABCDServiceFoundation/ABCDServiceFoundation.h>
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"
#import <ReactiveObjC/ReactiveObjC.h>
#pragma clang diagnostic pop

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(char, FizzBuzzType) {
    FizzBuzzTypeNone = 1 << 0,
    FizzBuzzTypeFizz = 1 << 1,
    FizzBuzzTypeBuzz = 1 << 2
};

@interface FizzBuzzModel : NSObject
@property (readonly, nonatomic) NSUInteger integer;
@property (readonly, nonatomic) FizzBuzzType type;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithInteger:(NSUInteger)integer type:(FizzBuzzType)type NS_DESIGNATED_INITIALIZER;
@end

@interface FizzBuzzDetector : ABCDThreadedService
@property (nonatomic, readonly) RACSignal<FizzBuzzModel *> *detectedNumbers;

+ (NSString *)defaultIdentifier;
- (instancetype)init;
@end

NS_ASSUME_NONNULL_END
