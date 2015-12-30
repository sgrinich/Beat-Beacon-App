//
//  CSVController.h
//  Beats By Ken
//
//  Created by Stephen on 3/22/15.
//  Copyright (c) 2015 Stephen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSVController_old : UIViewController{
    NSString *participantFileName;
    NSString *sessionFileName;
}

@property (nonatomic,strong) NSString *csvString;
@property (nonatomic,strong) NSMutableArray *trialArray; 

@end
