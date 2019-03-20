//
//  UIDevice+Kawagarbo.swift
//  Kawagarbo_iOS
//
//  Created by wyhazq on 2019/1/29.
//

import Foundation

extension KGNamespace where Base == UIDevice {

    public static var phoneModel: SLPhoneModel {
        let hardware = hardwareString
        
        if hardware == "iPhone1,1"         { return .iPhone2G }
        if hardware == "iPhone1,2"         { return .iPhone3G }
        if hardware == "iPhone2,1"         { return .iPhone3GS }
        
        if hardware == "iPhone3,1"         { return .iPhone4 }
        if hardware == "iPhone3,2"         { return .iPhone4 }
        if hardware == "iPhone3,3"         { return .iPhone4 }
        if hardware == "iPhone4,1"         { return .iPhone4S }
        
        if hardware == "iPhone5,1"         { return .iPhone5 }
        if hardware == "iPhone5,2"         { return .iPhone5 }
        if hardware == "iPhone5,3"         { return .iPhone5C }
        if hardware == "iPhone5,4"         { return .iPhone5C }
        if hardware == "iPhone6,1"         { return .iPhone5S }
        if hardware == "iPhone6,2"         { return .iPhone5S }
        
        if hardware == "iPhone7,1"         { return .iPhone6Plus }
        if hardware == "iPhone7,2"         { return .iPhone6 }
        if hardware == "iPhone8,1"         { return .iPhone6S }
        if hardware == "iPhone8,2"         { return .iPhone6SPlus }
        if hardware == "iPhone8,4"         { return .iPhoneSE }
        
        if hardware == "iPhone9,1"         { return .iPhone7 }
        if hardware == "iPhone9,2"         { return .iPhone7Plus }
        if hardware == "iPhone9,3"         { return .iPhone7 }
        if hardware == "iPhone9,4"         { return .iPhone7Plus }
        
        if hardware == "iPhone10,1"        { return .iPhone8 }
        if hardware == "iPhone10,2"        { return .iPhone8Plus }
        if hardware == "iPhone10,3"        { return .iPhoneX }
        if hardware == "iPhone10,4"        { return .iPhone8 }
        if hardware == "iPhone10,5"        { return .iPhone8Plus }
        if hardware == "iPhone10,6"        { return .iPhoneX }
        
        if hardware == "iPhone11,2"        { return .iPhoneXS }
        if hardware == "iPhone11,4"        { return .iPhoneXSMax }
        if hardware == "iPhone11,6"        { return .iPhoneXSMax }
        if hardware == "iPhone11,8"        { return .iPhoneXR }
        
        
        if hardware == "iPod1,1"           { return .iPodTouch }
        if hardware == "iPod2,1"           { return .iPodTouch2 }
        if hardware == "iPod3,1"           { return .iPodTouch3 }
        if hardware == "iPod4,1"           { return .iPodTouch4 }
        if hardware == "iPod5,1"           { return .iPodTouch5 }
        if hardware == "iPod7,1"           { return .iPodTouch6 }
        
        if hardware == "iPad1,1"           { return .iPad }
        if hardware == "iPad1,2"           { return .iPad }
        
        if hardware == "iPad2,1"           { return .iPad2 }
        if hardware == "iPad2,2"           { return .iPad2 }
        if hardware == "iPad2,3"           { return .iPad2 }
        if hardware == "iPad2,4"           { return .iPad2 }
        if hardware == "iPad2,5"           { return .iPadMini }
        if hardware == "iPad2,6"           { return .iPadMini }
        if hardware == "iPad2,7"           { return .iPadMini }
        
        if hardware == "iPad3,1"           { return .iPad3 }
        if hardware == "iPad3,2"           { return .iPad3 }
        if hardware == "iPad3,3"           { return .iPad3 }
        if hardware == "iPad3,4"           { return .iPad4 }
        if hardware == "iPad3,5"           { return .iPad4 }
        if hardware == "iPad3,6"           { return .iPad4 }
        
        if hardware == "iPad4,1"           { return .iPadAir }
        if hardware == "iPad4,2"           { return .iPadAir }
        if hardware == "iPad4,3"           { return .iPadAir }
        if hardware == "iPad4,4"           { return .iPadMini2 }
        if hardware == "iPad4,5"           { return .iPadMini2 }
        if hardware == "iPad4,6"           { return .iPadMini2 }
        if hardware == "iPad4,7"           { return .iPadMini3 }
        if hardware == "iPad4,8"           { return .iPadMini3 }
        if hardware == "iPad4,9"           { return .iPadMini3 }
        
        if hardware == "iPad5,1"           { return .iPadMini4 }
        if hardware == "iPad5,2"           { return .iPadMini4 }
        if hardware == "iPad5,3"           { return .iPadAir2 }
        if hardware == "iPad5,4"           { return .iPadAir2 }
        
        if hardware == "iPad6,3"           { return .iPadPro }
        if hardware == "iPad6,4"           { return .iPadPro }
        if hardware == "iPad6,7"           { return .iPadPro }
        if hardware == "iPad6,8"           { return .iPadPro }
        if hardware == "iPad6,11"          { return .iPad5 }
        if hardware == "iPad6,12"          { return .iPad5 }
        
        if hardware == "iPad7,1"           { return .iPadPro2 }
        if hardware == "iPad7,2"           { return .iPadPro2 }
        if hardware == "iPad7,3"           { return .iPadPro2 }
        if hardware == "iPad7,4"           { return .iPadPro2 }
        
        if hardware == "AppleTV1,1"        { return .AppleTV }
        if hardware == "AppleTV2,1"        { return .AppleTV2 }
        if hardware == "AppleTV3,1"        { return .AppleTV3 }
        if hardware == "AppleTV3,2"        { return .AppleTV3 }
        if hardware == "AppleTV5,3"        { return .AppleTV4 }
        
        if hardware == "Watch1,1"          { return .AppleWatch }
        if hardware == "Watch1,2"          { return .AppleWatch }
        if hardware == "Watch2,3"          { return .AppleWatch2 }
        if hardware == "Watch2,4"          { return .AppleWatch2 }
        if hardware == "Watch2,6"          { return .AppleWatch2 }
        if hardware == "Watch2,7"          { return .AppleWatch2 }
        if hardware == "Watch3,1"          { return .AppleWatch3 }
        if hardware == "Watch3,2"          { return .AppleWatch3 }
        if hardware == "Watch3,3"          { return .AppleWatch3 }
        if hardware == "Watch3,4"          { return .AppleWatch3 }
        if hardware == "Watch4,1"          { return .AppleWatch4 }
        if hardware == "Watch4,2"          { return .AppleWatch4 }
        if hardware == "Watch4,3"          { return .AppleWatch4 }
        if hardware == "Watch4,4"          { return .AppleWatch4 }

        if hardware == "i386"              { return .Simulator }
        if hardware == "x86_64"            { return .Simulator }
        
        return .Unknown
    }
    
    public enum SLPhoneModel: String {
        case iPhone2G = "iPhone 2G"
        
        case iPhone3G = "iPhone 3G"
        case iPhone3GS = "iPhone 3GS"
        
        case iPhone4 = "iPhone 4"
        case iPhone4S = "iPhone 4S"
        
        case iPhone5 = "iPhone 5"
        case iPhone5C = "iPhone 5C"
        case iPhone5S = "iPhone 5S"
        
        case iPhone6 = "iPhone 6"
        case iPhone6Plus = "iPhone 6 Plus"
        case iPhone6S = "iPhone 6S"
        case iPhone6SPlus = "iPhone 6S Plus"
        case iPhoneSE = "iPhone SE"
        
        case iPhone7 = "iPhone 7"
        case iPhone7Plus = "iPhone 7 Plus"
        
        case iPhone8 = "iPhone 8"
        case iPhone8Plus = "iPhone 8 Plus"
        case iPhoneX = "iPhone X"
        
        case iPhoneXS = "iPhone XS"
        case iPhoneXSMax = "iPhone XS Max"
        case iPhoneXR = "iPhone XR"

        case iPodTouch = "iPod Touch"
        case iPodTouch2 = "iPod Touch 2"
        case iPodTouch3 = "iPod Touch 3"
        case iPodTouch4 = "iPod Touch 4"
        case iPodTouch5 = "iPod Touch 5"
        case iPodTouch6 = "iPod Touch 6"
        
        case iPad = "iPad"
        
        case iPad2 = "iPad 2"
        case iPadMini = "iPad mini"
        
        case iPad3 = "iPad 3"
        case iPad4 = "iPad 4"
        
        case iPadAir = "iPad Air"
        case iPadMini2 = "iPad mini 2"
        case iPadMini3 = "iPad mini 3"
        
        case iPadMini4 = "iPad mini 4"
        case iPadAir2 = "iPad Air 2"
        
        case iPadPro = "iPad Pro"
        case iPad5 = "iPad 5"
        
        case iPadPro2 = "iPad Pro 2"
        
        case AppleTV = "Apple TV"
        case AppleTV2 = "Apple TV 2"
        case AppleTV3 = "Apple TV 3"
        case AppleTV4 = "Apple TV 4"
        
        case AppleWatch = "Apple Watch"
        case AppleWatch2 = "Apple Watch 2"
        case AppleWatch3 = "Apple Watch 3"
        case AppleWatch4 = "Apple Watch 4"

        case Simulator = "Simulator"
        
        case Unknown = "Unknown"
    }
    
    public static var hardwareString: String {
        var name: [Int32] = [CTL_HW, HW_MACHINE]
        var size: Int = 2
        sysctl(&name, 2, nil, &size, nil, 0)
        var hw_machine = [CChar](repeating: 0, count: Int(size))
        sysctl(&name, 2, &hw_machine, &size, nil, 0)
        
        let hardware: String = String(cString: hw_machine)
        return hardware
    }
    
}
