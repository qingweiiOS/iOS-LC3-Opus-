//
//  LC3Tool.m
//  SoundRecorder
//
//  Created by RIDCYC000 on 2023/11/8.
//

#import "LC3Tool.h"
#import "lc3.h"
#import "AudioQueuePlay.h"

#define  dt_Us  10000
#define  sr_Hz  16000
//#define  output_byte_count 20

@implementation LC3Tool {
    lc3_encoder_t _encoder;
    const int16_t *PCMPtr;
    //编码器缓存
    void* encMem;
    void* decMem;
}


- (NSData *)decode:(NSData *) data output_byte_count:(int)output_byte_count {
    /*                      解码                           */
    //PCM格式
    enum lc3_pcm_format pcmFormat = LC3_PCM_FORMAT_S16;
    NSData *encodeData = data;
    
    //帧长10ms
    int dtUs = 10000;
    //采样率48K
    int srHz = 16000;
  
    //解码器需占用缓存大小
    unsigned decodeSize = lc3_decoder_size(dtUs, srHz);
    
    //单帧的采样数
    uint16_t sampleOfFrames = lc3_frame_samples(dtUs, srHz);
    //单帧字节数，一个采样占用两个字节
    uint16_t bytesOfFrames = sampleOfFrames*2;

    //输出帧缓冲
    unsigned char *outBuf = (unsigned char *)malloc(bytesOfFrames);
    //解码器缓存
    void* decMem = NULL;
    decMem = malloc(decodeSize);
    lc3_decoder_t lc3_decoder = lc3_setup_decoder(dtUs, srHz, 0, decMem);
    unsigned char *inBuf = (unsigned char *)malloc(output_byte_count);
    NSMutableData *decodeData = [NSMutableData data];
    NSUInteger encodeCount = encodeData.length;
    for (int i = 0; i < encodeCount; i+=output_byte_count) {
        NSUInteger len = encodeCount - i;
        if (len >= output_byte_count) {
            len = output_byte_count;
        } else {
            NSLog(@"----%lu",len);
        }
        
        NSData *data = [encodeData subdataWithRange:NSMakeRange(i, len)];
      
        //输入帧缓冲
        inBuf = (unsigned char *)data.bytes;
        
        lc3_decode(lc3_decoder, inBuf, output_byte_count, pcmFormat,outBuf, 1);
//        NSLog(@"%s",outBuf);
        [decodeData appendBytes:outBuf length:bytesOfFrames];
//
    }
    
    free(decMem);
  
    
    outBuf = NULL;
    
    return decodeData;
   
}

- (NSData *)encode:(NSData *)encodedata output_byte_count:(int)output_byte_count {
    //PCM格式
    enum lc3_pcm_format pcmFormat = LC3_PCM_FORMAT_S16;
    //帧长10ms
    int dtUs = 10000;
    //采样率48K
    int srHz = 16000;
    //编码器需占用缓存大小
    unsigned encodeSize = lc3_encoder_size(dtUs, srHz);
    //单帧的采样数
    uint16_t sampleOfFrames = lc3_frame_samples(dtUs, srHz);
    //单帧字节数，一个采样占用两个字节
    uint16_t bytesOfFrames = sampleOfFrames*2;
    //编码器缓存
    void* encMem = NULL;
  

    //输出帧缓冲
    unsigned char *outBuf = (unsigned char *)malloc(bytesOfFrames);
    encMem = malloc(encodeSize);
    /*                      编码                           */
    lc3_encoder_t lc3_encoder = lc3_setup_encoder(dtUs, srHz, 0, encMem);
   
    
  
    
    NSMutableData *encodeData = [NSMutableData data];
    
    
    NSUInteger count = encodedata.length;
    for (int i = 0; i < count; i+=bytesOfFrames) {
        NSUInteger len = count - i;
        if (len >= bytesOfFrames) {
            len = bytesOfFrames;
        }
        
        NSData * emptyAudioData = [encodedata subdataWithRange:NSMakeRange(i, len)];
        if (len < bytesOfFrames) { // 当数据长度不满足 添加空音数据
            NSMutableData *mData = [[NSMutableData alloc] initWithLength:bytesOfFrames];
            [mData replaceBytesInRange:NSMakeRange(0, emptyAudioData.length) withBytes:emptyAudioData.bytes];
            emptyAudioData = mData;
        }
        
        unsigned char *inBuf = (unsigned char *)malloc(bytesOfFrames);
        //输入帧缓冲
        inBuf = (unsigned char *)emptyAudioData.bytes;
        lc3_encode(lc3_encoder, pcmFormat, (const int16_t*)inBuf, 1,output_byte_count, outBuf);
        [encodeData appendBytes:outBuf length:output_byte_count];
       
    }
    free(outBuf);
    free(encMem);
    encMem = NULL;
  
    return  encodeData;
  
    
}

@end
