//
//  AddContactViewController.swift
//  ContacsUIApplication
//
//  Created by Jagan Mohan on 05/09/18.
//  Copyright © 2018 Jagan Mohan. All rights reserved.
//

import UIKit
import CoreData

class AddContactViewController: UIViewController {
    var contacts: [NSManagedObject] = []
     var convertedUrl = ""
    
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var countryName: UIButton!
    @IBOutlet weak var countryNameTextField: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldPhoneNumber: UITextField!
    @IBOutlet weak var codeBtn: UIButton!
    
    //MARK:- ViewController lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(AddContactViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddContactViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.contacts = CoreData.fetchDetailsFormDb(entityName:"Contacts")
        let tapProfilePic = UITapGestureRecognizer(target: self, action: #selector(tapProfilePicFunction))
        profileImage.addGestureRecognizer(tapProfilePic)
        profileImage.isUserInteractionEnabled = true
        profileImage.layer.cornerRadius = profileImage.frame.size.height/2
        self.hideKeyboard()
        saveBtn.layer.cornerRadius = 5.0
     pickerView.isHidden = true
    }
    
    //MARK:- Handling  TextField KeyBoard
    @objc func keyboardWillShow(notification: NSNotification) {
        if let _ = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= 150
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let _ = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += 150
            }
        }
    }
    
    //MARK:- Storing  PersonDetails to core data
    @IBAction func buttonRegister(sender: UIButton) {
        if (textFieldName.text?.isEmpty)! || (textFieldEmail.text?.isEmpty)!||(countryNameTextField.text?.isEmpty)! || (textFieldPhoneNumber.text?.isEmpty)! {
          presentingAlert(title: "Please enter all fields")
        }
        else {
            
            let data = UIImagePNGRepresentation(profileImage.image!)
          let   convertedUrl = (data?.base64EncodedString(options: NSData.Base64EncodingOptions()))!
            savingPersonDetails(entityName: "PersonDetails", profileImageUrl: convertedUrl, emailId: textFieldEmail.text!, phoneNumer: textFieldPhoneNumber.text!, countryName: countryNameTextField.text!, countryCode: (codeBtn.titleLabel?.text)!, name: textFieldName.text!)
        
        }
    }
}
extension AddContactViewController:UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    //MARK:- ImagePickerController
    @objc func tapProfilePicFunction(sender:UITapGestureRecognizer) {
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .destructive) { (action:UIAlertAction!) in
        }
        let camera = UIAlertAction(title: "Camera", style: .default) { (action:UIAlertAction!) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera;
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }        }
        
        
        let photo = UIAlertAction(title: "PhotoLibrary", style: .default) { (action:UIAlertAction!) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary;
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        alertController.addAction(photo)
        alertController.addAction(camera)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion:nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImage: UIImage?
        selectedImage = info["UIImagePickerControllerEditedImage"]   as? UIImage
        let data = UIImagePNGRepresentation(selectedImage!)
        convertedUrl = (data?.base64EncodedString(options: NSData.Base64EncodingOptions()))!
        self.profileImage.image =  selectedImage
        self.dismiss(animated: true, completion: nil)
    }
}
extension AddContactViewController:UITextFieldDelegate {
    //MARK:- UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == textFieldEmail {
            if isValidEmail(testStr: textFieldEmail.text!) {
                
            } else{
                presentingAlert(title: "Email id is not valid ")
            }
        }
    }
    func hideKeyboard() {
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(AddContactViewController.dismissKeyboard))
         view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 10
        var newString = NSString()
        if textField == textFieldPhoneNumber {
            let currentString: NSString = textField.text! as NSString
            newString =
                currentString.replacingCharacters(in: range, with: string) as NSString
        }
        
        return newString.length <= maxLength
    }
    
    //MARK:- ValidatingEmail
    func isValidEmail(testStr:String) -> Bool {
    
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}
extension AddContactViewController:UIPickerViewDataSource,UIPickerViewDelegate {
    //MARK:- PickerView Delegates
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return contacts.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let kundObj = self.contacts[row] as! Contacts
            return "\(kundObj.value(forKey: "countryName") as! String)     \(kundObj.value(forKey: "countryCode") as! String)"
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let kundObj = self.contacts[row] as! Contacts
        if countryName.isSelected == true {
            countryNameTextField.text = kundObj.value(forKey: "countryName") as? String
        }else{
          codeBtn.setTitle((kundObj.value(forKey: "countryCode") as! String), for: .normal)
        }
         pickerView.isHidden = true
    }
   
    @IBAction func buttonforCountryCodes(sender: UIButton) {
        codeBtn.isSelected = true
        countryName.isSelected = false
        pickerView.isHidden = false
         pickerView.bringSubview(toFront: self.view)
      
    }
    @IBAction func countryNameBtnAction(sender: UIButton) {
        codeBtn.isSelected = false
        countryName.isSelected = true
        pickerView.isHidden = false
        pickerView.bringSubview(toFront: self.view)
 
    }
    
    //MARK:- Storing Data to CoreData
      func savingPersonDetails(entityName: String,profileImageUrl:String,emailId:String,phoneNumer:String,countryName:String,countryCode:String,name:String) {
        let coreData = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = coreData.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName:entityName, in: managedObjectContext)
        let contact = NSManagedObject(entity: entity!, insertInto: managedObjectContext)
        contact.setValue(phoneNumer, forKey: "phoneNumber")
        contact.setValue(name, forKey: "name")
        contact.setValue(emailId, forKey: "emailId")
        contact.setValue(countryCode, forKey: "countryCode")
        contact.setValue(profileImageUrl, forKey: "profileImage")
        contact.setValue(countryName, forKey: "countryName")
        do {
            try managedObjectContext.save()
            let alert  = UIAlertController(title: "Your data Saved Sucessifully", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
                self.textFieldName.text = ""
                self.textFieldPhoneNumber.text = ""
                self.textFieldEmail.text = ""
                self.countryNameTextField.text = ""
                self.profileImage.image = UIImage(named: "Profile")
                self.codeBtn.setTitle("91", for: .normal)
            }
            alert.addAction(action)
            self .present(alert, animated: true, completion: nil)
        } catch let error as NSError {
            presentingAlert(title: "Couldn't save. \(error)")
            print("Couldn't save. \(error)")
           
        }
    }
    //MARK:- presentingAlert
    func presentingAlert(title:String){
        let alert  = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
        }
        alert.addAction(action)
        self .present(alert, animated: true, completion: nil)
    }
}
