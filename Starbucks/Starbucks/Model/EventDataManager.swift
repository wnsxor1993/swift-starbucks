//
//  EventDataManager.swift
//  Starbucks
//
//  Created by juntaek.oh on 2022/05/11.
//

import Foundation

class EventDataManager {

    func notifyEventData(eventData: Event?) {
        guard let eventData = eventData else { return }
        NotificationCenter.default.post(name: Notification.Name("event"), object: EventDataManager.self, userInfo: ["data": eventData])
    }
}
