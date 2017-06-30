///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"

@class DBTEAMLOGMissingDetails;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - API Object

///
/// The `MissingDetails` struct.
///
/// An indication that an event was returned with missing details
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBTEAMLOGMissingDetails : NSObject <DBSerializable, NSCopying>

#pragma mark - Instance fields

#pragma mark - Constructors

///
/// Full constructor for the struct (exposes all instance variables).
///
/// @return An initialized instance.
///
- (instancetype)initDefault;

- (instancetype)init NS_UNAVAILABLE;

@end

#pragma mark - Serializer Object

///
/// The serialization class for the `MissingDetails` struct.
///
@interface DBTEAMLOGMissingDetailsSerializer : NSObject

///
/// Serializes `DBTEAMLOGMissingDetails` instances.
///
/// @param instance An instance of the `DBTEAMLOGMissingDetails` API object.
///
/// @return A json-compatible dictionary representation of the
/// `DBTEAMLOGMissingDetails` API object.
///
+ (NSDictionary *)serialize:(DBTEAMLOGMissingDetails *)instance;

///
/// Deserializes `DBTEAMLOGMissingDetails` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBTEAMLOGMissingDetails` API object.
///
/// @return An instantiation of the `DBTEAMLOGMissingDetails` object.
///
+ (DBTEAMLOGMissingDetails *)deserialize:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
