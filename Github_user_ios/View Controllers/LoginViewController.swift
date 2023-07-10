

import UIKit

class LoginViewController: UIViewController{
    // MARK: - IBOUTLETS
    @IBOutlet var field: UITextField!
    @IBOutlet var loginTableForScrolling: UITableView!
    @IBOutlet var LoginHeaderView: LoginHeaderView!
    //    @IBOutlet var LoginHeaderView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let LoginheaderView = LoginHeaderView
        loginTableForScrolling.tableHeaderView = LoginheaderView
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "logintoprofile",
                let destinationVC = segue.destination as? ProfileViewController {
                destinationVC.usernamePassedBylogin = field.text
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
