//
//  AnswerViewController.swift
//  oewoboka
//
//  Created by 김도현 on 2023/09/29.
//

import UIKit
import SnapKit

class AnswerViewController: UIViewController {
    
    private let answerTopView: TopView = TopView(title: "정답 보기")
    private let answerTableView: UITableView = UITableView()
    private let answerBottomView: BottomView = BottomView()
    
    private var isDismissTouch: Bool = false
    private let originY: CGFloat = Constant.screenHeight * 0.2
    let words: [Word]
    
    init(words: [Word]) {
        self.words = words
        super.init(nibName: nil, bundle: nil)
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
        cell.numberLabel.text = "\(indexPath.row)"
        cell.vocabularyTitleLabel.text = word.vocabularyTitle
        cell.englishWordLabel.text = word.english
        cell.koreaWordLabel.text = word.korea
        return cell
    }
}

// MARK: TouchEvent
extension AnswerViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let window = UIApplication.shared.windows.first,
              let location = touches.first?.location(in: window),
              location.y <= originY + 40 else { return }
        isDismissTouch = true
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let window = UIApplication.shared.windows.first
        guard let location = touches.first?.location(in: window),
            isDismissTouch else { return }
        guard location.y > originY else {
            view.frame.origin.y = originY
            return
        }
        view.frame.origin.y = location.y
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard isDismissTouch,
              let window = UIApplication.shared.windows.first,
              let touch = touches.first else { return }
        
        let previousLocation = touch.previousLocation(in: window)
        let location = touch.location(in: window)
        
        let dismissY = originY + 200
        let isFasterDown = (location.y - previousLocation.y) >= 7
        
        if location.y >= dismissY { dismiss(animated: true) }
        else if isFasterDown { dismiss(animated: true) }
        else {
            isDismissTouch = false
            UIView.animate(withDuration: 0.1) {
                self.view.frame.origin.y = self.originY
            }
        }
    }
}
