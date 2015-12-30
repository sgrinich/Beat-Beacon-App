//
//  Trial.h
//  Beats By Ken
//
//  Created by Stephen on 3/22/15.
//  Copyright (c) 2015 Stephen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Trial : NSObject

@property (nonatomic,strong) NSString *startTime;
@property (nonatomic,strong) NSString *endTime;
@property (nonatomic, strong) NSString *trialNumber;
@property (nonatomic, strong) NSString *beatCount;
@property (nonatomic, strong) NSString *session;
@property (nonatomic, strong) NSString *participantID;


- (id) initWithStartTime:(NSString *) startTime EndTime:(NSString *) endTime TrialNumber:(NSString *) trialNumber BeatCount:(NSString *) beatCount SessionNumber:(NSString *) session ParticipantID:(NSString *) participantID;


@end
