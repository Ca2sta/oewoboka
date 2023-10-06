//
//  AddVocabularyViewController.swift
//  oewoboka
//
//  Created by 김도현 on 2023/09/25.
//

import UIKit

class AddWordViewController: UIViewController {

    private let topDivider: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        return view
    }()
    
    private let englishLabel: UILabel = {
        let label = UILabel()
        label.text = "English"
        return label
    }()
    
    private let englishWordSearchField: UITextField = {
        let view = UITextField()
        view.borderStyle = .roundedRect
        view.placeholder = "단어를 입력해주세요(필수)"
        return view
    }()
    
    private let koreanLabel: UILabel = {
        let label = UILabel()
        label.text = "Korean"
        return label
    }()
    
    private let koreanMeaningSearchField: UITextField = {
        let view = UITextField()
        view.borderStyle = .roundedRect
        view.placeholder = "의미를 입력해주세요(필수)"
        return view
    }()
    
    private let bottomDivider: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        return view
    }()
    
    private let transLateButton: DefaultButton = {
        let button = DefaultButton()
        button.setTitle("Translate", for: .normal)
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = .black
        button.isHidden = true
        return button
    }()
    
    private let addButton: DefaultButton = {
        let button = DefaultButton()
        button.setTitle("추가하기", for: .normal)
        button.setImage(UIImage(systemName: "plus.square.on.square"), for: .normal)
        button.tintColor = .black
        button.isHidden = true
        return button
    }()
    
    private let wordSaveNotificationView = WordSaveNotificationView()
    
    private let repository: VocabularyRepository = VocabularyRepository.shared
    private let selectVocabularyView = SelectVocabularyButton()
    private var vocabulary: VocabularyEntity?
    let transLateManager = NaverDictionaryManager()
    
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
        view.backgroundColor = .systemBackground

        view.addSubview(topDivider)
        topDivider.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(1)
        }

        view.addSubview(englishLabel)
        englishLabel.snp.makeConstraints { make in
            make.top.equalTo(topDivider.snp.bottom).offset(Constant.defalutPadding)
            make.leading.equalTo(view).offset(Constant.defalutPadding)
        }

        view.addSubview(englishWordSearchField)
        englishWordSearchField.snp.makeConstraints { make in
            make.top.equalTo(englishLabel.snp.bottom).offset(Constant.defalutPadding / 2)
            make.left.right.equalTo(view).inset(Constant.defalutPadding)
            make.height.equalTo(Constant.screenHeight * 0.05)
        }
        

        view.addSubview(koreanLabel)
        koreanLabel.snp.makeConstraints { make in
            make.top.equalTo(englishWordSearchField.snp.bottom).offset(Constant.defalutPadding)
            make.leading.equalTo(view).offset(Constant.defalutPadding)
        }
        
        view.addSubview(koreanMeaningSearchField)
        koreanMeaningSearchField.snp.makeConstraints { make in
            make.top.equalTo(koreanLabel.snp.bottom).offset(Constant.defalutPadding / 2)
            make.left.right.equalTo(view).inset(Constant.defalutPadding)
            make.height.equalTo(Constant.screenHeight * 0.05)
        }
        
        view.addSubview(bottomDivider)
        bottomDivider.snp.makeConstraints { make in
            make.top.equalTo(koreanMeaningSearchField.snp.bottom).offset(Constant.defalutPadding)
            make.left.right.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
        
        view.addSubview(transLateButton)
        transLateButton.snp.makeConstraints { make in
            make.top.equalTo(bottomDivider.snp.bottom).offset(Constant.defalutPadding)
            make.left.right.equalToSuperview().inset(Constant.defalutPadding)
            make.height.equalTo(Constant.screenHeight * 0.05)
        }
        transLateButton.addTarget(self, action: #selector(didtappedTransLatedButton), for: .touchUpInside)
        
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.top.equalTo(bottomDivider.snp.bottom).offset(Constant.defalutPadding)
            make.left.right.equalToSuperview().inset(Constant.defalutPadding)
            make.height.equalTo(Constant.screenHeight * 0.05)
        }
        addButton.addTarget(self, action: #selector(addWord), for: .touchUpInside)
        
        
        view.addSubview(wordSaveNotificationView)
        wordSaveNotificationView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
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
        if let vocabulary = vocabulary {
            selectVocabularyView.vocabularyLabel.text = vocabulary.title
        } else {
            guard let vocabulary = repository.allFetch().first else { return }
            selectVocabularyView.vocabularyLabel.text = vocabulary.title
        }
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
    
    @objc private func didtappedTransLatedButton() {
        print(#function)
        if koreanMeaningSearchField.text!.isEmpty {
            transLateManager.getTranslateData(searchKeyWord: englishWordSearchField.text, from: .en, target: .ko) { [weak self] result in
                DispatchQueue.main.async {
                    self?.koreanMeaningSearchField.text = result.translatedText
                    
                }
            }
        } else {
            transLateManager.getTranslateData(searchKeyWord: koreanMeaningSearchField.text, from: .ko, target: .en) { [weak self] result in
                DispatchQueue.main.async {
                    self?.englishWordSearchField.text = result.translatedText
                }
            }
        }
        addButton.isHidden = false
        buttonHiddenMotion(toggle: addButton.isHidden, button: addButton)
        transLateButton.isHidden = true
        buttonHiddenMotion(toggle: transLateButton.isHidden, button: transLateButton)
        
    }
    
    private func initTextField() {
        englishWordSearchField.text = ""
        koreanMeaningSearchField.text = ""
    }
    func buttonHiddenMotion(toggle:Bool, button: UIButton) {
        UIView.transition(with: button, duration: 0.5, options: .transitionFlipFromTop, animations: { [weak self] in
            if toggle{
                button.alpha = 0
            } else {
                button.alpha = 1
            }
        })
    }
}

extension AddWordViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let englishText = englishWordSearchField.text,
              let koreaText = koreanMeaningSearchField.text else { return }
        
        
        if (englishText.isEmpty && !koreaText.isEmpty) || (!englishText.isEmpty && koreaText.isEmpty) {
            if transLateButton.isHidden {
                transLateButton.isHidden = false
                buttonHiddenMotion(toggle: transLateButton.isHidden, button: transLateButton)
            }
            addButton.isHidden = true
            buttonHiddenMotion(toggle: transLateButton.isHidden, button: addButton)
        } else if (!englishText.isEmpty && !koreaText.isEmpty) {
            if addButton.isHidden {
                addButton.isHidden = false
                buttonHiddenMotion(toggle: addButton.isHidden, button: addButton)
            }

            transLateButton.isHidden = true
            buttonHiddenMotion(toggle: transLateButton.isHidden, button: transLateButton)
            
        } else {
            addButton.isHidden = true
            buttonHiddenMotion(toggle: addButton.isHidden, button: addButton)
            transLateButton.isHidden = true
            buttonHiddenMotion(toggle: transLateButton.isHidden, button: transLateButton)
        }
    }
}

extension AddWordViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented, presenting: presenting, size: 0.8)
    }
}
