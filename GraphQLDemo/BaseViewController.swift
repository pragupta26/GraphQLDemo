//
//  BaseViewController.swift
//  GraphQLDemo
//
//  Created by Pratibha Gupta on 23/03/20.
//  Copyright © 2020 Sapient. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func showLoader() {
         self.activityIndicator.startAnimating()
     }
     
     func hideLoader() {
         self.activityIndicator.stopAnimating()
     }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
