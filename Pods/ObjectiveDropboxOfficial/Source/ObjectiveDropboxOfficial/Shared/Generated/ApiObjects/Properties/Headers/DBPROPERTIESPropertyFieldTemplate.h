///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"

@class DBPROPERTIESPropertyFieldTemplate;
@class DBPROPERTIESPropertyType;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - API Object

///
/// The `PropertyFieldTemplate` struct.
///
/// Describe a single property field type which that can be part of a property
/// template.
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBPROPERTIESPropertyFieldTemplate : NSObject <DBSerializable, NSCopying>

#pragma mark - Instance fields

/// This is the name or key of a custom property in a property template. File
/// property names can be up to 256 bytes.
@property (nonatomic, readonly, copy) NSString *name;

/// This is the description for a custom property in a property template. File
/// property description can be up to 1024 bytes.
@property (nonatomic, readonly, copy) NSString *description_;

/// This is the data type of the value of this property. This type will be
/// enforced upon property creation and modifications.
@property (nonatomic, readonly) DBPROPERTIESPropertyType *type;

#pragma mark - Constructors

///
/// Full constructor for the struct (exposes all instance variables).
///
/// @param name This is the name or key of a custom property in a property
/// template. File property names can be up to 256 bytes.
/// @param description_ This is the description for a custom property in a
/// property template. File property description can be up to 1024 bytes.
/// @param type This is the data type of the value of this property. This type
/// will be enforced upon property creation and modifications.
///
/// @return An initialized instance.
///
- (instancetype)initWithName:(NSString *)name
                description_:(NSString *)description_
                        type:(DBPROPERTIESPropertyType *)type;

- (instancetype)init NS_UNAVAILABLE;

@end

#pragma mark - Serializer Object

///
/// The serialization class for the `PropertyFieldTemplate` struct.
///
@interface DBPROPERTIESPropertyFieldTemplateSerializer : NSObject

///
/// Serializes `DBPROPERTIESPropertyFieldTemplate` instances.
///
/// @param instance An instance of the `DBPROPERTIESPropertyFieldTemplate` API
/// object.
///
/// @return A json-compatible dictionary representation of the
/// `DBPROPERTIESPropertyFieldTemplate` API object.
///
+ (NSDictionary *)serialize:(DBPROPERTIESPropertyFieldTemplate *)instance;

///
/// Deserializes `DBPROPERTIESPropertyFieldTemplate` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBPROPERTIESPropertyFieldTemplate` API object.
///
/// @return An instantiation of the `DBPROPERTIESPropertyFieldTemplate` object.
///
+ (DBPROPERTIESPropertyFieldTemplate *)deserialize:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
