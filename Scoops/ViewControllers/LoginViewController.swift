//
//  LoginViewController.swift
//  Scoops
//
//  Created by Jose Sanchez Rodriguez on 6/4/17.
//  Copyright © 2017 COM. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate {

    //MARK: - Typealias
    typealias actionUserCmd = (_ : String, _ : String) -> Void
    
    //MARK: - Enums
    enum ActionUser: String {
        case toLogin = "Login"
        case toSignIn = "Registrar nuevo usuario"
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Actions
    @IBAction func doLogin(_ sender: Any) {
    }
    
    //MARK: - Actions
    // Función que muestra el dialogo de Login y captura las credenciales de usuario
    func showUserLoginDialog(withCommand actionCmd: @escaping actionUserCmd, userAction: ActionUser) {
        // Se instancia el controlador de alertas
        let alertController = UIAlertController(title: "FirebaseWithLove", message: userAction.rawValue, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: userAction.rawValue, style: .default, handler: { (action) in
            let eMailTxt = (alertController.textFields?[0])! as UITextField
            let passTxt = (alertController.textFields?[1])! as UITextField
            
            // Se comprueba si algo ha salido mal
            if (eMailTxt.text?.isEmpty)!, (passTxt.text?.isEmpty)! {
                // No continuar y lanzar error
            } else {
                actionCmd(eMailTxt.text!, passTxt.text!)
            }
        }))
        
        // Se agrega un botón para el Cancel
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            
        }))
        
        // Se agregan los TextField al alert añadiendolos con Placeholder por defecto
        // TextField de cuenta de usuario
        alertController.addTextField { (txtField) in
            txtField.placeholder = "Por favor, escriba su mail"
            txtField.textAlignment = .natural
        }
        
        //TextField de pass de usuario
        alertController.addTextField { (txtField) in
            txtField.placeholder = "Por favor, escriba su password"
            txtField.textAlignment = .natural
            txtField.isSecureTextEntry = true
        }
        
        // Se muestra la alerta
        self.present(alertController, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
