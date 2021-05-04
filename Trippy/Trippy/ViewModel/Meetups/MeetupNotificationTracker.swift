import Combine
import SwiftUI

class MeetupNotificationTracker {
    private let notificationManager: NotificationManager
    private let meetupNotificationModel: MeetupNotificationModel<FBStorage<FBMeetupNotification>>
    private let meetupModel: MeetupModel<FBStorage<FBMeetup>>
    private var cancellables: Set<AnyCancellable> = []
    @Binding private var showAlert: Bool
    @Binding private var alert: Alert

    init(notificationManager: NotificationManager,
         meetupNotificationModel: MeetupNotificationModel<FBStorage<FBMeetupNotification>>,
         meetupModel: MeetupModel<FBStorage<FBMeetup>>, showAlert: Binding<Bool>,
         alert: Binding<Alert>
         ) {
        self.meetupModel = meetupModel
        self.notificationManager = notificationManager
        self.meetupNotificationModel = meetupNotificationModel
        self._alert = alert
        self._showAlert = showAlert
        checkForNotifications(notifications: meetupNotificationModel.notifications)
        meetupNotificationModel.$notifications.sink {notifications in
            self.checkForNotifications(notifications: notifications)
        }.store(in: &cancellables)
    }

    private func checkForNotifications(notifications: [MeetupNotification]) {
        notifications.filter { !$0.isNotified }.forEach {notification in
            let meetup = self.getMeetup(meetupId: notification.meetupId)
            if let meetup = meetup {
                self.notifyUser(for: meetup)
                self.setNotificationAsRead(notification: notification)
            }
        }
    }

    private func notifyUser(for meetup: Meetup) {
        let state = UIApplication.shared.applicationState
        let meetupDate = meetup.meetupDate.dateTimeStringFromDate
        let title = "You have been added to a meetup on \(meetupDate)!"
        let body = "Launch the app now to find out more!"
        switch state {
        case .background:
            notificationManager.sendNotification(title: title, body: body)
        default:
            alert = Alert(title: Text(title))
            showAlert = true
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
