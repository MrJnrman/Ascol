//
//  CreatePostVC.swift
//  Ascol
//
//  Created by Jamel Reid  on 5/6/17.
//  Copyright © 2017 Jamel Reid . All rights reserved.
//

import UIKit
import Firebase

class CreatePostVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UITextViewDelegate {
    
    var courses = [String]()
    var types = [String]()
    var categories = [String]()
    
    @IBOutlet weak var courseBtn: UIButton!
    @IBOutlet weak var coursePicker: UIPickerView!
    @IBOutlet weak var typeBtn: UIButton!
    @IBOutlet weak var typePicker: UIPickerView!
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var titleTxtField: UITextField!
    @IBOutlet weak var tagsTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var detailsTextField: UITextView!
    @IBOutlet weak var commentsTextField: UITextView!
    
    var profile: Profile!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        coursePicker.delegate = self
        coursePicker.dataSource = self
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        typePicker.delegate = self
        typePicker.dataSource = self
        titleTxtField.delegate = self
        tagsTextField.delegate = self
        locationTextField.delegate = self
        detailsTextField.delegate = self
        commentsTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.KeyboardWillShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.KeyboardWillHide(sender:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        DataService.ds.REF_COURSES.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    
                    if let course = snap.value as? Dictionary<String, String> {
                        print("\(course["name"]!)")
                        self.courses.append(course["name"]!)
                    }
                }
            }
            
        })
        
        DataService.ds.REF_CATEGORIES.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    
                    if let category = snap.value as? Dictionary<String, String> {
                        print("\(category["name"]!)")
                        self.categories.append(category["name"]!)
                    }
                }
            }
            
        })
        
        DataService.ds.REF_TYPES.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    
                    if let type = snap.value as? Dictionary<String, String> {
                        print("\(type["name"]!)")
                        self.types.append(type["name"]!)
                    }
                }
            }
            
        })
    }
    
    
    // Course Picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == coursePicker {
            return courses.count
        } else if pickerView == typePicker {
            return types.count
        } else {
            return categories.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == coursePicker {
            return courses[row]
        } else if pickerView == typePicker {
            return types[row]
        } else {
            return categories[row]
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == coursePicker {
            
            courseBtn.setTitle(courses[row], for: UIControlState.normal)
            pickerView.isHidden = true
            
        } else if pickerView == typePicker {
            
            typeBtn.setTitle(types[row], for: UIControlState.normal)
            pickerView.isHidden = true
            
        } else {
            categoryBtn.setTitle(categories[row], for: UIControlState.normal)
            pickerView.isHidden = true
        }

    }
    
//    
//    func typePicker(_ typePicker: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        
//        courseBtn.setTitle(types[row], for: UIControlState.normal)
//        typePicker.isHidden = true
//    }
//    
    @IBAction func courseBtnPressed(_ sender: UIButton) {
        coursePicker.isHidden = false
    }
    
    @IBAction func typeBtnPressed(_ sender: UIButton) {
        typePicker.isHidden = false
    }
    
    @IBAction func categoryBtnPressed(_ sender: UIButton) {
        categoryPicker.isHidden = false
    }
    
    @IBAction func submitBtnPressed(_ sender: UIButton) {
        let postKey = DataService.ds.REF_POSTS.childByAutoId().key
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        
        let currentDate = dateFormatter.string(from: Date())
        let userData = ["category": categoryBtn.currentTitle!,
                        "commentId": postKey,
                        "title": titleTxtField.text!,
                        "comments": commentsTextField.text!,
                        "details": detailsTextField.text!,
                        "course": courseBtn.currentTitle!,
                        "type": typeBtn.currentTitle!,
                        "likes": 0,
                        "views": 0,
                        "tags": tagsTextField.text!,
                        "location": locationTextField.text!,
                        "imageURL": profile.imageUrl,
                        "creator": profile.name,
                        "date": currentDate] as [String : Any]
        
        DataService.ds.REF_POSTS.child(postKey).setValue(userData)
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
    
    func KeyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = -170
    }
    
    func KeyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)

    }
}
