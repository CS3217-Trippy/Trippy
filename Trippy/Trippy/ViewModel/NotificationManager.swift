//
//  TrippyNotificationManager.swift
//  Trippy
//
//  Created by QL on 13/4/21.
//

import UserNotifications

class NotificationManager: NSObject, UNUserNotificationCenterDelegate, ObservableObject {
    var categoriesMap: [String:(String)->Void] = [:]
    var categories = Set<UNNotificationCategory>()
    
    func sendNotificationWithActions(title: String, body: String, categoryName: String, actions:[UNNotificationAction], callback: @escaping (String)->Void) {
        if categoriesMap[categoryName] == nil {
            addCategory(id: categoryName, actions: actions, callback: callback)
        }
        let content = createContent(title: title, body: body, categoryId: categoryName)
        sendNotificationRequest(content: content)
    }
    
    private func sendNotificationRequest(content: UNMutableNotificationContent) {
        let center = UNUserNotificationCenter.current()
        let uuidString = UUID().uuidString
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        center.add(request, withCompletionHandler: nil)
    }
    
    private func createContent(title:String, body: String, categoryId: String? = nil) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        guard let category = categoryId else {
            return content
        }
        content.categoryIdentifier = category
        return content
    }
    
    func sendNotification(title: String, body: String) {
        let content = createContent(title: title, body: body)
        sendNotificationRequest(content: content)
    }
    
    private func addCategory(id:String, actions: [UNNotificationAction],callback: @escaping (String)->Void) {
        let newCategory = UNNotificationCategory(identifier: id, actions: actions, intentIdentifiers: [])
        let center = UNUserNotificationCenter.current()
        categories.insert(newCategory)
        center.setNotificationCategories(categories)
        categoriesMap[id] = callback
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let category = response.notification.request.content.categoryIdentifier
        if let callback = categoriesMap[category] {
            callback(response.actionIdentifier)
        }
        completionHandler()
    }
}
