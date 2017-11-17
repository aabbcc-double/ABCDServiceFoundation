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
            FizzBuzzDetector *detector = [self.serviceManager firstServiceWithIdentifier:[FizzBuzzDetector defaultIdentifier]];
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
