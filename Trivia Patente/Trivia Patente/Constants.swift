//
//  Costants.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 05/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import Foundation

class Constants {
    static let max_life_number = 3
    static let kLastLuckyPopTS = "luckyPopoverLastTS"
    static let kLastReviewPopTS = "reviewPopoverLastTS"
    static let kLastPrivacyPopTS = "privacyPopoverLastTS"
    static let kLastTermsPopTS = "termsPopoverLastTS"
    static let kLuckyPopShouldShowTS = "luckyPopoverShouldShow"
    static let kReviewPopShouldShowTS = "reviewPopoverShouldShow"
    static let avataImageRapresentationQuality = CGFloat(0.6) // from 0 to 1, proportion of original resolution
    static let toastDuration : TimeInterval = 2
    static let usernameMinLength = 3
    static let passwordMinLength = 7
    static let storedVersionKey = "appVersion"
    
    
    // ADMOB
    static let BannerUnitID = "ca-app-pub-3940256099942544/2934735716"// "ca-app-pub-6517751265585915/8135598443" //(official)
    static let InterstitialUnitID = "ca-app-pub-3940256099942544/4411468910"// "ca-app-pub-6517751265585915/9033747144" //(official)
}
