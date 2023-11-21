//
//  VocabularyRepository.swift
//  oewoboka
//
//  Created by 김도현 on 2023/10/04.
//

import Foundation
import CoreData

class VocabularyRepository {
    
    static let shared: VocabularyRepository = VocabularyRepository(type: .sqlite)
    
    enum CoreDataType {
        case inMemory
        case sqlite
    }
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        if self.type == .inMemory {
            let description = NSPersistentStoreDescription()
            description.url = URL(fileURLWithPath: "/dev/null")
            container.persistentStoreDescriptions = [description]
        }

        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unable to load core data persistent stores: \(error)")
            }
        }

        return container
    }()
    
    private let type: CoreDataType
        
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init(type: CoreDataType) {
        self.type = type
    }
    
    func create(title: String) {
        let vocabularyEntity = VocabularyEntity(context: context)
        vocabularyEntity.title = title
        save()
    }
    
    func addWord(vocabularyEntityId: NSManagedObjectID, word: Word) {
        guard let vocabularyEntitty = fetch(id: vocabularyEntityId) else { return }
        let wordEntity = WordEntity(context: context)
        wordEntity.english = word.english
        wordEntity.korea = word.korea
        wordEntity.isBookmark = word.isBookmark
        wordEntity.isMemorize = word.isMemorize
        vocabularyEntitty.addToWords(wordEntity)
        save()
    }
    
    func update() {
        save()
    }
    
    func removeVocabulary(vocabulary: VocabularyEntity) {
        context.delete(vocabulary)
        save()
    }
    
    func removeWord(wordEntity: WordEntity) {
        guard let vocabulary = wordEntity.vocabulary else { return }
        vocabulary.removeFromWords(wordEntity)
        context.delete(wordEntity)
        save()
    }
    
    func allFetch() -> [VocabularyEntity] {
        let fetchRequest: NSFetchRequest<VocabularyEntity> = VocabularyEntity.fetchRequest()
        do {
            let vocabularys = try context.fetch(fetchRequest)
            return vocabularys
        } catch {
            print("fetch for update Person error: \(error)")
            return []
        }
    }
    
    func fetch(id: NSManagedObjectID) -> VocabularyEntity? {
        let fetchRequest: NSFetchRequest<VocabularyEntity> = VocabularyEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "SELF = %@", id)
        do {
            let vocabularys = try context.fetch(fetchRequest)
            return vocabularys.first
        } catch {
            print("fetch for update Person error: \(error)")
            return nil
        }
    }
    
    private func save() {
        do {
            try context.save()
        } catch let e {
            print(e.localizedDescription)
        }
    }
    
}
