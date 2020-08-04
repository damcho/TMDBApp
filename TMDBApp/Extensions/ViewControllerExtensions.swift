//
//  ViewControllerExtensions.swift
//  TMDBApp
//
//  Created by Damian Modernell on 15/01/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlertView(msg:String) -> () {
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    static func loadFromStoryboard<T: UIViewController>() -> T{
        let bundle = Bundle(for: self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! T
        return vc
    }
}
