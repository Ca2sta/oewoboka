//
//  VocaViewController.swift
//  oewoboka
//
//  Created by Lee on 2023/09/26.
//

import UIKit
import SnapKit
import CoreData

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
    var coreDataManager = VocabularyRepository.shared
    let vocabularyID: NSManagedObjectID
    
    init(vocabularyID: NSManagedObjectID) {
        self.vocabularyID = vocabularyID
        print("!!!init\(vocabularyID)")
        coreDataManager.addWord(vocabularyEntityId: vocabularyID, word: Word(english: "hi", korea: "안녕", isMemorize: false, isBookmark: false))
        coreDataManager.addWord(vocabularyEntityId: vocabularyID, word: Word(english: "bye", korea: "ㅂㅇ", isMemorize: false, isBookmark: false))
        coreDataManager.addWord(vocabularyEntityId: vocabularyID, word: Word(english: "happy", korea: "^^", isMemorize: false, isBookmark: false))
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        return coreDataManager.fetch(id: vocabularyID)!.words!.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VocaTableViewCell.identifier, for: indexPath) as! VocaTableViewCell
        guard let voca = coreDataManager.fetch(id: vocabularyID)?.words?.array as? [WordEntity] else {return UITableViewCell()}
        cell.bind(data: voca[indexPath.row])
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
