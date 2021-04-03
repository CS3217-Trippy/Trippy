//
//  SessionWrapper.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 2/4/21.
//

class FBSessionWrapper {
    var sessionStore: FBSessionStore?

    func initializeSessionStore() {
        self.sessionStore = FBSessionStore()
    }

    func retrieveSessionStore() -> FBSessionStore {
        if sessionStore == nil {
            initializeSessionStore()
        }
        guard let sessionStore = sessionStore else {
            fatalError("Session store should have been initialized")
        }
        return sessionStore
    }
}
