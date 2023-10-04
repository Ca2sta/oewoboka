//
//  AddVocabularyViewController.swift
//  oewoboka
//
//  Created by 김도현 on 2023/09/25.
//

import UIKit

class AddWordViewController: UIViewController {

    private let englishWordSearchField = UITextField()
    private let koreanMeaningSearchField = UITextField()
    private let wordSaveNotificationView = WordSaveNotificationView()
    
    private let repository: VocabularyRepository = VocabularyRepository.shared
    private let selectVocabularyView = SelectVocabularyButton()
    private var vocabulary: VocabularyEntity?
    
    init(vocabulary: VocabularyEntity) {
        self.vocabulary = vocabulary
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        vocabularyButtonSetup()
        saveNotificationViewSetup()
        navigationSetup()
        textFieldSetup()
    }

    private func setupUI() {
        view.backgroundColor = .white

        let englishLabel = UILabel()
        englishLabel.text = "English"
        view.addSubview(englishLabel)

        englishWordSearchField.borderStyle = .roundedRect
        englishWordSearchField.placeholder = "단어를 입력해주세요(필수)"
        view.addSubview(englishWordSearchField)
        
        let koreanLabel = UILabel()
        koreanLabel.text = "Korean"
        view.addSubview(koreanLabel)

        koreanMeaningSearchField.borderStyle = .roundedRect
        koreanMeaningSearchField.placeholder = "의미를 입력해주세요(필수)"
        view.addSubview(koreanMeaningSearchField)
        
        view.addSubview(wordSaveNotificationView)
        wordSaveNotificationView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        englishLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalTo(view).offset(20)
        }

        englishWordSearchField.snp.makeConstraints { make in
            make.top.equalTo(englishLabel.snp.bottom).offset(10)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
        }

        koreanLabel.snp.makeConstraints { make in
            make.top.equalTo(englishWordSearchField.snp.bottom).offset(20)
            make.leading.equalTo(view).offset(20)
        }

        koreanMeaningSearchField.snp.makeConstraints { make in
            make.top.equalTo(koreanLabel.snp.bottom).offset(10)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
        }
    }
    
    private func textFieldSetup() {
        englishWordSearchField.delegate = self
        koreanMeaningSearchField.delegate = self
    }
    
    private func vocabularyButtonSetup() {
        selectVocabularyView.addTarget(self, action: #selector(selectVocabulary), for: .touchUpInside)
    }
    
    private func navigationSetup() {
        let rightButton = UIBarButtonItem(title: "추가", style: .done, target: self, action: #selector(addWord))
        rightButton.tintColor = .systemRed
        navigationItem.rightBarButtonItem = rightButton
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.hidesBackButton = true
        
        guard let vocabulary = repository.allFetch().first else { return }
        selectVocabularyView.vocabularyLabel.text = vocabulary.title
        navigationItem.titleView = selectVocabularyView
    }
    
    private func saveNotificationViewSetup() {
        wordSaveNotificationView.isHidden = true
    }
    
    @objc private func selectVocabulary() {
        guard let vocabulary else { return }
        let vc = BottomSheetSelectVocabularyViewController(vocabulary: vocabulary)
        vc.vocabularySelectHandler = { [weak self] selectVocabulary in
            guard let self else { return }
            self.vocabulary = selectVocabulary
            self.selectVocabularyView.vocabularyLabel.text = self.vocabulary?.title
        }
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        self.present(vc, animated: true)
    }
    
    @objc private func addWord() {
        guard let vocabulary,
              let englishText = englishWordSearchField.text,
              let koreaText = koreanMeaningSearchField.text else { return }
        let word = Word(english: englishText, korea: koreaText, isMemorize: false, isBookmark: false)
        repository.addWord(vocabularyEntityId: vocabulary.objectID, word: word)
        wordSaveNotificationView.saveWordLabel.text = "\(englishText)이 저장되었습니다."
        initTextField()
        wordSaveNotificationView.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.wordSaveNotificationView.isHidden = true
            self.wordSaveNotificationView.saveWordLabel.text = ""
        }
    }
    
    private func initTextField() {
        englishWordSearchField.text = ""
        koreanMeaningSearchField.text = ""
    }
}

extension AddWordViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let englishText = englishWordSearchField.text,
              let koreaText = koreanMeaningSearchField.text else { return }
        if false == englishText.isEmpty && false == koreaText.isEmpty {
            navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
        
    }
}

extension AddWordViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented, presenting: presenting, size: 0.8)
    }
}
