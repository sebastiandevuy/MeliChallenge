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
    private let searchBar = UISearchBar()
    private let footerView = TableFooterView()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
        NSLayoutConstraint.activate([searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                                     searchBar.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
                                     searchBar.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
                                     searchBar.heightAnchor.constraint(equalToConstant: 60)])
        searchBar.delegate = self
        
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        resultsTableView.backgroundColor = .white
        resultsTableView.tableHeaderView = UIView(frame: frame)
        resultsTableView.translatesAutoresizingMaskIntoConstraints = false
        resultsTableView.tag = Table.results.rawValue
        resultsTableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: "searchResultCell")
        resultsTableView.delegate = self
        searchResultsDataSource = UITableViewDiffableDataSource<Int, SearchResultDisplayModel>(tableView: resultsTableView) { tableView, indexPath, resultModel in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell") as? SearchResultTableViewCell else {
                return UITableViewCell()
            }
            cell.setupWithModel(resultModel)
            return cell
        }
        view.addSubview(resultsTableView)
        NSLayoutConstraint.activate([resultsTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
                                     resultsTableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
                                     resultsTableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
                                     resultsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)])
        
        suggestionsTableView.backgroundColor = .white
        suggestionsTableView.tableHeaderView = UIView(frame: frame)
        suggestionsTableView.translatesAutoresizingMaskIntoConstraints = false
        suggestionsTableView.tag = Table.suggestions.rawValue
        suggestionsTableView.delegate = self
        suggestionsTableView.register(SuggestionTableViewCell.self, forCellReuseIdentifier: "suggestionCell")
        suggestionsDataSource = UITableViewDiffableDataSource<Int, String>(tableView: suggestionsTableView) { tableView, indexPath, suggestedQuery in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "suggestionCell") as? SuggestionTableViewCell else {
                return UITableViewCell()
            }
            cell.setupWithQuery(suggestedQuery)
            return cell
        }
        view.addSubview(suggestionsTableView)
        NSLayoutConstraint.activate([suggestionsTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
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
        
        viewModel.viewState.$autoSuggestQuery.receive(on: DispatchQueue.main).sink { [weak self] query in
            guard let self = self else { return }
            self.searchBar.text = query
        }.store(in: &subscribers)
        
        viewModel.viewState.$suggestionsSnapshot.sink { [weak self] snapshot in
            guard let self = self, let snapshot = snapshot else { return }
            self.suggestionsDataSource?.apply(snapshot, animatingDifferences: false)
        }.store(in: &subscribers)
        
        viewModel.viewState.$searchResultsSnapshot.sink { [weak self] snapshot in
            guard let self = self, let snapshot = snapshot else { return }
            self.searchResultsDataSource?.apply(snapshot, animatingDifferences: true)
            self.resultsTableView.flashScrollIndicators()
        }.store(in: &subscribers)
        
        viewModel.viewState.$resultFooterDisplayType.sink { [weak self] type in
            guard let self = self else { return }
            self.footerView.setDisplayType(type)
        }.store(in: &subscribers)
    }
}

extension SearchMainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let table = Table(rawValue: tableView.tag) else { return }
        switch table {
        case .results:
            viewModel.dispatchInputAction(.didTapResult(atIndex: indexPath.row))
        case .suggestions:
            searchBar.resignFirstResponder()
            viewModel.dispatchInputAction(.didTapSuggestion(atIndex: indexPath.row))
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        guard let table = Table(rawValue: tableView.tag) else { return }
        switch table {
        case .results:
            viewModel.dispatchInputAction(.didShowResultFooter)
        case .suggestions:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let table = Table(rawValue: tableView.tag) else { return nil }
        switch table {
        case .results:
            return footerView
        case .suggestions:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30.0
    }
}

extension SearchMainViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        viewModel.dispatchInputAction(.didFocusOnSearch)
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.dispatchInputAction(.didTapCancel)
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        viewModel.dispatchInputAction(.didTapSearch)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.dispatchInputAction(.didUpdateQuery(query: searchText))
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
}

extension SearchMainViewController {
    enum Table: Int {
        case suggestions = 10
        case results = 20
    }
}
