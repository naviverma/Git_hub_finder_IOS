//
//  RepoViewController.swift
//  Github_user_ios
//
//  Created by Navdeep on 15/07/2023.
//

import UIKit
import Foundation
import AVKit

class RepoViewController: UIViewController {
    
    @IBOutlet var fileImage: UIImageView!
    @IBOutlet var ImageVIewHeader: UIView!
    @IBOutlet var normalHeader: UIView!
    @IBOutlet var textViewEditor: UITextView!
    @IBOutlet var filetable: UITableView!
    @IBOutlet var textView: UIView!
    var files:[GitRepoFiles] = []
    var usernamePassed:String!
    var reponamePassed:String!
    var additionalPassed:String!
    var activity = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activity.hidesWhenStopped = true
        activity.center = view.center
        view.addSubview(activity)
        
        self.title = additionalPassed
        filetable.dataSource = self
        filetable.delegate = self
        
        filetable.register(UINib(nibName: "TableViewCellContri", bundle: nil), forCellReuseIdentifier: "CustomCell")
        
        activity.startAnimating()
        ApiHandling.fetchRepoFiles(username: usernamePassed!, repoName: reponamePassed!,additional: additionalPassed){
            (result,error) in
            DispatchQueue.main.async {
                if result != nil{
                    let headerView = self.normalHeader
                    self.filetable.tableHeaderView = headerView
                    self.files = result!
                    self.filetable.reloadData()
                    self.activity.stopAnimating()
                }
                else{
                    ApiHandling.fetchCode(username: self.usernamePassed, repoName: self.reponamePassed,additional: self.additionalPassed){
                        (data,error) in
                        if let base64String = data?.content?.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "\n", with: "")
                            {
                            guard let dataDec = Data(base64Encoded : base64String) else {
                                print("Failed to decode base64String to Data")
                                return
                            }
                            if self.additionalPassed.hasSuffix(".mp4"){
                                if let decodedString = Data(base64Encoded: base64String){
                                    var tempVideoUrl:URL?
                                    do{
                                        let directory = FileManager.default.temporaryDirectory
                                        tempVideoUrl = directory.appendingPathComponent(UUID().uuidString + ".mp4")
                                        try decodedString.write(to: tempVideoUrl!)
                                    }
                                    catch{
                                        print("couldn't write to file")
                                    }
                                    if let videoUrl = tempVideoUrl,FileManager.default.fileExists(atPath: videoUrl.path){
                                        let player = AVPlayer(url: videoUrl)
                                        let playerViewController = AVPlayerViewController()
                                        playerViewController.player = player
                                        self.present(playerViewController,animated: true){
                                            player.play()
                                        }
                                    }
                                }
                            }
                            else{
                            if let image = UIImage(data: dataDec) {
                                DispatchQueue.main.async {
                                    let headerview = self.ImageVIewHeader
                                    self.filetable.tableHeaderView = headerview
                                    self.fileImage.image = image
                                    self.filetable.reloadData()
                                    self.activity.stopAnimating()
                                }
                            }
                            else if let decodedString = String(data: dataDec, encoding: .utf8){
                                    print(decodedString)
                                    let targetWords = ["[", "{", "}", ".", "#","]",":","=","@","!",",","\"","<",">","/",";","(",")"]
                                    let attributedString = NSMutableAttributedString(string: decodedString)
                                    for target in targetWords {
                                        let ranges = decodedString.ranges(of: target)
                                        for range in ranges {
                                            attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: NSRange(range, in: decodedString))
                                        }
                                    }
                                    DispatchQueue.main.async {
                                        let headerview = self.textView
                                        self.filetable.tableHeaderView = headerview
                                        self.textViewEditor.attributedText = attributedString
                                        self.filetable.reloadData()
                                        self.activity.stopAnimating()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "filetofile",
           let destinationVC = segue.destination as? RepoViewController,
           let cell = sender as? TableViewCellContri
        {
            destinationVC.usernamePassed = self.usernamePassed
            destinationVC.reponamePassed = self.reponamePassed
            destinationVC.additionalPassed = additionalPassed + "/\(cell.contriName.text ?? "N/A")"
        }
    }

}
extension RepoViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = filetable.dequeueReusableCell(withIdentifier: "CustomCell",for: indexPath) as! TableViewCellContri
        cell.contriName.text = files[indexPath.row].name
        cell.contriImage.image = UIImage(named: "github.png")
        cell.contriNo.text = files[indexPath.row].path
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return filetable.frame.size.height
    }
}

extension RepoViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = filetable.cellForRow(at: indexPath)
        performSegue(withIdentifier: "filetofile", sender: cell)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension String {
    func ranges(of substring: String) -> [Range<String.Index>] {
        var ranges: [Range<String.Index>] = []
        var start: String.Index? = startIndex
        
        while start != nil && start! < endIndex {
            let range: Range<String.Index> = start!..<endIndex
            if let newRange = self.range(of: substring, options: [], range: range, locale: nil) {
                ranges.append(newRange)
                start = newRange.upperBound
            } else {
                break
            }
        }
        return ranges
    }
}
