//
//  EventDataManager.swift
//  Starbucks
//
//  Created by juntaek.oh on 2022/05/11.
//

import Foundation
import Combine

class EventDataManager {

    static let shared = EventDataManager()
    let notifyEvent = PassthroughSubject<Event, Never>()

    private init() { }

    func notifyEventData(eventData: Event?) {
        guard let eventData = eventData else { return }
        // NotificationCenter.default.post(name: Notification.Name("event"), object: self, userInfo: ["data": eventData])
        notifyEvent.send(eventData)
    }
}
