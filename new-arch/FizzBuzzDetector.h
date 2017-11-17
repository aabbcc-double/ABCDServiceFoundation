#import <ABCDServiceFoundation/ABCDServiceFoundation.h>
#import <ReactiveObjC/ReactiveObjC.h>

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
