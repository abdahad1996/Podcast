//
//  UIApplication.swift
//  Podcast
//
//  Created by prog on 3/6/19.
//  Copyright © 2019 prog. All rights reserved.
//

import UIKit
extension UIApplication{
    static func mainTabBarController() -> MainTabBarController? {
        return UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
    }
}
