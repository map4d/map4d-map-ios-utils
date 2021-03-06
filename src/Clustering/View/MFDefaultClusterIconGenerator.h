#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "MFClusterIconGenerator.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * This class places clusters into range-based buckets of size to avoid having too many distinct
 * cluster icons. For example a small cluster of 1 to 9 items will have a icon with a text label
 * of 1 to 9. Whereas clusters with a size of 100 to 199 items will be placed in the 100+ bucket
 * and have the '100+' icon shown.
 * This caches already generated icons for performance reasons.
 */
@interface MFDefaultClusterIconGenerator : NSObject<MFClusterIconGenerator>

/**
 * Initializes the object with default buckets and auto generated background images.
 */
- (instancetype)init;

/**
 * Initializes the object with given |buckets| and auto generated background images.
 */
- (instancetype)initWithBuckets:(NSArray<NSNumber *> *)buckets;

/**
 * Initializes the class with a list of buckets and the corresponding background images.
 * The backgroundImages array should ideally be big enough to hold the cluster label.
 * Notes:
 * - |buckets| should be strictly increasing. For example: @[@10, @20, @100, @1000].
 * - |buckets| and |backgroundImages| must have equal non zero lengths.
 */
- (instancetype)initWithBuckets:(NSArray<NSNumber *> *)buckets
               backgroundImages:(NSArray<UIImage *> *)backgroundImages;

/**
 * Initializes the class with a list of buckets and the corresponding background colors.
 *
 * Notes:
 * - |buckets| should be strictly increasing. For example: @[@10, @20, @100, @1000].
 * - |buckets| and |backgroundColors| must have equal non zero lengths.
 */
- (instancetype)initWithBuckets:(NSArray<NSNumber *> *)buckets
               backgroundColors:(NSArray<UIColor *> *)backgroundColors;

/**
 * Generates an icon with the given size.
 */
- (UIImage *)iconForSize:(NSUInteger)size;

@end

NS_ASSUME_NONNULL_END

