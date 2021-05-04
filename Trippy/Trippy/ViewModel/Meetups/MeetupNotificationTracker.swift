import Combine

class MeetupNotificationTracker {
    private let notificationManager: NotificationManager
    private let meetupNotificationModel: MeetupNotificationModel<FBStorage<FBMeetupNotification>>
    private let meetupModel: MeetupModel<FBStorage<FBMeetup>>

    init(notificationManager: NotificationManager,
         meetupNotificationModel: MeetupNotificationModel<FBStorage<FBMeetupNotification>>,
         meetupModel: MeetupModel<FBStorage<FBMeetup>>
         ) {
        self.meetupModel = meetupModel
        self.notificationManager = notificationManager
        self.meetupNotificationModel = meetupNotificationModel
        sendNotificationsForMeetups()
    }

    private func sendNotificationsForMeetups() {
        meetupNotificationModel.$notifications.sink {notifications in
            notifications.filter { !$0.isNotified }.forEach {notification in
                let meetup = self.getMeetup(meetupId: notification.meetupId)
                if let meetup = meetup {
                    let meetupDate = meetup.meetupDate.dateTimeStringFromDate
                    let title = "You have been added to a meetup on \(meetupDate)!"
                    let body = "Launch the app now to find out more!"
                    self.notificationManager.sendNotification(title: title, body: body)
                    self.setNotificationAsRead(notification: notification)
                }
            }
        }
    }

    private func setNotificationAsRead(notification: MeetupNotification) {
        notification.isNotified = true
        do {
            try meetupNotificationModel.updateNotification(item: notification)
        } catch {
            print("\(error.localizedDescription)")
        }
    }

    private func getMeetup(meetupId: String) -> Meetup? {
        meetupModel.meetupItems.first { $0.id == meetupId }
    }

}
