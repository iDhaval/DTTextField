//
//  ViewController.swift
//  DTTextField
//
//  Created by Dhaval Thanki on 04/03/2017.
//  Copyright (c) 2017 Dhaval Thanki. All rights reserved.
//

import UIKit
import DTTextField

class ViewController: UIViewController {

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
        
        title                           = "Registration"
        txtFirstName.errorMessage       = firstNameMessage
        txtLastName.errorMessage        = lastNameMessage
        txtEmail.errorMessage           = emailMessage
        txtPassword.errorMessage        = passwordMessage
        txtConfirmPassword.errorMessage = confirmPasswordMessage
        
        // Do any additional setup after loading the view, typically from a nib.
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
    
    
    func validateData() -> Bool {
        
        guard !txtFirstName.text!.isEmptyStr else {
            txtFirstName.showError = true
            return false
        }
        
        guard !txtLastName.text!.isEmptyStr else {
            txtLastName.showError = true
            return false
        }
        
        guard !txtEmail.text!.isEmptyStr else {
            txtEmail.showError = true
            return false
        }
        
        guard !txtPassword.text!.isEmptyStr else {
            txtPassword.showError = true
            return false
        }
        
        guard !txtConfirmPassword.text!.isEmptyStr else {
            txtConfirmPassword.errorMessage = confirmPasswordMessage
            txtConfirmPassword.showError = true
            return false
        }
        
        guard txtPassword.text == txtConfirmPassword.text else {
            txtConfirmPassword.errorMessage = mismatchPasswordMessage
            txtConfirmPassword.showError = true
            return false
        }
        
        return true
    }
}
