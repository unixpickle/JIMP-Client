//
//  OOTObject.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANByteBuffer.h"

@interface OOTObject : NSObject {
	NSString * className;
	NSData * classData;
}

/**
 * Create a copy of an object.
 * @param object	The object that we are copying.
 * @return	A freshly allocated OOTObject containing a copy of another object.
 */
- (id)initWithObject:(OOTObject *)object;

/**
 * Create an object using some bytes in a byte buffer.
 * @param buffer  The buffer of which we will get our data from.
 * @throws BufferUnderflowException  Thrown when the buffer doesn't have enough free bytes.
 * @return A freshly allocated OOTObject containing some data from the buffer.
 */
- (id)initWithByteBuffer:(ANByteBuffer *)buffer;

/**
 * Create an object using the data of an encoded object.
 * @param data  The data of which to parse for our object.
 * @throws BufferUnderflowException  Thrown when the data is too small for the object.
 * @return A freshly allocated OOTObject that was decoded from the data.
 */
- (id)initWithData:(NSData *)data;

/**
 * Create an object by parsing a header, and reading the rest
 * of the object's data from a file descriptor.
 * @param header  The data of the header of which to parse (should be 12 bytes).
 * @param fileDescriptor  The open file descriptor from which we
 * will read the object's data.
 * @throws BufferUnderflowException  If the header specified is not 12 bytes.
 * @return A freshly allocated OOTObject containing the data read from the
 * file descriptor.
 */
- (id)initWithHeader:(NSData *)header fromSocket:(int)fileDescriptor;

/**
 * Create an object using a class name, and class data.
 * @param _className  The four-character name for the class
 * @param _classData  The data for the object to contain.
 * @throws ClassNameLengthException  Thrown when the class name is not four bytes.
 * @return A freshly allocated OOTObject containing the data (a copy),
 * and the class name (copied as well).
 */
- (id)initWithName:(NSString *)_className data:(NSData *)_classData;

+ (OOTObject *)objectWithName:(NSString *)_className data:(NSData *)_classData;

- (NSString *)className;
- (NSData *)classData;

/**
 * Encode an object for sending over a socket.
 * @return The data of the encoded object, including
 * the header and class data.
 */
- (NSData *)encodeClass;

@end
