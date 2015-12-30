//
//  beatCounter.m
//  BeatsByKen
//
/*Copyright (c) 2015 Aidan Carroll, Alex Calamaro, Max Willard, Liz Shank
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

#import <Foundation/Foundation.h>
#import "beatCounter.h"

@import CoreBluetooth;
@import QuartzCore;


@implementation beatCounter
int rrCount;
int bpm;

- (void) resetRRCount {
    rrCount = 0;
}

- (int) getRRCount {
    return rrCount;
}


// Instance method to get the heart rate BPM information
- (int) getBPM:(CBCharacteristic *)characteristic error:(NSError *)error
{
    // Get the BPM //
    // https://developer.bluetooth.org/gatt/characteristics/Pages/CharacteristicViewer.aspx?u=org.bluetooth.characteristic.heart_rate_measurement.xml //
    
    // Convert the contents of the characteristic value to a data-object //
    NSData *data = [characteristic value];
    
    // Get the byte sequence of the data-object //
    const uint8_t *reportData = [data bytes];
    
    // Initialise the offset variable //
    NSUInteger offset = 1;
    // Initialise the bpm variable //
    int bpm = 0;
    
    
    // Next, obtain the first byte at index 0 in the array as defined by reportData[0] and mask out all but the 1st bit //
    // The result returned will either be 0, which means that the 2nd bit is not set, or 1 if it is set //
    // If the 2nd bit is not set, retrieve the BPM value at the second byte location at index 1 in the array //
    if ((reportData[0] & 0x01) == 0) {
        // Retrieve the BPM value for the Heart Rate Monitor
        bpm = reportData[1];
        
        offset = offset + 1; // Plus 1 byte //
    }
    else {
        // If the second bit is set, retrieve the BPM value at second byte location at index 1 in the array and //
        // convert this to a 16-bit value based on the host’s native byte order //
        bpm = CFSwapInt16LittleToHost(*(uint16_t *)(&reportData[1]));
        
        offset =  offset + 2; // Plus 2 bytes //
    }
    
    return bpm;
    
}


// Instance method to get the heart rate BPM information
- (void) getHeartBPMData:(CBCharacteristic *)characteristic error:(NSError *)error
{
    // Get the BPM //
    // https://developer.bluetooth.org/gatt/characteristics/Pages/CharacteristicViewer.aspx?u=org.bluetooth.characteristic.heart_rate_measurement.xml //
    
    // Convert the contents of the characteristic value to a data-object //
    NSData *data = [characteristic value];
    
    // Get the byte sequence of the data-object //
    const uint8_t *reportData = [data bytes];
    
    // Initialise the offset variable //
    NSUInteger offset = 1;
    // Initialise the bpm variable //
    uint16_t bpm = 0;
    
    
    // Next, obtain the first byte at index 0 in the array as defined by reportData[0] and mask out all but the 1st bit //
    // The result returned will either be 0, which means that the 2nd bit is not set, or 1 if it is set //
    // If the 2nd bit is not set, retrieve the BPM value at the second byte location at index 1 in the array //
    if ((reportData[0] & 0x01) == 0) {
        // Retrieve the BPM value for the Heart Rate Monitor
        bpm = reportData[1];
        
        offset = offset + 1; // Plus 1 byte //
    }
    else {
        // If the second bit is set, retrieve the BPM value at second byte location at index 1 in the array and //
        // convert this to a 16-bit value based on the host’s native byte order //
        bpm = CFSwapInt16LittleToHost(*(uint16_t *)(&reportData[1]));
        
        offset =  offset + 2; // Plus 2 bytes //
    }
    
    
    
    // Determine if EE data is present //
    // If the 3rd bit of the first byte is 1 this means there is EE data //
    // If so, increase offset with 2 bytes //
    if ((reportData[0] & 0x03) == 1) {
        offset =  offset + 2; // Plus 2 bytes //
    }
    
    
    
    // Determine if RR-interval data is present //
    // If the 4th bit of the first byte is 1 this means there is RR data //
    if ((reportData[0] & 0x04) == 0)
    {
        NSLog(@"%@", @"Data are not present");
    }
    else
    {
        // The number of RR-interval values is total bytes left / 2 (size of uint16) //
        
        NSUInteger length = [data length];
        NSUInteger count = (length - offset)/2;
        //NSLog(@"RR count: %lu", (unsigned long)count);
        
        for (int i = 0; i < count; i++) {
            
            // The unit for RR interval is 1/1024 seconds //
            uint16_t value = CFSwapInt16LittleToHost(*(uint16_t *)(&reportData[offset]));
            value = ((double)value / 1024.0 ) * 1000.0;
            
            
            offset = offset + 2; // Plus 2 bytes //
            rrCount++;
            
            //NSLog(@"RR value %lu: %u", (unsigned long)i, value);
            //NSLog(@"RR count: %i", (int)rrCount);
            
        }
        
    }
    
}

@end

