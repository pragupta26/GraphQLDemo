//
//  LaunchListViewController.swift
//  GraphQLDemo
//
//  Created by Pratibha Gupta on 20/03/20.
//  Copyright © 2020 Sapient. All rights reserved.
//

import UIKit
import Apollo

class LaunchListViewController: BaseViewController {
    
    var launches = [LaunchListQuery.Data.Launch.Launch]()
    private var lastConnection: LaunchListQuery.Data.Launch?
    private var activeRequest: Cancellable?
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.loadData()
    }
     
    func loadData() {
        self.showLoader()
        self.activeRequest = Network.shared.apollo.fetch(query: LaunchListQuery(cursor: nil)) { [weak self] result in
           
            self?.hideLoader()
            guard let self = self else {
                return
            }
            
            self.activeRequest = nil
            defer {
                self.tableView.reloadData()
            }
            
            switch result {
            case .success(let graphQLResult):
                if let launchConnection = graphQLResult.data?.launches {
                    self.lastConnection = launchConnection
                    self.launches.append(contentsOf: launchConnection.launches.compactMap { $0 })
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
    
}
// MARK: - Table View

extension LaunchListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.launches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let launch = self.launches[indexPath.row]
        cell.textLabel?.text = launch.mission?.name
        cell.detailTextLabel?.text = launch.site
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "LaunchDetailsViewController") as? LaunchDetailsViewController else {
            return
        }
        detailVC.graphQLId = self.launches[indexPath.row].id
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}


