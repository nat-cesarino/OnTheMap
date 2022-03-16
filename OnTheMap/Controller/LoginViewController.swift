//
//  ViewController.swift
//  OnTheMap
//
//  Created by Nathalie Cesarino on 07/03/22.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextLabel: UITextField!
    @IBOutlet weak var passwordTextLabel: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextLabel.text = ""
        passwordTextLabel.text = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        emailTextLabel.text = ""
        passwordTextLabel.text = ""
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        setLoggingIn(true)
        UdacityClient.login(username: emailTextLabel.text ?? "", password: passwordTextLabel.text ?? "", completion: handleLoginRequest(success:error:))
    }
    
    func handleLoginRequest(success: Bool, error: Error?) {
        if success {
            setLoggingIn(false)
            print(UdacityClient.Auth.sessionId)
            print("Login successful!")
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        } else {
            showLoginFailure(message: error?.localizedDescription ?? "")
            setLoggingIn(false)
        }
    }
    
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        emailTextLabel.isEnabled = !loggingIn
        passwordTextLabel.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
    }
}

