import UIKit

class LoginViewController: UIViewController{
    // MARK: - IBOUTLETS
    @IBOutlet var field: UITextField!
    @IBOutlet var loginTableForScrolling: UITableView!
    @IBOutlet var LoginHeaderView: LoginHeaderView!
    
    var flag:Bool = true//this is flag set to handle cashed data
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let LoginheaderView = LoginHeaderView
        loginTableForScrolling.tableHeaderView = LoginheaderView
    }
    
    func updateNil(){
        ProfileViewController.initialInstance = nil
    }
    
    @IBAction func findPressed(_ sender: Any) {
        
        let text = field.text?.trimmingCharacters(in: .whitespacesAndNewlines)//this is used to remove leading and trailing spaces and newlines
        if text?.isEmpty == true{
            let alert = UIAlertController(title: "Error", message: "Enter any username", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert,animated: true,completion: nil)
        }else{
            ApiHandling.fetchUser(username: text!){
                (result,error) in
                DispatchQueue.main.async {
                    if error == "wrongUsername" {
                        let alert = UIAlertController(title: "Error", message: "USERNAME NOT FOUND", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
                        self.present(alert,animated: true,completion: nil)
                    }
                    else if error == "offline"{
                        self.flag = false
                        self.performSegue(withIdentifier: "logintoprofile", sender: self)
                    }
                    else{
                        self.flag = true
                        self.performSegue(withIdentifier: "logintoprofile", sender: self)
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if flag == true{
            if segue.identifier == "logintoprofile",
               let destinationVC = segue.destination as? ProfileViewController {
                destinationVC.usernamePassedBylogin = field.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            self.updateNil()
        }
        if flag == false{
            if segue.identifier == "logintoprofile",
               let destinationVC = segue.destination as? ProfileViewController {
                destinationVC.usernamePassedBylogin = field.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            self.updateNil()
        }
    }
}

extension LoginViewController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LoginCellIdentifier", for: indexPath)
                return cell
    }
}
