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
    
    let firstNameMessage        = "First name is required."
    let lastNameMessage         = "Last name is requried."
    let emailMessage            = "Email is required."
    let passwordMessage         = "Password is required."
    let confirmPasswordMessage  = "Confirm password is required."
    let mismatchPasswordMessage = "Password and Confirm password are not matching."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Registration"
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBtnSubmitClicked(_ sender: Any) {
        
        guard validateData() else { return }
        
        let alert = UIAlertController(title: "Congratulations", message: "Your registration is successful!!!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (cancel) in
            
            DispatchQueue.main.async {
                self.txtFirstName.text       = ""
                self.txtLastName.text        = ""
                self.txtEmail.text           = ""
                self.txtConfirmPassword.text = ""
                self.txtPassword.text        = ""
            }
        }))
        
        present(alert, animated: true, completion: nil)
        
    }

}

// MARK: User Define Methods
extension ViewController{
    
    func keyboardWillShow(notification:Notification) {
        guard let keyboardHeight = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else { return }
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, keyboardHeight.height, 0)
    }
    
    func keyboardWillHide(notification:Notification) {
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
