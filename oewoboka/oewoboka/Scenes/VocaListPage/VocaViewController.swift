//
//  VocaViewController.swift
//  oewoboka
//
//  Created by Lee on 2023/09/26.
//

import UIKit
import SnapKit

class VocaViewController: UIViewController {
    let vocaTableView = UITableView()
    let vocaSearchBar = UISearchBar()
    let allLabel : UILabel = {
        let label = UILabel()
        label.text = "전체 단어수: 0"
        return label
    }()
    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: VocaViewController.self, action: #selector(addButtonTapped))
    var totalWordCount = 0
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일 HH:mm"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        view.backgroundColor = .systemBackground
        vocaTableView.dataSource = self
        vocaTableView.delegate = self
        vocaTableView.register(VocaTableViewCell.self, forCellReuseIdentifier: VocaTableViewCell.identifier)
        navigationItem.titleView = vocaSearchBar
        vocaSearchBar.delegate = self

    }
    func setUpUI() {
        view.addSubview(vocaTableView)
        view.addSubview(allLabel)
        navigationItem.rightBarButtonItem = addButton

        addButton.target = self
        addButton.action = #selector(addButtonTapped)
        
        allLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(vocaTableView.snp.top)
        }
        vocaTableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
        }
    }
    
    @objc func addButtonTapped() {
        totalWordCount += 1
        allLabel.text = "전체 단어수: \(totalWordCount)"
        print("testPlusButton")
        vocaTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {

            print("검색어: \(searchText)")
        }
        
        vocaTableView.reloadData()
        
    }
    
}
extension VocaViewController: UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return totalWordCount
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VocaCell", for: indexPath) as! VocaTableViewCell
        let currentDate = Date() 
        let dateString = dateFormatter.string(from: currentDate)
        
        cell.dateLabel.text = "\((indexPath.row) + 1). \(dateString)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func updateSearchResults(for searchController: UISearchController) {
        print("text")
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedVocaViewController = SelectedVocaViewController()
        
        self.navigationController?.pushViewController(selectedVocaViewController, animated: true)
    }
}
