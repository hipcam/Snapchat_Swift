//
//  IniciarSesionViewController.swift
//  Lab10Snapchat
//
//  Created by Fernanda  on 24/10/18.
//  Copyright © 2018 Fernanda Alvarado. All rights reserved.
//

import UIKit

import FirebaseAuth
import FirebaseDatabase

class IniciarSesionViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func IniciarSesionTapped(_ sender: Any) {
        FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user , error) in
            print("Intentamos iniciar sesión")
            if(error != nil){
                FIRAuth.auth()?.createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: { (user, error) in
                    
                    print("Intentamos crear un usuario")
                    if error != nil {
                        print("tenemos el siguiente error: \(String(describing: error))")
                    }else{
                        print("El usuario fue creado exitosamente")
                        FIRDatabase.database().reference().child("users").child((user?.uid)!).child("email").setValue(user?.uid)
                        self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
                    }
                })            } else {
                print("Inicio de sesion")
                self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
            }
        })
    }

}

