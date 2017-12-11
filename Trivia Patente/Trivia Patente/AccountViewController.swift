//
//  AccountViewController.swift
//  Trivia Patente
//
//  Created by Gabriel Ciulei on 02/11/2017.
//  Copyright © 2017 Terpin e Donadel. All rights reserved.
//

import UIKit
import AVKit
import Photos

class AccountViewController: FormViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var avatarImageView: UIImageView!
    var nameField: TPInputView!
    var surnameField: TPInputView!
    var newAvatarImage : UIImage? = nil
    var errorView : TPErrorView!
    
    @IBOutlet weak var submitButton: TPButton!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var shootPhotoButton : UIButton!
    @IBOutlet weak var imageFromLibraryButton : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.costantKeyboardTranslationRef = 200.0
        // Do any additional setup after loading the view.
        self.setDefaultBackgroundGradient()
        
        // set bar button item for password change
        let changePasswordButton = UIBarButtonItem(image: UIImage(named: "gear-icon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(changePassword))
        self.navigationItem.rightBarButtonItems = [changePasswordButton]
        
        self.avatarImageView.circleRounded()
        self.submitButton.smallRounded()
        
        self.nameField.initValues(hint: "Nome", delegate: self)
        self.surnameField.initValues(hint: "Cognome", delegate: self)
        
        // set user data
        if let user = SessionManager.currentUser
        {
            self.avatarImageView.load(user: user)
            self.nameField.setText(text: user.name)
            self.surnameField.setText(text: user.surname)
            self.userEmailLabel.text = user.email
        } else {
            // TODO: handler nel caso l'utente sia scollegato
        }
    }
    
    @IBAction func resignFirstRespondes() {
        self.nameField.resignFirstResponder()
        self.surnameField.resignFirstResponder()
    }
    
    
    func changePassword()
    {
        self.performSegue(withIdentifier: "change_password_segue", sender: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func takePhoto()
    {
        let cameraMediaType = AVMediaTypeVideo
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: cameraMediaType)
        
        switch cameraAuthorizationStatus {
        case .authorized, .notDetermined:
            self.present(self.getImagePiker(sourceType: UIImagePickerControllerSourceType.camera), animated: true, completion: nil)
            break
        case .denied, .restricted:
            let alert = UIAlertController(title: "Accesso alla fotocamera", message: "Permetti a Trivia Patente di accedere alla fotocamera nelle impostazioni del tuo dispositivo e poi riprova", preferredStyle: UIAlertControllerStyle.alert)
            let settingsAction = UIAlertAction(title: "Ho capito", style: .default) { (_) -> Void in
                let settingsUrl = URL.init(string: UIApplicationOpenSettingsURLString)
                if let url = settingsUrl {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            alert.addAction(settingsAction)
            self.present(alert, animated: true, completion: nil)
            break
        }
    }
    
    @IBAction func galleryImage()
    {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized, .notDetermined:
             self.present(self.getImagePiker(sourceType: UIImagePickerControllerSourceType.photoLibrary), animated: true, completion: nil)
            break
        case .denied, .restricted :
            let alert = UIAlertController(title: "Accesso alla libreria", message: "Permetti a Trivia Patente di accedere alla tua libreria fotografica nelle impostazioni del tuo dispositivo e poi riprova", preferredStyle: UIAlertControllerStyle.alert)
            let settingsAction = UIAlertAction(title: "Ho capito", style: .default) { (_) -> Void in
                let settingsUrl = URL.init(string: UIApplicationOpenSettingsURLString)
                if let url = settingsUrl {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            alert.addAction(settingsAction)
            self.present(alert, animated: true, completion: nil)
            break
        }
    }
    
    func getImagePiker(sourceType: UIImagePickerControllerSourceType) -> UIImagePickerController
    {
        let pickerController = UIImagePickerController()
        pickerController.navigationBar.barTintColor = Colors.primary
        pickerController.navigationBar.tintColor = UIColor.white
        pickerController.navigationBar.isTranslucent = false
        pickerController.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.white
        ]
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.sourceType = sourceType
        
        return pickerController
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let newImage = info[UIImagePickerControllerEditedImage] as? UIImage
        self.newAvatarImage = newImage
        self.avatarImageView.clear()
        self.avatarImageView.image = newImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func submitChanges()
    {
        let httpManager = HTTPManager()
        // TODO: LA FUNZIONE PIù BRUTTA CHE ESISTA NEL MONDO
        let u = SessionManager.currentUser!
        self.view.endEditing(true)
        let surnameUpdate : (() -> Void) = { _ in
//            self.startSaving()
            if ((SessionManager.currentUser!.surname == nil && self.surnameField.getText() != "")||(SessionManager.currentUser!.surname != nil && self.surnameField.getText() != SessionManager.currentUser!.surname!)) {
                httpManager.request(url: "/account/surname/edit", method: .post, params: ["surname":self.surnameField.getText()], auth: true, handler: { response in
                    self.finishedSaving()
                    if !response.success {
                        self.errorView.set(error: Strings.contact_us_error_toast)
                    } else {
                        u.surname = self.surnameField.getText()
                        SessionManager.set(user: u)
                        self.navigationController!.popViewController(animated: true)
                    }
                })
            } else {
                self.finishedSaving()
                self.navigationController!.popViewController(animated: true)
            }
        }
        let nameUpdate : (() -> Void) = { _ in
//            self.startSaving()
            if (SessionManager.currentUser!.name == nil && self.nameField.getText() != "") || (SessionManager.currentUser!.name != nil && self.nameField.getText() != SessionManager.currentUser!.name!) {
                httpManager.request(url: "/account/name/edit", method: .post, params: ["name":self.nameField.getText()], auth: true, handler: { response in
                    if !response.success {
                        self.errorView.set(error: Strings.contact_us_error_toast)
                        self.finishedSaving()
                    } else {
                        u.name = self.nameField.getText()
                        SessionManager.set(user: u)
                        surnameUpdate()
                    }
                })
            } else {
                surnameUpdate()
            }
        }
        
        self.startSaving()
        if self.newAvatarImage != nil {
            httpManager.upload(url: "/account/image/edit", method: .post, data: UIImageJPEGRepresentation(self.newAvatarImage!, Constants.avataImageRapresentationQuality)!, forHttpParam: "image", fileName: "avatar.png", mimeType: "image/png", parameters: nil, handler: { (response: TPAuthResponse) in
                if !response.success {
                    self.errorView.set(error: Strings.contact_us_error_toast)
                    self.finishedSaving()
                } else {
                    nameUpdate()
                    response.user!.savedImaged = self.newAvatarImage
                    SessionManager.set(user: response.user!)
                    self.newAvatarImage = nil
                }
            })
        } else {
            nameUpdate()
        }
    }
    
    func finishedSaving()
    {
        DispatchQueue.main.async {
            self.submitButton.stopLoading()
            self.nameField.enable()
            self.surnameField.enable()
            self.shootPhotoButton.isEnabled = true
            self.imageFromLibraryButton.isEnabled = true
        }
    }
    
    func startSaving()
    {
        DispatchQueue.main.async {
            self.errorView.clearError()
            self.submitButton.load()
            self.nameField.disable()
            self.surnameField.disable()
            self.shootPhotoButton.isEnabled = false
            self.imageFromLibraryButton.isEnabled = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameField.field:
            _ = surnameField.field.becomeFirstResponder()
            break
        case surnameField.field:
            //programmatically touch login button
            submitButton.sendActions(for: .touchUpInside)
            break
        default: break
        }
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "name_field":
                self.nameField = segue.destination as! TPInputView
                break
            case "surname_field":
                self.surnameField = segue.destination as! TPInputView
                break
            case "error_view":
                self.errorView = segue.destination as! TPErrorView
                break
            default: break
            }
        }
    }

}
