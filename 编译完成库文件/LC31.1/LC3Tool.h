//
//  LC3Tool.h
//  SoundRecorder
//
//  Created by RIDCYC000 on 2023/11/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LC3Tool : NSObject
- (NSData *)encode:(NSData *)data output_byte_count:(int)output_byte_count;
- (NSData *)decode:(NSData *)data output_byte_count:(int)output_byte_count;
@end

NS_ASSUME_NONNULL_END
