//#import "TestHRMViewController.h"
//#import "Trial.h"
//#import "CSVController.h"
//
//@interface TestHRMViewController ()
//@property (weak, nonatomic) IBOutlet UILabel *monitorNameLabel;
//@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
//@property (weak, nonatomic) IBOutlet UITextField *participantNumberTextField;
//@property (weak, nonatomic) IBOutlet UITextField *sessionNumberTextField;
//@property (weak, nonatomic) IBOutlet UILabel *trialLabel;
//@property (weak, nonatomic) IBOutlet UIButton *endSessionButton;
//@property (weak, nonatomic) IBOutlet UIButton *homeButton;
//@property (weak, nonatomic) IBOutlet UIButton *sessionButton;
//@property (weak, nonatomic) IBOutlet UILabel *beatCountLabel;
//
//
//
//@end
//
//
//@implementation TestHRMViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//
//    
//    self.count=0;
//    self.recievedBeatsCount = 0;
//    // Do any additional setup after loading the view.
//    
//    // Create the CoreBluetooth CentralManager //
//    CBCentralManager *centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
//    self.centralManager = centralManager;
//    
//    [self.heartImage setImage:[UIImage imageNamed:@"HeartImage"]];
//
//
//    self.timerLabel.text = @"0:00.00";
//    self.startTimeLabel.text = @"0:00.00";
//    self.endTimeLabel.text = @"0:00.00";
//    
//    self.timerLabel.layer.cornerRadius = 15;
//    self.startButton.layer.cornerRadius = 15;
//    self.endSessionButton.layer.cornerRadius = 15;
//    self.homeButton.layer.cornerRadius = 15;
//    self.sessionButton.layer.cornerRadius = 15;
//    
//    running = FALSE;
//    started = 0;
//    trial = 0;
//    localName = @"";
//    
//    trialRan = FALSE;
//    
//    trialArray = [[NSMutableArray alloc] init];
//    
//    // Create our Heart Rate BPM Label
//    self.heartRateBPM = [[UILabel alloc] initWithFrame:CGRectMake(70, 115, 250, 100)];
//    [self.heartRateBPM setTextAlignment:NSTextAlignmentCenter];
//    [self.heartRateBPM setTextColor:[UIColor whiteColor]];
//    [self.heartRateBPM setText:@"No device detected"];
//    [self.heartRateBPM setFont:[UIFont fontWithName:@"Futura-CondensedMedium" size:40]];
//    [self.heartImage addSubview:self.heartRateBPM];
//    
//    NSArray *services = @[[CBUUID UUIDWithString:HRM_HEART_RATE_SERVICE_UUID], [CBUUID UUIDWithString:DEVICE_INFO_SERVICE_UUID]];
//    [self.centralManager retrieveConnectedPeripheralsWithServices:services];
//
//    
//     //self.heartRateBPM.text = [NSString stringWithFormat:@"%i bpm", self.heartRate];
//     //self.heartRateBPM.font = [UIFont fontWithName:@"Futura-CondensedMedium" size:46];
//
//    
//    
//    
//    
//}
//
//#pragma mark - CBCharacteristic helpers
//
//
//- (void) doHeartBeat
//{
//    CALayer *layer = [self heartImage].layer;
//    CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    pulseAnimation.toValue = [NSNumber numberWithFloat:1.2];
//    pulseAnimation.fromValue = [NSNumber numberWithFloat:1.0];
//    
//    pulseAnimation.duration = .8;
//    pulseAnimation.repeatCount = HUGE_VALF;
//    pulseAnimation.autoreverses = YES;
//    [layer addAnimation:pulseAnimation forKey:@"scale"];
//    
//    
//    self.count++;
//    
//    //self.pulseTimer = [NSTimer scheduledTimerWithTimeInterval:(60. / self.heartRate) target:self selector:@selector(doHeartBeat) userInfo:nil repeats:NO];
//}
//
//
//
//
//
//
//
//- (IBAction)startButton:(id)sender {
//    
//    startNewSession = FALSE;
//
//    
//    if(([self.participantNumberTextField.text isEqualToString: @""]) || ([self.participantNumberTextField.text isEqualToString:@""])){
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Wait!"
//                                                       message: @"You need to enter both Particpant Number and Session Number"
//                                                      delegate: self
//                                             cancelButtonTitle:@"OK"
//                                             otherButtonTitles:nil];
//        
//        [alert setTag:1];
//        [alert show];
//    }
//    
//    else if([localName isEqualToString:@""]){
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Wait!"
//                                                       message: @"Please wait for Bluetooth sensor to connect."
//                                                      delegate: self
//                                             cancelButtonTitle:@"OK"
//                                             otherButtonTitles:nil];
//        
//        [alert setTag:1];
//        [alert show];
//    }
//    
//    else{
//
//        self.recievedBeatsCount = 0;
//        self.startButtonPressed = YES;
//        started++;
//
//
//    if(started == 1){
//        startDate = [NSDate date];
//
//    }
//    
//    
//    if(!running){
//        trial++;
//        running = TRUE;
//        
//        startRRCount = rrCount; 
//        
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"m:ss.SS"];
//        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
//        startTimeString = [dateFormatter stringFromDate:timerDate];
//        if(started == 1){
//            startTimeString = @"0:00.00";
//        }
//        self.startTimeLabel.text = startTimeString;
//        self.endTimeLabel.text = @"";
//
//        
//        [sender setTitle:[NSString stringWithFormat:@"Stop Trial %d",trial] forState:UIControlStateNormal];
//        if (stopTimer == nil) {
//            stopTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/10.0
//                                                         target:self
//                                                       selector:@selector(updateTimer)
//                                                       userInfo:nil
//                                                        repeats:YES];
//        }
//    }else{
//        
//
//        trialRan = TRUE;
//
//        endRRCount = rrCount;
//        
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"m:ss.SS"];
//        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
//        endTimeString = [dateFormatter stringFromDate:timerDate];
//        self.endTimeLabel.text = endTimeString;
//        
//        running = FALSE;
//        [sender setTitle:[NSString stringWithFormat:@"Start Trial %d",trial+1] forState:UIControlStateNormal];
//       
//        
//        Trial *thisTrial = [[Trial alloc] initWithStartTime:startTimeString EndTime:endTimeString TrialNumber:[NSString stringWithFormat:@"%d",trial] BeatCount:[NSString stringWithFormat:@"%d", endRRCount - startRRCount] SessionNumber:self.sessionNumberTextField.text ParticipantID:self.participantNumberTextField.text];
//        
//        [trialArray addObject:(thisTrial)];
//
//    }
//    
//    self.trialLabel.text = [NSString stringWithFormat:@"Trial %d Information:",trial];
//
//    
//    }
//}
//
//-(void)updateTimer{
//    
//    if(startNewSession == FALSE){
//        NSDate *currentDate = [NSDate date];
//        NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:startDate];
//        timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"m:ss.SS"];
//        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
//        NSString *timeString=[dateFormatter stringFromDate:timerDate];
//        self.timerLabel.text = timeString;
//    }
//    
//
//}
//
//
//
//- (IBAction)newSession:(id)sender {
//    
//    startNewSession = TRUE;
//    
//    self.participantNumberTextField.text = @"";
//    self.sessionNumberTextField.text = @"";
//    trial = 0;
//    running = FALSE;
//    started = 0;
//    self.timerLabel.text = @"0:00.00";
//    self.trialLabel.text = @"Trial Information:";
//    self.startTimeLabel.text = @"0:00.00";
//    self.endTimeLabel.text = @"0:00.00";
//    startDate = nil;
//    [trialArray removeAllObjects];
//    [sender setTitle:@"Start Trial"];
//
//    
//}
//
//
//
//
//
//- (IBAction)endSessionButton:(id)sender {
//    
//    
//    
//        NSString *participantNumber = self.participantNumberTextField.text;
//        NSString *sessionNumber = self.sessionNumberTextField.text;
//    
//    
//        csv = [NSMutableString stringWithString:@"Participant Number, Session Number, Trial, Start Time, End Time, Heart Beat Count"];
//        NSUInteger count = [trialArray count];
//    
//        for(Trial *trial in trialArray){
//            [csv appendFormat:@"\n%@,%@,%@,%@,%@,%@", [trial participantID], [trial session], [trial trialNumber], [trial startTime], [trial endTime], [trial beatCount]];
//        }
//    
//    
//        UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"CSVController"];
//        [self.navigationController pushViewController: myController animated:YES];
//    
//
//    
//    
//
//    
//}
//
//
//
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    
//    
//        if([segue.identifier isEqualToString:@"cvsSegue"]) {
//
//            CSVController *controller = (CSVController *)segue.destinationViewController;
//            controller.csvString = csv;
//            controller.trialArray = trialArray;
//        }
//    
//}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//- (IBAction)homeButton:(id)sender
//{
//    
//    
//    [self dismissViewControllerAnimated:YES completion:nil];
//    
//    
//}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//@end