//
//  QuziViewModel.swift
//  oewoboka
//
//  Created by 김도현 on 2023/10/05.
//

import Foundation

final class QuizViewModel {
    var featureType: Feature
    var quizType: QuizType
    var isQuizHidden: Bool = false {
        didSet {
            hiddenQuizObservable.value = isQuizHidden
        }
    }
    
    let repository: VocabularyRepository = VocabularyRepository.shared
    private let vocabularyList: [VocabularyEntity]
    var quizResultWords: [WordEntity] = []
    private var words: [WordEntity]
    private let quizCount: Int
    
    var dictationText: String? = nil
    
    private var currentIndex: Int = 0
    
    var dateObservable: Observable<TimeInterval> = Observable(0)
    var hiddenQuizObservable: Observable<Bool> = Observable(false)
    var bookMarkUpdateObservable: Observable<Bool> = Observable(false)
    var dismissHandler: () -> Void = {}
    var nextHandler: ((Bool) -> Void)?
    var reQuizHandler: () -> Void = {}
    
    init(quizData: QuizSettingData) {
        self.vocabularyList = quizData.selectedVocabulary
        self.featureType = quizData.featureType
        self.quizType = quizData.quizType
        self.quizCount = quizData.quizCount
        self.words = vocabularyList.compactMap({ $0.words?.array as? [WordEntity] }).flatMap({ $0 }).prefix(quizCount).map({ $0 })
    }
}

extension QuizViewModel {
    
    //MARK: Type
    var isTestType: Bool { featureType == .test }
    var isWordCard: Bool { featureType == .wordCard }
    var isDictation: Bool { featureType == .dictation }
    var isMeanDictation: Bool { quizType == .meanDictation }
    var isWordDictation: Bool { quizType == .wordDictation }
    var isComplete: Bool { currentIndex >= wordCount }
    var isWordLabelHidden: Bool { isWordCard && isWordDictation && isQuizHidden }
    var isMeanLabelHidden: Bool { isWordCard && isMeanDictation && isQuizHidden }
    var isMatch: Bool {
        if isMeanDictation {
            return dictationText == currentWord.korea
        } else if isWordDictation {
            return dictationText == currentWord.english
        }
        return false
    }
    var isUnMemorizeReQuizButtonHidden: Bool { unMemorizeWords.count == 0 || isTestType }
    
    //MARK: Text
    var currentEnglishLabelText: String? {
        if isWordCard == false && isWordDictation {
            return dictationText
        }
        if isIndexOutOfRange(index: currentIndex) { return nil }
        return currentWord.english
    }
    var currentKoreaLabelText: String? {
        if isWordCard == false && isMeanDictation {
            return dictationText
        }
        if isIndexOutOfRange(index: currentIndex) { return nil }
        return currentWord.korea
    }
    var nextEnglishText: String? {
        if isWordCard == false && isWordDictation {
            return ""
        }
        return nextWord?.english
    }
    var nextKoreaText: String? {
        if isWordCard == false && isMeanDictation {
            return ""
        }
        return nextWord?.korea
    }
    var progressCountText: String { "\(currentWordLocation) / \(wordCount)" }
    var nextProgressCountText: String { "\(nextWordLocation) / \(wordCount)" }
    var unMemorizeReQuizButtonText: String? { "모르는 \(unMemorizeWords.count)문제 다시 풀기" }
    
    //MARK: Progress
    var progressRate: CGFloat { CGFloat(memorizeWords.count) / CGFloat(quizResultWords.count) }
    
    //MARK: Word
    var memorizeWords: [WordEntity] { quizResultWords.filter{ $0.isMemorize } }
    var unMemorizeWords: [WordEntity] { quizResultWords.filter{ $0.isMemorize == false } }
    var wordCount: Int { words.count }
    var currentWordLocation: Int { currentIndex + 1 }
    var currentWord: WordEntity { words[currentIndex] }
    var nextWord: WordEntity? {
        if isIndexOutOfRange(index: currentIndex + 1) == false {
            return words[currentIndex + 1]
        }
        return nil
    }
    var nextWordLocation: Int { currentIndex + 2 }
    
    func reQuizWordSetting() {
        quizResultWords = []
        currentIndex = 0
    }
    
    func next() {
        currentIndex += 1
    }
    
    func previous() {
        if currentIndex == 0 { return }
        currentIndex -= 1
    }
    
    func restWordsFailure() {
        for index in currentIndex..<words.count {
            let word = words[index]
            word.isMemorize = false
            quizResultWords.append(word)
        }
    }
    
    func unMemorizeReQuiz() {
        words = unMemorizeWords
    }
    
    private func isIndexOutOfRange(index: Int) -> Bool { return index < 0 || index >= wordCount
    }
    
}
