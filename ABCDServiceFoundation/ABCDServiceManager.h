#import <Foundation/Foundation.h>
#import <ABCDServiceFoundation/ABCDService.h>

NS_ASSUME_NONNULL_BEGIN

@interface ABCDServiceManager : NSObject
@property (nonatomic, readonly) NSArray<ABCDService *> *runningServices;

- (nullable ABCDService *)firstServiceWithIdentifier:(nullable NSString *)identifier;
- (nonnull NSArray<ABCDService *> *)servicesWithIdentifier:(nullable NSString *)identifier;

- (void)startService:(ABCDService *)service;
- (void)finishService:(ABCDService *)service;
@end

NS_ASSUME_NONNULL_END
