//
//  LoginViewController.swift
//  GITHUB_paytm
//
//  Created by Navdeep on 29/06/2023.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var field: UITextField!
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "logintoprofile",
                let destinationVC = segue.destination as? MainViewController {
                destinationVC.user_ka_naam = field.text
            }
        }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
