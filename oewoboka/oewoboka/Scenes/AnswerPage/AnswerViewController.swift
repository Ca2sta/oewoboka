//
//  AnswerViewController.swift
//  oewoboka
//
//  Created by 김도현 on 2023/09/29.
//

import UIKit
import SnapKit

class AnswerViewController: BottomSheetViewController {
    
    private let answerTopView: TopView = TopView(title: "정답 보기")
    private let answerTableView: UITableView = UITableView()
    private let answerBottomView: BottomView = BottomView()
    
    var words: [Word]
    
    init(words: [Word]) {
        self.words = words
        super.init(originY: Constant.screenHeight * 0.2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

}

// MARK: UI Init
private extension AnswerViewController {
    func setup() {
        mainViewSetup()
        addView()
        tableViewSetup()
        topViewSetup()
        bottomViewSetup()
        autoLayoutSetup()
    }
    
    func mainViewSetup() {
        view.layer.cornerRadius = 15
        view.backgroundColor = .white
    }
    
    func addView() {
        view.addSubview(answerTopView)
        view.addSubview(answerTableView)
        view.addSubview(answerBottomView)
    }
    
    func tableViewSetup() {
        answerTableView.dataSource = self
        answerTableView.delegate = self
        answerTableView.register(AnswerTableViewCell.self, forCellReuseIdentifier: AnswerTableViewCell.identifier)
        answerTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func topViewSetup() {
        answerTopView.closeButtonClickHandler = { [weak self] in
            self?.dismiss(animated: true)
        }
    }
    
    func bottomViewSetup() {
        let answerWords = words.filter { $0.isMemorize }
        answerBottomView.unBookMarkHandler = { [weak self] in
            guard let self else { return }
            for word in answerWords {
                guard let wordIndex = words.firstIndex(where: { $0.id == word.id }) else { continue }
                self.words[wordIndex].isBookmark = false
            }
            self.answerTableView.reloadData()
        }
        
        let noAnswerWords = words.filter { $0.isMemorize == false }
        answerBottomView.bookMarkHandler = { [weak self] in
            guard let self else { return }
            for word in noAnswerWords {
                guard let wordIndex = words.firstIndex(where: { $0.id == word.id }) else { continue }
                self.words[wordIndex].isBookmark = true
            }
            self.answerTableView.reloadData()
        }
    }
    
    func autoLayoutSetup() {
        let safeArea = view.safeAreaLayoutGuide
        answerTopView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        answerTableView.snp.makeConstraints { make in
            make.top.equalTo(answerTopView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(answerBottomView.snp.top)
        }
        answerBottomView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(safeArea)
        }
    }
    
}

// MARK: TableView

extension AnswerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AnswerTableViewCell.identifier, for: indexPath) as? AnswerTableViewCell else { return UITableViewCell() }
        let word = words[indexPath.row]
        cell.numberLabel.text = "\(indexPath.row + 1)."
        cell.vocabularyTitleLabel.text = word.vocabularyTitle
        cell.englishWordLabel.text = word.english
        cell.koreaWordLabel.text = word.korea
        cell.bookMarkButton.isSelected = word.isBookmark
        cell.wordBookmarkUpdate = { [weak self] isSelected in
            guard let self else { return }
            self.words[indexPath.row].isBookmark = isSelected
        }
        return cell
    }
}
