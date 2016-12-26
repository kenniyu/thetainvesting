//
//  NextUpWidgetStrings.swift
//  Coursera
//
//  Created by Alex Wang on 10/6/16.
//  Copyright © 2016 Coursera. All rights reserved.
//

import CourseraFoundation

final class LocalizedStrings {
    static var bundle: NSBundle { return NSBundle(forClass: LocalizedStrings.self) }
    
    // MARK: Templates
    
    /*
     
     Copy this template when defining new static strings
     
     static var <#variable_name#>: String {
     return NSLocalizedString(<#source_lang_string#>, tableName: "Localizable", bundle: LocalizedStrings.bundle, comment: <#translation_comment#>)
     }
     
     Copy this template when defining new format strings
     
     static func <#variable_name#>(<#typed_arguments#>) -> String {
     return String.localizedStringWithFormat(NSLocalizedString(<#source_lang_string#>, tableName: "Localizable", bundle: LocalizedStrings.bundle, comment: <#translation_comment#>), <#arguments#>)
     }
     
     */
    
    static var courseComplete: String {
        return NSLocalizedString("Course complete", tableName: "Localizable", bundle: LocalizedStrings.bundle, comment: "Subtitle in next up for when a course is complete")
    }
    
    static var viewCertificate: String {
        return NSLocalizedString("View certificate", tableName: "Localizable", bundle: LocalizedStrings.bundle, comment: "Title for next up for when a course is complete")
    }
    
    static var switchSessions: String {
        return NSLocalizedString("Switch sessions", tableName: "Localizable", bundle: LocalizedStrings.bundle, comment: "Title for next up for when a course is too far behind")
    }
    
    // MARK: - Next Up Content Types
    static var video: String {
        return NSLocalizedString("Video", tableName: "Localizable", bundle: LocalizedStrings.bundle, comment: "Item type name for videos")
    }
    
    static var reading: String {
        return NSLocalizedString("Reading", tableName: "Localizable", bundle: LocalizedStrings.bundle, comment: "Item type name for supplementary readings")
    }
    
    static var practiceQuiz: String {
        return NSLocalizedString("Practice Quiz", tableName: "Localizable", bundle: LocalizedStrings.bundle, comment: "Item type name for practice (i.e. formative) quizzes")
    }
    
    static var practiceAssignment: String {
        return NSLocalizedString("Practice Assignment", tableName: "Localizable", bundle: LocalizedStrings.bundle, comment: "Item type name for practice assignments")
    }
    
    static var discussionPrompt: String {
        return NSLocalizedString("Discussion Prompt", tableName: "Localizable", bundle: LocalizedStrings.bundle, comment: "Item type name for discussion prompts")
    }
    
    static var exam: String {
        return NSLocalizedString("Exam", tableName: "Localizable", bundle: LocalizedStrings.bundle, comment: "Item type name for graded quiz/exam")
    }
    
    static var gradedAssignment: String {
        return NSLocalizedString("Graded Assignment", tableName: "Localizable", bundle: LocalizedStrings.bundle, comment: "Item type name for graded assignments")
    }
    
    static var peerReviewAssignment: String {
        return NSLocalizedString("Peer-graded Assignment", tableName: "Localizable", bundle: LocalizedStrings.bundle, comment: "Item type name for peer assignments")
    }
    
    static var nextStepSwitchSessionsOverdue: String {
        return NSLocalizedString("Pick up right where you left off.", tableName: "Localizable", bundle: LocalizedStrings.bundle, comment: "Label indicating next up data - switch sessions.")
    }
    
    // MARK: Button strings
    static var view: String {
        return NSLocalizedString("View", tableName: "Localizable", bundle: LocalizedStrings.bundle, comment: "Button title for next up to view an item")
    }
    
    static var resume: String {
        return NSLocalizedString("Resume", tableName: "Localizable", bundle: LocalizedStrings.bundle, comment: "Button title for next up to resume an item")
    }
    
    static var start: String {
        return NSLocalizedString("Start", tableName: "Localizable", bundle: LocalizedStrings.bundle, comment: "Button title for next up to start an item")
    }
    
    static var switchButton: String {
        return NSLocalizedString("Switch", tableName: "Localizable", bundle: LocalizedStrings.bundle, comment: "Button title for next up to switch a session")
    }
    
    // MARK: - Lesson Content Length
    
    static func numberOfMinutesPlural(minutes: Int) -> String {
        return String.localizedStringWithFormat(NSLocalizedString("%d minutes", tableName: "Localizable", bundle: LocalizedStrings.bundle, comment: "Used to denote time length of a course lesson in the context 'x minutes' (plural)"), minutes)
    }
    
    static func numberOfMinutesSingular(minutes: Int) -> String {
        return String.localizedStringWithFormat(NSLocalizedString("%d minute", tableName: "Localizable", bundle: LocalizedStrings.bundle, comment: "Used to denote time length of a course lesson in the context '1 minute' (singular)"), minutes)
    }
    
    static func numberOfSecondsPlural(seconds: Int) -> String {
        return String.localizedStringWithFormat(NSLocalizedString("%d seconds", tableName: "Localizable", bundle: LocalizedStrings.bundle, comment: "Used to denote time length of a course lesson in the context 'x seconds' (plural)"), seconds)
    }
    
    static func numberOfSecondsSingular(seconds: Int) -> String {
        return String.localizedStringWithFormat(NSLocalizedString("%d second", tableName: "Localizable", bundle: LocalizedStrings.bundle, comment: "Used to denote time length of a course lesson in the context '1 second' (singular)"), seconds)
    }
    
    static func numberOfHoursAndMinutesShort(hours: Int, minutes: Int) -> String {
        return String.localizedStringWithFormat(NSLocalizedString("%d hr %d min", tableName: "Localizable", bundle: LocalizedStrings.bundle, comment: "Used to denote time length of a course lesson in the context 'x hr y min'"), hours, minutes)
    }
}
