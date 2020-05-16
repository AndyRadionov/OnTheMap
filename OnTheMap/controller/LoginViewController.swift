//
//  ViewController.swift
//  OnTheMap
//
//  Created by Andy on 14.05.2020.
//  Copyright © 2020 AndyRadionov. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        usernameTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        enableViews(false)
        OnTheMapClient.createSession(username: usernameTextField.text ?? "", password: passwordTextField.text ?? "", completion: handleLoginResponse)
    }
    
    @IBAction func signUpTapped() {
        enableViews(false)
        UIApplication.shared.open(OnTheMapClient.Endpoints.signUp.url, options: [:], completionHandler: nil)
    }
    
    private func handleLoginResponse(success: Bool, error: OnTheMapClient.OnTheMapError?) {
        DispatchQueue.main.async {
            self.enableViews(true)
        }
        if error != nil {
            self.showErrorAlert(error!, self)
            return
        }
        if success {
            self.performSegue(withIdentifier: "completeLogin", sender: nil)
        } else {
            self.showErrorAlert(.loginError, self)
        }
    }
        
    private func enableViews(_ enable: Bool) {
        if enable {
            activityIndicator.stopAnimating()
        } else {
            activityIndicator.startAnimating()
        }
        usernameTextField.isEnabled = enable
        passwordTextField.isEnabled = enable
        loginButton.isEnabled = enable
        signUpButton.isEnabled = enable
    }
}

