//
//  UiViewController+Alert.swift
//  OnTheMap
//
//  Created by Andy on 15.05.2020.
//  Copyright © 2020 AndyRadionov. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showErrorAlert(_ error: OnTheMapClient.OnTheMapError, _ presenter: UIViewController) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                alert.dismiss(animated: true, completion: nil)
            }))
            presenter.present(alert, animated: true)
        }
    }
}
