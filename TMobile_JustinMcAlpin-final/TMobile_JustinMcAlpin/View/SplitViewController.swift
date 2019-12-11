//
//  SplitViewController.swift
//  TMobile_JustinMcAlpin
//
//  Created by Justin McAlpin on 11/18/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import UIKit

final class SplitViewController: UISplitViewController, UISplitViewControllerDelegate
{
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        let navigationController = viewControllers[viewControllers.count-1] as! UINavigationController
        navigationController.topViewController!.navigationItem.leftBarButtonItem = self.displayModeButtonItem
        self.delegate = self
    }
        
    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController:UIViewController,
                             onto primaryViewController:UIViewController) -> Bool
    {
        return false
    }
}
