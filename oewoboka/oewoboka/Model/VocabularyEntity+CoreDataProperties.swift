//
//  VocabularyEntity+CoreDataProperties.swift
//  oewoboka
//
//  Created by 김도현 on 2023/10/05.
//
//

import Foundation
import CoreData


extension VocabularyEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VocabularyEntity> {
        return NSFetchRequest<VocabularyEntity>(entityName: "VocabularyEntity")
    }

    @NSManaged public var title: String
    @NSManaged public var words: NSOrderedSet?

}

// MARK: Generated accessors for words
extension VocabularyEntity {

    @objc(insertObject:inWordsAtIndex:)
    @NSManaged public func insertIntoWords(_ value: WordEntity, at idx: Int)

    @objc(removeObjectFromWordsAtIndex:)
    @NSManaged public func removeFromWords(at idx: Int)

    @objc(insertWords:atIndexes:)
    @NSManaged public func insertIntoWords(_ values: [WordEntity], at indexes: NSIndexSet)

    @objc(removeWordsAtIndexes:)
    @NSManaged public func removeFromWords(at indexes: NSIndexSet)

    @objc(replaceObjectInWordsAtIndex:withObject:)
    @NSManaged public func replaceWords(at idx: Int, with value: WordEntity)

    @objc(replaceWordsAtIndexes:withWords:)
    @NSManaged public func replaceWords(at indexes: NSIndexSet, with values: [WordEntity])

    @objc(addWordsObject:)
    @NSManaged public func addToWords(_ value: WordEntity)

    @objc(removeWordsObject:)
    @NSManaged public func removeFromWords(_ value: WordEntity)

    @objc(addWords:)
    @NSManaged public func addToWords(_ values: NSOrderedSet)

    @objc(removeWords:)
    @NSManaged public func removeFromWords(_ values: NSOrderedSet)

}

extension VocabularyEntity : Identifiable {

}
