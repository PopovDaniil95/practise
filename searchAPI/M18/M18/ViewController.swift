//
//  ViewController.swift
//  M18
//
//  Created by Даниил Попов on 05.01.2023.
//

import UIKit

class ViewController: UIViewController {

    let networkService = NetworkService()
    let cellIdentifier = "Cell"
    let searchController = UISearchController(searchResultsController: nil)
    var imdbFilm: ImdbFilm? = nil
    private var timer: Timer?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        return tableView
    }()
    
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    private func setupViews() {
        view.addSubview(tableView)
    }
    
    
    private func setupConstrainst() {

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        setupViews()
        setupSearchBar()
        setupConstrainst()
        tableView.rowHeight = 100
    }
}


// MARK: Extension TableViewCell

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let film = imdbFilm?.results[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = film?.title
        content.secondaryText = film?.description
        
        func downloadImage() -> UIImage {
            let image = UIImage(data: try! Data(contentsOf: URL(string: film!.image)!))
            return image ?? UIImage()
        }

        content.image = downloadImage()
        cell.contentConfiguration = content
        return cell
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imdbFilm?.results.count ?? 0
    }
    
}

// MARK: Extension SearchBar

extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let urlString = "https://imdb-api.com/en/API/Search/k_il0e4iky/\(searchText)"
        
        
        timer?.invalidate() 
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.networkService.request(urlString: urlString) { [weak self] (result) in
                switch result {
                    
                case .success(let imdbFilm):
                    self?.imdbFilm = imdbFilm
                    self?.tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        })

    }
    
}
