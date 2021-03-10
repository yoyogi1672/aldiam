//
//  diary.swift
//  aldiam
//
//  Created by Owner on 2020/12/28.
//

import Foundation
import RealmSwift

class diaryModel: Object {
    @objc dynamic var title = ""
    @objc dynamic var memo = ""
    @objc dynamic var date = ""//yyyy.MM.dd
    @objc dynamic var dateString = ""
    @objc dynamic var iamgeData = ""
    @objc dynamic var rate = 0
}

class ranking: Object {
    @objc dynamic var rank1 = ""
    @objc dynamic var rank2 = ""
    @objc dynamic var rank3 = ""
}


