//
//  ViewController.swift
//  NewsApp
//
//  Created by Karolina Sulik on 25.03.22.
//

import UIKit

class ViewController: UIViewController {

    enum Section {
        case main
    }
    
    private let tableView = UITableView()
    var dataSource: UITableViewDiffableDataSource<Section, Article>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureRefreshControl()
        configureTableView()
        configureDataSource()
        updateNewsItems()
    }
    
    
    private func configureRefreshControl(){
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(updateNewsItems), for: .valueChanged)
    }
    
    
    @objc
    func updateNewsItems() {
        NetworkManager.shared.getNewsItems(completion: { (result) in
            switch result {
            case .success(let newsResponse):

                //self.data = newsResponse.articles
                DispatchQueue.main.async {
                    self.updateData(articles: newsResponse.articles)
                }
                
            case .failure(let error):
                print(error.rawValue)
            }
            
            DispatchQueue.main.async {
                self.tableView.refreshControl?.endRefreshing()
            }
        })
    }
    
    private func configureVC() {
        view.backgroundColor = .systemBackground
        title = "Nachrichten"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
        
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.pinToEdges(of: view)
        
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.reuseID)
        tableView.delegate = self
    }
    
        
    func configureDataSource() {
        dataSource = UITableViewDiffableDataSource <Section, Article>(
            tableView: tableView,
            cellProvider: { (tableView, indexPath, article) -> UITableViewCell? in
                
                let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.reuseID, for: indexPath) as? NewsTableViewCell
                
                cell?.setCell(article: article)
                
                return cell
        })
    }
    
        
    func updateData(articles: [Article]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Article>()
        snapshot.appendSections([.main])
        snapshot.appendItems(articles, toSection: .main)
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
}


extension ViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var snapshot = self.dataSource.snapshot()
        snapshot.deleteItems([snapshot.itemIdentifiers[indexPath.row]])
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
}
