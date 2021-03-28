protocol FBUserRelatedStorable: FBStorable where ModelType: UserRelatedModel {
    var userId: String { get }
}
