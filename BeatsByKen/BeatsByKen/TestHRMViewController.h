//#import <UIKit/UIKit.h>
//@import CoreBluetooth;
//
//#define HRM_HEART_RATE_SERVICE_UUID @"180D"
//#define DEVICE_INFO_SERVICE_UUID @"180A"
//
//#define HRM_MEASUREMENT_CHARACTERISTIC_UUID @"2A37"
//#define HRM_BODY_LOCATION_CHARACTERISTIC_UUID @"2A38"
//#define DEVICE_MANUFACTURER_NAME_CHARACTERISTIC_UUID @"2A29"
//
//@interface TestHRMViewController : UIViewController <CBCentralManagerDelegate, CBPeripheralDelegate>{
//    BOOL running;
//    BOOL viewHasLoaded; 
//    int started;
//    int trial;
//    NSTimer *stopTimer;
//    NSDate *startDate;
//    NSDate *timerDate;
//    NSString *startTimeString;
//    NSString *endTimeString;
//    NSMutableArray *trialArray;
//    NSString *localName;
//    NSMutableString *csv;
//    BOOL gettingBPM;
//    BOOL startNewSession;
//    BOOL trialRan;
//    int rrCount;
//    int startRRCount;
//    int endRRCount; 
//}
//
//@property (nonatomic, strong) CBCentralManager *centralManager;
//@property (nonatomic, strong) CBPeripheral *hrmPeripheral;
//
//@property (nonatomic, strong) IBOutlet UIImageView *heartImage;
//
//@property (assign) uint16_t heartRate;
//@property (assign) float rateThisSecond;
//@property (assign) int recievedBeatsCount;
//
//
//@property (assign) float ratesOverSeconds;
//@property (assign) int count; 
//@property (assign) BOOL startButtonPressed;
//@property (assign) BOOL pre1ButtonPressed;
//@property (assign) BOOL pre2ButtonPressed;
//@property (assign) BOOL pre3ButtonPressed;
//@property (assign) BOOL pre4ButtonPressed;
//@property (assign) BOOL post1ButtonPressed;
//@property (assign) BOOL post2ButtonPressed;
//@property (assign) BOOL post3ButtonPressed;
//@property (assign) BOOL post4ButtonPressed;
//@property (assign) BOOL exer1ButtonPressed;
//@property (assign) BOOL exer2ButtonPressed;
//@property (assign) BOOL exer3ButtonPressed;
//@property (assign) BOOL exer4ButtonPressed;
//
//@property (nonatomic, strong) UILabel    *heartRateBPM;
//@property (nonatomic, retain) NSTimer    *pulseTimer;
//@property (nonatomic, strong) IBOutlet UILabel *startTimeLabel;
//@property (nonatomic, strong) IBOutlet UILabel *endTimeLabel;
//
//
//@property (weak, nonatomic) IBOutlet UIButton *startButton;
//
//// Instance method to get the heart rate BPM information
//- (void) getHeartBPMData:(CBCharacteristic *)characteristic error:(NSError *)error;
//- (void) getBodyLocation:(CBCharacteristic *)characteristic;
//
//// Instance methods to grab device Manufacturer Name, Body Location
//- (void) getManufacturerName:(CBCharacteristic *)characteristic;
//
//- (void) updateTimer; 
//
//- (void) doHeartBeat;
//- (int) countHeartBeats:(int *)count;
//
//@end