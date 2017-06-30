///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"

@class DBFILESSearchMatchType;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - API Object

///
/// The `SearchMatchType` union.
///
/// Indicates what type of match was found for a given item.
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBFILESSearchMatchType : NSObject <DBSerializable, NSCopying>

#pragma mark - Instance fields

/// The `DBFILESSearchMatchTypeTag` enum type represents the possible tag states
/// with which the `DBFILESSearchMatchType` union can exist.
typedef NS_ENUM(NSInteger, DBFILESSearchMatchTypeTag) {
  /// This item was matched on its file or folder name.
  DBFILESSearchMatchTypeFilename,

  /// This item was matched based on its file contents.
  DBFILESSearchMatchTypeContent,

  /// This item was matched based on both its contents and its file name.
  DBFILESSearchMatchTypeBoth,

};

/// Represents the union's current tag state.
@property (nonatomic, readonly) DBFILESSearchMatchTypeTag tag;

#pragma mark - Constructors

///
/// Initializes union class with tag state of "filename".
///
/// Description of the "filename" tag state: This item was matched on its file
/// or folder name.
///
/// @return An initialized instance.
///
- (instancetype)initWithFilename;

///
/// Initializes union class with tag state of "content".
///
/// Description of the "content" tag state: This item was matched based on its
/// file contents.
///
/// @return An initialized instance.
///
- (instancetype)initWithContent;

///
/// Initializes union class with tag state of "both".
///
/// Description of the "both" tag state: This item was matched based on both its
/// contents and its file name.
///
/// @return An initialized instance.
///
- (instancetype)initWithBoth;

- (instancetype)init NS_UNAVAILABLE;

#pragma mark - Tag state methods

///
/// Retrieves whether the union's current tag state has value "filename".
///
/// @return Whether the union's current tag state has value "filename".
///
- (BOOL)isFilename;

///
/// Retrieves whether the union's current tag state has value "content".
///
/// @return Whether the union's current tag state has value "content".
///
- (BOOL)isContent;

///
/// Retrieves whether the union's current tag state has value "both".
///
/// @return Whether the union's current tag state has value "both".
///
- (BOOL)isBoth;

///
/// Retrieves string value of union's current tag state.
///
/// @return A human-readable string representing the union's current tag state.
///
- (NSString *)tagName;

@end

#pragma mark - Serializer Object

///
/// The serialization class for the `DBFILESSearchMatchType` union.
///
@interface DBFILESSearchMatchTypeSerializer : NSObject

///
/// Serializes `DBFILESSearchMatchType` instances.
///
/// @param instance An instance of the `DBFILESSearchMatchType` API object.
///
/// @return A json-compatible dictionary representation of the
/// `DBFILESSearchMatchType` API object.
///
+ (NSDictionary *)serialize:(DBFILESSearchMatchType *)instance;

///
/// Deserializes `DBFILESSearchMatchType` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBFILESSearchMatchType` API object.
///
/// @return An instantiation of the `DBFILESSearchMatchType` object.
///
+ (DBFILESSearchMatchType *)deserialize:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
