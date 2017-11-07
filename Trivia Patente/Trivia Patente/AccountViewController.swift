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

class AccountViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var avatarImageView: UIImageView!
    var nameField: TPInputView!
    var surnameField: TPInputView!
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var userEmailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        self.avatarImageView.image = newImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitChanges()
    {
    
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
            default: break
            }
        }
    }

}
