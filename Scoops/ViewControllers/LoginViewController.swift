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

class LoginViewController: UIViewController,GIDSignInUIDelegate {

    //MARK: - Properties
    var handle: FIRAuthStateDidChangeListenerHandle!

    //MARK: - Typealias
    typealias actionUserCmd = (_ : String, _ : String) -> Void
    
    //MARK: - Enums
    enum ActionUser: String {
        case toLogin = "Login"
        case toSignIn = "Registrar nuevo usuario"
    }
    
    //MARK: - Outlets
    @IBOutlet weak var googleBtnSignIn: UIButton!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userimage: UIImageView!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Se indica que el botón de Login con Google va a ser el que tenga el control del delegado de GoogleID
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Se añade un listener de autenticación para hacer Login
        handle = FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            if let _ = FIRAuth.auth()?.currentUser {
                print("******* El mail del usuario logado es:\(user?.email ?? "")")
                // Se obtiene la información del usuario
                self.getUserInfo(user)
            } else {
                self.getUserInfo(user)
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Actions
    // Acción que se ejecuta cuando se pulsa el botón Login
    @IBAction func doLoginEmail(_ sender: Any) {
        // Se comprueba si hay un usuario logado y si lo hay, se desloguea
        makeLogout()
        
        // Se muestra el Dialog de Login
        showUserLoginDialog(withCommand: login, userAction: .toLogin)
    }

    // Acción que se ejecuta cuando se pulsa el botón Login con Google
    @IBAction func doLoginGoogle(_ sender: Any) {
        // Se comprueba si hay un usuario logado y si lo hay, se desloguea
        makeLogout()
        
        // Se dispara el flujo de Google con GoogleID
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func doLoginAnonymous(_ sender: Any) {
        // Se comprueba si hay un usuario logado y si lo hay, se desloguea
        makeLogout()
        
        // Se loguea con un usuario Anónimo
        FIRAuth.auth()?.signInAnonymously(completion: { (user, error) in
            if let _ = error {
                print("Ha ocurrido un error al loguearse con un usuario Anónimo")
                return
            }
            print(user?.uid ?? "")
        })
    }
    
    // Acción que se ejecuta cuando se pulsa el botón Logout
    @IBAction func doLogout(_ sender: Any) {
        makeLogout()
    }
    
    //MARK: - Functions
    // Función que muestra el dialogo de Login y captura las credenciales de usuario
    func showUserLoginDialog(withCommand actionCmd: @escaping actionUserCmd, userAction: ActionUser) {
        // Se instancia el controlador de alertas
        let alertController = UIAlertController(title: constants.AppName, message: userAction.rawValue, preferredStyle: .alert)
        
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
        alertController.addAction(UIAlertAction(title: constants.PushAlertLoginActionCancel, style: .default, handler: { (action) in
            
        }))
        
        // Se agregan los TextField al alert añadiendolos con Placeholder por defecto
        // TextField de cuenta de usuario
        alertController.addTextField { (txtField) in
            txtField.placeholder = constants.PushAlertLoginActionRequireEmail
            txtField.textAlignment = .natural
        }
        
        //TextField de pass de usuario
        alertController.addTextField { (txtField) in
            txtField.placeholder = constants.PushAlertLoginActionRequirePass
            txtField.textAlignment = .natural
            txtField.isSecureTextEntry = true
        }
        
        // Se muestra la alerta
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Función que realiza el Login del usuario. Si este no existe, lo crea
    fileprivate func login(_ name: String, andPass pass: String) {
        FIRAuth.auth()?.signIn(withEmail: name, password: pass, completion: { (user, error) in
            
            // Se comprueba si algo ha salido mal
            if let _ = error {
                // Ha ocurrido un error
                print("Tenemos un error -> \(error?.localizedDescription ?? ""))")
                // Se crea el usuario
                FIRAuth.auth()?.createUser(withEmail: name, password: pass, completion: { (user, error) in
                    
                    // Se comprueba si algo ha salido mal
                    if let _ = error {
                        print("Tenemos un error -> \(error?.localizedDescription ?? ""))")
                        return
                    }
                })
                return
            }
            print("user: \(user?.email! ?? "")")
        })
    }
    
    // Función que desloguea el usuario conectado
    fileprivate func makeLogout() {
        // Se valida si hay un usuario logado
        if let _ = FIRAuth.auth()?.currentUser {
            // Hay un usuario logado, por lo que se procede a hacer el Logout
            do {
                // Se hace Logout de Firebase
                try FIRAuth.auth()?.signOut()
                // Se hace Logout de GoogleID
                GIDSignIn.sharedInstance().signOut()
                self.getUserInfo(nil as FIRUser!)

            } catch let error {
                // Algo ha ido mal
                print(error)
            }
        } else {
            self.getUserInfo(nil as FIRUser!)
        }
    }
    
    // Método que obtiene parte de la información del usuario Logado
    func getUserInfo(_ user: FIRUser!) {
        // Se comprueba que el usuario no llegue vacío y no sea un usuario anónimo
        if let _ = user,
            !user.isAnonymous {
            // El usuario es correcto
            // Se obtiene el eMail del usuario
            //
            username.text = user?.displayName
            self.title = user?.displayName
            // Se consulta si el usuario tiene foto de perfil
            if let picProfile = user.photoURL as URL! {
                // Se sincroniza la imagen con la vista para mostrarla
                userimage.imageFromServerURL(urlString: picProfile.absoluteString)
            }
        } else {
            // Se inicializan los valores
            username.text = ""
            self.title = ""
            userimage.imageFromServerURL(urlString: "")
        }
    }
    
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == constants.launchWithLogged {
            let controller = (segue.destination as! UINavigationController).topViewController as! MainTimeLine
            controller.navigationItem.leftItemsSupplementBackButton = true
        }
    }
}
