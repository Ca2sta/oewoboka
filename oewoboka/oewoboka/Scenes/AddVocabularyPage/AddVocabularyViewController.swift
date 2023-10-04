//
//  AddVocabularyViewController.swift
//  oewoboka
//
//  Created by 김도현 on 2023/09/25.
//

import UIKit

class AddVocabularyViewController: UIViewController {

    private let englishWordSearchField = UITextField()
        private let koreanMeaningSearchField = UITextField()

        override func viewDidLoad() {
            super.viewDidLoad()
            
            setupUI()
        }

        private func setupUI() {
            view.backgroundColor = .white

            let englishLabel = UILabel()
            englishLabel.text = "English"
            view.addSubview(englishLabel)

            englishWordSearchField.borderStyle = .roundedRect
            view.addSubview(englishWordSearchField)
            
            let koreanLabel = UILabel()
            koreanLabel.text = "Korean"
            view.addSubview(koreanLabel)

            koreanMeaningSearchField.borderStyle = .roundedRect
            view.addSubview(koreanMeaningSearchField)

     
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
    }
