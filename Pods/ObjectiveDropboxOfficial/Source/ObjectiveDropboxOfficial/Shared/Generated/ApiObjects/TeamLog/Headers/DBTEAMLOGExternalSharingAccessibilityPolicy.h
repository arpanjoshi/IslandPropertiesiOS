///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"

@class DBTEAMLOGExternalSharingAccessibilityPolicy;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - API Object

///
/// The `ExternalSharingAccessibilityPolicy` union.
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBTEAMLOGExternalSharingAccessibilityPolicy : NSObject <DBSerializable, NSCopying>

#pragma mark - Instance fields

/// The `DBTEAMLOGExternalSharingAccessibilityPolicyTag` enum type represents
/// the possible tag states with which the
/// `DBTEAMLOGExternalSharingAccessibilityPolicy` union can exist.
typedef NS_ENUM(NSInteger, DBTEAMLOGExternalSharingAccessibilityPolicyTag) {
  /// (no description).
  DBTEAMLOGExternalSharingAccessibilityPolicyTeamOnly,

  /// (no description).
  DBTEAMLOGExternalSharingAccessibilityPolicyDefaultTeamOnly,

  /// (no description).
  DBTEAMLOGExternalSharingAccessibilityPolicyDefaultAnyone,

  /// (no description).
  DBTEAMLOGExternalSharingAccessibilityPolicyOther,

};

/// Represents the union's current tag state.
@property (nonatomic, readonly) DBTEAMLOGExternalSharingAccessibilityPolicyTag tag;

#pragma mark - Constructors

///
/// Initializes union class with tag state of "team_only".
///
/// @return An initialized instance.
///
- (instancetype)initWithTeamOnly;

///
/// Initializes union class with tag state of "default_team_only".
///
/// @return An initialized instance.
///
- (instancetype)initWithDefaultTeamOnly;

///
/// Initializes union class with tag state of "default_anyone".
///
/// @return An initialized instance.
///
- (instancetype)initWithDefaultAnyone;

///
/// Initializes union class with tag state of "other".
///
/// @return An initialized instance.
///
- (instancetype)initWithOther;

- (instancetype)init NS_UNAVAILABLE;

#pragma mark - Tag state methods

///
/// Retrieves whether the union's current tag state has value "team_only".
///
/// @return Whether the union's current tag state has value "team_only".
///
- (BOOL)isTeamOnly;

///
/// Retrieves whether the union's current tag state has value
/// "default_team_only".
///
/// @return Whether the union's current tag state has value "default_team_only".
///
- (BOOL)isDefaultTeamOnly;

///
/// Retrieves whether the union's current tag state has value "default_anyone".
///
/// @return Whether the union's current tag state has value "default_anyone".
///
- (BOOL)isDefaultAnyone;

///
/// Retrieves whether the union's current tag state has value "other".
///
/// @return Whether the union's current tag state has value "other".
///
- (BOOL)isOther;

///
/// Retrieves string value of union's current tag state.
///
/// @return A human-readable string representing the union's current tag state.
///
- (NSString *)tagName;

@end

#pragma mark - Serializer Object

///
/// The serialization class for the
/// `DBTEAMLOGExternalSharingAccessibilityPolicy` union.
///
@interface DBTEAMLOGExternalSharingAccessibilityPolicySerializer : NSObject

///
/// Serializes `DBTEAMLOGExternalSharingAccessibilityPolicy` instances.
///
/// @param instance An instance of the
/// `DBTEAMLOGExternalSharingAccessibilityPolicy` API object.
///
/// @return A json-compatible dictionary representation of the
/// `DBTEAMLOGExternalSharingAccessibilityPolicy` API object.
///
+ (NSDictionary *)serialize:(DBTEAMLOGExternalSharingAccessibilityPolicy *)instance;

///
/// Deserializes `DBTEAMLOGExternalSharingAccessibilityPolicy` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBTEAMLOGExternalSharingAccessibilityPolicy` API object.
///
/// @return An instantiation of the
/// `DBTEAMLOGExternalSharingAccessibilityPolicy` object.
///
+ (DBTEAMLOGExternalSharingAccessibilityPolicy *)deserialize:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
