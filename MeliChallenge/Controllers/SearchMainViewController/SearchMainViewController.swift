//
//  SearchMainViewController.swift
//  MeliChallenge
//
//  Created by Pablo Gonzalez on 5/8/21.
//

import UIKit
import Combine

class SearchMainViewController: UIViewController {
    private let viewModel: SearchMainViewModel
    private var subscribers = Set<AnyCancellable>()
    
    private let suggestionsTableView = UITableView(frame: .zero, style: .grouped)
    private let resultsTableView = UITableView(frame: .zero, style: .grouped)
    
    private var suggestionsDataSource: UITableViewDiffableDataSource<Int, String>?
    private var searchResultsDataSource: UITableViewDiffableDataSource<Int, SearchResultDisplayModel>?
    
    init(viewModel: SearchMainViewModel = SearchMainViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupViewModelBindings()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.delegate = self
        search.obscuresBackgroundDuringPresentation = false
        self.navigationItem.searchController = search
        
        resultsTableView.translatesAutoresizingMaskIntoConstraints = false
        resultsTableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: "searchResultCell")
        searchResultsDataSource = UITableViewDiffableDataSource<Int, SearchResultDisplayModel>(tableView: resultsTableView) { tableView, indexPath, resultModel in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell") as? SearchResultTableViewCell else {
                return UITableViewCell()
            }
            cell.setupWithModel(resultModel)
            return cell
        }
        view.addSubview(resultsTableView)
        NSLayoutConstraint.activate([resultsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                                     resultsTableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
                                     resultsTableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
                                     resultsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)])
        
        suggestionsTableView.translatesAutoresizingMaskIntoConstraints = false
        suggestionsTableView.register(SuggestionTableViewCell.self, forCellReuseIdentifier: "suggestionCell")
        suggestionsDataSource = UITableViewDiffableDataSource<Int, String>(tableView: suggestionsTableView) { tableView, indexPath, suggestedQuery in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "suggestionCell") as? SuggestionTableViewCell else {
                return UITableViewCell()
            }
            cell.setupWithQuery(suggestedQuery)
            return cell
        }
        view.addSubview(suggestionsTableView)
        NSLayoutConstraint.activate([suggestionsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                                     suggestionsTableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
                                     suggestionsTableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
                                     suggestionsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)])
    }
    
    private func setupViewModelBindings() {
        viewModel.viewState.$displayMode.receive(on: DispatchQueue.main).sink { [weak self] displayMode in
            guard let self = self else { return }
            switch displayMode {
            case .results:
                self.view.bringSubviewToFront(self.resultsTableView)
            case .suggestions:
                self.view.bringSubviewToFront(self.suggestionsTableView)
            }
        }.store(in: &subscribers)
        
        viewModel.viewState.$searchQuery.receive(on: DispatchQueue.main).sink { [weak self] query in
            guard let self = self else { return }
            self.navigationItem.searchController?.searchBar.text = query
        }.store(in: &subscribers)
        
        viewModel.viewState.$suggestionsSnapshot.sink { [weak self] snapshot in
            guard let self = self, let snapshot = snapshot else { return }
            self.suggestionsDataSource?.apply(snapshot, animatingDifferences: false)
        }.store(in: &subscribers)
        
        viewModel.viewState.$searchResultsSnapshot.sink { [weak self] snapshot in
            guard let self = self, let snapshot = snapshot else { return }
            self.searchResultsDataSource?.apply(snapshot, animatingDifferences: false)
        }.store(in: &subscribers)
    }
}

extension SearchMainViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        viewModel.dispatchInputAction(.didFocusOnSearch)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.dispatchInputAction(.didTapCancel)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.searchController?.isActive = false
        viewModel.dispatchInputAction(.didTapSearch)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.dispatchInputAction(.didUpdateQuery(query: searchText))
    }
}
