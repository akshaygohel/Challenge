//
//  TDListViewController.swift
//  TDChallenge
//
//  Created by Akshay Gohel on 2018-09-28.
//  Copyright © 2018 Akshay Gohel. All rights reserved.
//

import UIKit
import SDWebImage

class TDListViewController: UITableViewController {
    
    lazy var viewModel: TDListViewModel = {
        return TDListViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.layoutViewUI()
        self.setupViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !self.viewModel.isFetchedOnce {
            self.viewModel.fetchSearchResultsFromWeb()
        }
    }
    
    // MARK: -
    
    private func layoutViewUI() {
        self.navigationItem.title = "Searched Query"
        
        self.tableView.estimatedRowHeight = 80.0
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    func setupViewModel() {
        self.viewModel.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert( message )
                }
            }
        }

        self.viewModel.updateLoadingIndicatorClosure = { [weak self] () in
            let isFetching = self?.viewModel.isFetching ?? false
            if isFetching {
                self?.showHud(withText: "Fetching Data...", animated: true, withIndicator: true)
            } else {
                self?.hideHud(animated: true)
            }
        }

        viewModel.reloadTableViewClosure = { [weak self] () in
            self?.viewModel.isFetchedOnce = true
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension TDListViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as? TDListTableViewCell else {
            fatalError("Cell not exists in storyboard")
        }
        
        cell.titleLabel.text = ""
        cell.subTitleLabel.text = ""
        cell.favIconImageView.sd_cancelCurrentImageLoad()
        cell.favIconImageView.image = UIImage.init(named: "DummyAppIcon")
        
        let cellViewModel = viewModel.getCellViewModel(atIndexPath: indexPath)
        
        cell.titleLabel.text = cellViewModel.titleText
        cell.subTitleLabel.text = cellViewModel.subTitleText
        if let imageUrl = cellViewModel.imageUrl, imageUrl.count > 0 {
            cell.favIconImageView.sd_setImage(with: URL(string: imageUrl), completed: nil)
        }
        
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()

        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        self.viewModel.userTappedTopic(atIndexPath: indexPath)
        if self.viewModel.shouldAllowSegue {
            return indexPath
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension TDListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? TDDetailWebViewController, let topic = self.viewModel.selectedTopic {
            viewController.title = topic.text
            viewController.topicUrl = topic.firstURL
        }
    }
}
