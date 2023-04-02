//
//  LoginViewController.swift
//  homeWork_1
//
//  Created by User on 30.09.2018.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var customIndicator: CustomIndicator!
    
    
    @IBOutlet weak var labelLogin: UITextField!
    @IBOutlet weak var labelPass: UITextField!
    
    
    private var login = "login"
    private var pass = "pass"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCustoms()
    }
    
    
    private func setCustoms() {
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.tintColor = UIColor.white
        navigationBarAppearance.barTintColor = UIColor.vkColor.main
    }
    
    
    @IBAction func btnLoginClicked(_ sender: Any) {
        tryLogin()
    }
    
    
//    private func startAnimate() {
//        let rect = viewAnimate.frame
//        UIView.animateKeyframes(withDuration: 0.8, delay: 0, options: [], animations: {
//            UIView.addKeyframe(withRelativeStartTime: 0,
//                               relativeDuration: 0,
//                               animations: {
//                                self.viewAnimate.layer.anchorPoint = CGPoint(x: 1, y: 0)
//                                self.viewAnimate.frame = rect
//                                self.viewAnimate.transform = CGAffineTransform(rotationAngle: CGFloat(-90.0).toRadians())
//
//            })
//            UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.7, animations: {
//                self.viewAnimate.transform = CGAffineTransform(rotationAngle: CGFloat(0.0).toRadians())
//            })
//        }, completion: { completition in
////            UIView.animate(withDuration: 0.2, animations: {
////                self.viewAnimate.transform = CGAffineTransform(rotationAngle: CGFloat(0).toRadians())
////            })
//            })
//
//    }
    
    
    private func tryLogin() {
        var isAuth = true
        if (labelLogin.text?.count == 0 || labelPass.text?.count == 0) {
            isAuth = false
            showAlert(text: "Поле Логин и Пароль должны быть заполнены")
        }
        if (labelLogin.text != login || labelPass.text != pass) {
            isAuth = false
            showAlert(text: "Неверно введены Логин или Пароль")
        }
        if (isAuth) {
            prepareShowMain()
        }
    }
    
    private func prepareShowMain() {
        customIndicator.isHidden = false
        customIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.customIndicator.isHidden = true
            self.customIndicator.stopAnimating()
            self.performSegue(withIdentifier: "showMain", sender: nil)
        }
    }
    
    
    private func showAlert(text: String) {
        let alert = UIAlertController(title: "Ошибка входа", message: text, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Понятно", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    
    @IBAction func unwindToLogin(segue:UIStoryboardSegue) {
        
    }
    
}
