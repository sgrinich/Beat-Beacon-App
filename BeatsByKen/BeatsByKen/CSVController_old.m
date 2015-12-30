//
//  CSVController.m
//  Beats By Ken
//
//  Created by Stephen on 3/22/15.
//  Copyright (c) 2015 Stephen. All rights reserved.
//

#import "CSVController_old.h"
#import "Trial.h"
//#import <DropboxSDK/DropboxSDK.h>

@interface CSVController_old () //<DBRestClientDelegate>
@property (weak, nonatomic) IBOutlet UITextView *csvTextView;
//@property (nonatomic, strong) DBRestClient *restClient;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *exportButton;

@end

@implementation CSVController_old
@synthesize csvString;
@synthesize trialArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([trialArray count]>1) {
        participantFileName= [[trialArray objectAtIndex:[trialArray count]-1] participantID];
        sessionFileName= [[trialArray objectAtIndex:[trialArray count]-1] session];

    }
    else{
        participantFileName = @"Test";
        sessionFileName = @"Test";
    }

    
    self.backButton.layer.cornerRadius = 15;
    self.exportButton.layer.cornerRadius = 15; 
    
    int numTrials = [trialArray count];
    
    int HEIGHT = 35;
    int WIDTH = 122;
    
    int PARTICIPANT_X = 18;
    int PARTICIPANT_Y = 29;
    
    int SESSION_X = 139;
    int SESSION_Y = 29;
    
    int TRIAL_X = 261;
    int TRIAL_Y = 29;
    
    int START_TIME_X = 383;
    int START_TIME_Y = 29;
    
    int END_TIME_X = 505;
    int END_TIME_Y = 29;
    
    int BEAT_COUNT_X = 627;
    int BEAT_COUNT_Y = 29;
    
    
    for (int i = 0; i < numTrials; i++)
    {
        UILabel *participantLabel =  [[UILabel alloc] initWithFrame: CGRectMake(PARTICIPANT_X, PARTICIPANT_Y * (i+2) + 5, WIDTH, HEIGHT)];
        UILabel *sessionLabel =  [[UILabel alloc] initWithFrame: CGRectMake(SESSION_X, SESSION_Y * (i+2) + 5, WIDTH, HEIGHT)];
        UILabel *trialLabel =  [[UILabel alloc] initWithFrame:  CGRectMake(TRIAL_X, TRIAL_Y* (i+2) + 5, WIDTH, HEIGHT)];
        UILabel *startTimeLabel =  [[UILabel alloc] initWithFrame:  CGRectMake(START_TIME_X, START_TIME_Y * (i+2) + 5, WIDTH, HEIGHT)];
        UILabel *endTimeLabel =  [[UILabel alloc] initWithFrame:  CGRectMake(END_TIME_X, END_TIME_Y * (i+2) + 5, WIDTH, HEIGHT)];
        UILabel *heartBeatLabel =  [[UILabel alloc] initWithFrame:  CGRectMake(BEAT_COUNT_X, BEAT_COUNT_Y * (i+2) + 5, WIDTH, HEIGHT)];
        
        participantLabel.text = [[trialArray objectAtIndex:i] participantID];
        [participantLabel setTextAlignment:NSTextAlignmentCenter];
        
        sessionLabel.text = [[trialArray objectAtIndex:i] session];
        [sessionLabel setTextAlignment:NSTextAlignmentCenter];

        trialLabel.text = [[trialArray objectAtIndex:i] trialNumber];
        [trialLabel setTextAlignment:NSTextAlignmentCenter];

        startTimeLabel.text = [[trialArray objectAtIndex:i] startTime];
        [startTimeLabel setTextAlignment:NSTextAlignmentCenter];

        endTimeLabel.text = [[trialArray objectAtIndex:i] endTime];
        [endTimeLabel setTextAlignment:NSTextAlignmentCenter];

        
        heartBeatLabel.text = [[trialArray objectAtIndex:i] beatCount];
        [heartBeatLabel setTextAlignment:NSTextAlignmentCenter];

        
        [self.view addSubview:participantLabel];
        [self.view addSubview:sessionLabel];
        [self.view addSubview:trialLabel];
        [self.view addSubview:startTimeLabel];
        [self.view addSubview:endTimeLabel];
        [self.view addSubview:heartBeatLabel];
    }

    //self.csvTextView.text = csvString;
}
//- (IBAction)exportButton:(id)sender {
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *docDirectory = [paths objectAtIndex:0];
//    
//    NSString *outputFileName = [docDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"%@,%@.csv",participantFileName, sessionFileName]];
//    
//    //Create an error incase something goes wrong
//    NSError *csvError = NULL;
//    
//    //We write the string to a file and assign it's return to a boolean
//    BOOL written = [csvString writeToFile:outputFileName atomically:YES encoding:NSUTF8StringEncoding error:&csvError];
//    
//    //If there was a problem saving we show the error if not show success and file path
//    if (!written)
//        NSLog(@"write failed, error=%@", csvError);
//    else
//        NSLog(@"Saved! File path = %@", outputFileName);
//    
//    
//    if (![[DBSession sharedSession] isLinked]) {
//        [[DBSession sharedSession] linkFromController:self];
//    }
//    
//    self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
//    self.restClient.delegate = self;
//    
//    NSString *destDir = @"/";
//    [self.restClient uploadFile:[NSString stringWithFormat:@"%@,%@.csv",participantFileName, sessionFileName] toPath:destDir withParentRev:nil fromPath:outputFileName];
//    
//  //  NSLog(@"outputFileName: %@", outputFileName);
//   // NSLog(@"file to upload: %@", [NSString stringWithFormat:@"%@,%@.csv",participantFileName, sessionFileName]);
//    
//}

//- (void)restClient:(DBRestClient *)client uploadedFile:(NSString *)destPath
//              from:(NSString *)srcPath metadata:(DBMetadata *)metadata {
//    NSLog(@"File uploaded successfully to path: %@", metadata.path);
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Uploaded to your Dropbox"
//                                                       message: @"This session's CSV file has successfully been uploaded to your Dropbox account."
//                                                      delegate: self
//                                             cancelButtonTitle:@"OK"
//                                             otherButtonTitles:nil];
//        
//        [alert setTag:1];
//        [alert show];
//    
//    
//    
//}
//
//- (void)restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error {
//    NSLog(@"File upload failed with error: %@", error);
//    
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Could not upload to your Dropbox"
//                                                   message: @"Check your internet connection."
//                                                  delegate: self
//                                         cancelButtonTitle:@"OK"
//                                         otherButtonTitles:nil];
//    
//    [alert setTag:1];
//    [alert show];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButton:(id)sender {
       [self dismissViewControllerAnimated:YES completion:nil];

}


//- (IBAction)backButton:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
//    
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
