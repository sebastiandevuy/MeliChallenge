//
//  Navigator.swift
//  MeliChallenge
//
//  Created by Pablo Gonzalez on 8/8/21.
//

import Foundation
import UIKit
import Combine

protocol NavigatorProtocol {
    func pushController(controller: UIViewController)
    func popToRoot(animated: Bool)
}

/// Object in charge of all top level app navigation coordination
class Navigator: NavigatorProtocol {
    static let shared = Navigator()
    
    private init() {}
    
    /// Presents controller over the top most presented controller, wrapped inside a navigation controller
    /// - Parameter controller: controller to present
    func pushController(controller: UIViewController) {
        guard let mainNav = getRootNavigationController() else { return }
        mainNav.pushViewController(controller, animated: true)
    }
    
    /// Pops to root
    /// - Parameter animated: if popping is animated
    func popToRoot(animated: Bool) {
        getRootNavigationController()?.popToRootViewController(animated: animated)
    }
}

private extension NavigatorProtocol {
    func getRootNavigationController() -> UINavigationController? {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        guard let mainNav = keyWindow?.rootViewController as? UINavigationController else { return nil }
        return mainNav
    }
}
