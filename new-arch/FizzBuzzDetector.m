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
    
    [self finish];
    [_detectedNumbers sendCompleted];
}
@end
