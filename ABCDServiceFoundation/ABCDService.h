#import <Foundation/Foundation.h>
#import <ABCDServiceFoundation/ABCDServiceManager.h>

NS_ASSUME_NONNULL_BEGIN

@class ABCDServiceManager;
@interface ABCDService : NSObject
@property (nonatomic, readonly, nullable) NSString *identifier;
@property (nonatomic, readonly, nullable, weak) ABCDServiceManager *serviceManager;
@property (nonatomic, readonly) BOOL shouldFinish;
@property (nonatomic, readonly) NSThread *currentThread;

- (instancetype)init;
- (instancetype)initWithIdentifier:(nullable NSString *)identifier NS_DESIGNATED_INITIALIZER;

- (void)start;
- (void)finish;
@end

NS_ASSUME_NONNULL_END
