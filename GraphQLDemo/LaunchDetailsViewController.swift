//
//  LaunchDetailsViewController.swift
//  GraphQLDemo
//
//  Created by Pratibha Gupta on 23/03/20.
//  Copyright © 2020 Sapient. All rights reserved.
//

import UIKit
import Apollo

class LaunchDetailsViewController: BaseViewController {
    
    @IBOutlet private var missionPatchImageView: UIImageView!
    @IBOutlet private var missionNameLabel: UILabel!
    @IBOutlet private var rocketNameLabel: UILabel!
    @IBOutlet private var launchSiteLabel: UILabel!
    
    var graphQLId: GraphQLID?
    private var activeRequest: Cancellable?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadData()
        // Do any additional setup after loading the view.
    }
    
    func loadData() {
        self.showLoader()
        self.activeRequest = Network.shared.apollo.fetch(query: LaunchDetailsQuery(id: graphQLId!)) { [weak self] result in
            self?.hideLoader()
            guard let self = self else {
                return
            }
            
            self.activeRequest = nil
            
            switch result {
            case .success(let graphQLResult):
                if let launch = graphQLResult.data?.launch {
                    self.missionNameLabel.text = launch.mission?.name
                    self.rocketNameLabel.text = launch.rocket?.name
                    self.launchSiteLabel.text = launch.site
                }
                if let errors = graphQLResult.errors {
                    let message = errors
                               .map { $0.localizedDescription }
                               .joined(separator: "\n")
                    print("Errors: \(message)")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
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
