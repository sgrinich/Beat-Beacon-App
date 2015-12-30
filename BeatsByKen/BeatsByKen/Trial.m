//
//  Trial.m
//  Beats By Ken
//
//  Created by Stephen on 3/22/15.
//  Copyright (c) 2015 Stephen. All rights reserved.
//

#import "Trial.h"

@implementation Trial
@synthesize startTime;
@synthesize endTime;
@synthesize trialNumber;
@synthesize beatCount;
@synthesize session;
@synthesize participantID;


- (id)init {
    self = [super init];
    if (self) {
        // initialization happens here.
    }
    return self;
}

- (id) initWithStartTime:(NSString *) startTime EndTime:(NSString *) endTime TrialNumber:(NSString *) trialNumber BeatCount:(NSString *) beatCount SessionNumber:(NSString *) session ParticipantID:(NSString *)participantID{
    
    self = [super init];
    if (self) {
        self.startTime = startTime;
        self.endTime = endTime;
        self.trialNumber = trialNumber;
        self.beatCount = beatCount;
        self.session = session;
        self.participantID = participantID;
    }
    
    return self;
}



@end
