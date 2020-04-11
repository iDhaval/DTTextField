//
//  ViewController.swift
//  DTTextField
//
//  Created by Dhaval Thanki on 04/03/2017.
//  Copyright (c) 2017 Dhaval Thanki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txtFirstName: DTTextField!
    @IBOutlet weak var txtLastName: DTTextField!
    @IBOutlet weak var txtEmail: DTTextField!
    @IBOutlet weak var txtPassword: DTTextField!
    @IBOutlet weak var txtConfirmPassword: DTTextField!
    
    let firstNameMessage        = NSLocalizedString("First name is required.", comment: "")
    let lastNameMessage         = NSLocalizedString("Last name is required.", comment: "")
    let emailMessage            = NSLocalizedString("Email is required.", comment: "")
    let passwordMessage         = NSLocalizedString("Password is required.", comment: "")
    let confirmPasswordMessage  = NSLocalizedString("Confirm password is required.", comment: "")
    let mismatchPasswordMessage = NSLocalizedString("Password and Confirm password are not matching.", comment: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view, typically from a nib.
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBtnSubmitClicked(_ sender: Any) {
        
        guard validateData() else { return }
        
        let alert = UIAlertController(title: "Congratulations", message: "Your registration is successful!!!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (cancel) in
            DispatchQueue.main.async { self.clearForm() }
        }))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func clearForm() {
        self.txtFirstName.text       = ""
        self.txtLastName.text        = ""
        self.txtEmail.text           = ""
        self.txtConfirmPassword.text = ""
        self.txtPassword.text        = ""
    }
}

// MARK: User Define Methods
extension ViewController{
    
    @objc func keyboardWillShow(notification:Notification) {
        guard let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else { return }
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight.height, right: 0)
    }
    
    @objc func keyboardWillHide(notification:Notification) {
        scrollView.contentInset = .zero
    }
    
    func validateData() -> Bool {
        
        guard !txtFirstName.text!.isEmptyStr else {
            txtFirstName.showError(message: firstNameMessage)
            return false
        }
        
        guard !txtLastName.text!.isEmptyStr else {
            txtLastName.showError(message: lastNameMessage)
            return false
        }
        
        guard !txtEmail.text!.isEmptyStr else {
            txtEmail.showError(message: emailMessage)
            return false
        }

        guard !txtPassword.text!.isEmptyStr else {
            txtPassword.showError(message: passwordMessage)
            return false
        }
        
        guard !txtConfirmPassword.text!.isEmptyStr else {
            txtConfirmPassword.showError(message: confirmPasswordMessage)
            return false
        }
        
        guard txtPassword.text == txtConfirmPassword.text else {
            txtConfirmPassword.showError(message: mismatchPasswordMessage)
            return false
        }
        
        return true
    }
}
