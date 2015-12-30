//
//  CSVTableViewCell.swift
//  BeatsByKen
//
//  Created by Stephen Grinich on 9/6/15.
//  Copyright (c) 2015 Liz Shank. All rights reserved.
//

import UIKit

class CSVTableViewCell: UITableViewCell{
    
//    
//    int HEIGHT = 35;
//    int WIDTH = 122;
//    
//    int PARTICIPANT_X = 18;
//    int PARTICIPANT_Y = 29;
//
//    int SESSION_X = 139;
//    int SESSION_Y = 29;
//    
//    int TRIAL_X = 261;
//    int TRIAL_Y = 29;
//    
//    int START_TIME_X = 383;
//    int START_TIME_Y = 29;
//    
//    int END_TIME_X = 505;
//    int END_TIME_Y = 29;
//    
//    int BEAT_COUNT_X = 627;
//    int BEAT_COUNT_Y = 29;
    
    var participantIDLabel: UILabel!
    var sessionLabel: UILabel!
    var trialLabel: UILabel!
    var startTimeLabel: UILabel!
    var endTimeLabel: UILabel!
    var beatCountLabel: UILabel!
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        participantIDLabel = UILabel(frame: CGRectMake(contentView.frame.origin.x+10, contentView.frame.origin.y+10, 130, contentView.frame.height/2));
        sessionLabel = UILabel(frame: CGRectMake(participantIDLabel.frame.origin.x+participantIDLabel.frame.width, contentView.frame.origin.y+10, 130, contentView.frame.height/2));
        trialLabel = UILabel(frame: CGRectMake(sessionLabel.frame.origin.x+sessionLabel.frame.width, contentView.frame.origin.y+10, 100, contentView.frame.height/2));
        startTimeLabel = UILabel(frame: CGRectMake(trialLabel.frame.origin.x+trialLabel.frame.width, contentView.frame.origin.y+10, 130, contentView.frame.height/2));
        endTimeLabel = UILabel(frame: CGRectMake(startTimeLabel.frame.origin.x+startTimeLabel.frame.width, contentView.frame.origin.y+10, 130, contentView.frame.height/2));
        beatCountLabel = UILabel(frame: CGRectMake(endTimeLabel.frame.origin.x+endTimeLabel.frame.width, contentView.frame.origin.y+10, 130, contentView.frame.height/2));


        contentView.addSubview(participantIDLabel);
        contentView.addSubview(sessionLabel);
        contentView.addSubview(trialLabel);
        contentView.addSubview(startTimeLabel);
        contentView.addSubview(endTimeLabel);
        contentView.addSubview(beatCountLabel);

        
    
    
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    
}
