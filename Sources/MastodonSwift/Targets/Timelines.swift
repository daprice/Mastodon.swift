import Foundation

public typealias SinceId = StatusId
public typealias MaxId = StatusId
public typealias MinId = StatusId
public typealias Limit = Int

extension Mastodon {
    public enum Timelines {
        case home(MaxId?, SinceId?, MinId?, Limit?)
        case pub(Bool, Bool, MaxId?, SinceId?) // Bool = local, Bool(2) = onlyMedia
        case tag(String, Bool, Bool, MaxId?, SinceId?) // Bool = local, Bool(2) = onlyMedia
    }
}

extension Mastodon.Timelines: TargetType {
    fileprivate var apiPath: String { return "/api/v1/timelines" }

    /// The path to be appended to `baseURL` to form the full `URL`.
    public var path: String {
        switch self {
        case .home:
            return "\(apiPath)/home"
        case .pub:
            return "\(apiPath)/public"
        case .tag(let hashtag, _, _, _, _):
            return "\(apiPath)/tag/\(hashtag)"
        }
    }
    
    /// The HTTP method used in the request.
    public var method: Method {
        switch self {
        default:
            return .get
        }
    }
    
    /// The parameters to be incoded in the request.
    public var queryItems: [(String, String)]? {
        var params: [(String, String)] = []
        var local: Bool? = nil
        var maxId: MaxId? = nil
        var sinceId: SinceId? = nil
        var minId: MinId? = nil
        var limit: Limit? = nil
		var onlyMedia: Bool? = nil

        switch self {
        case .tag(_, let _local, let _onlyMedia, let _maxId, let _sinceId),
             .pub(let _local, let _onlyMedia, let _maxId, let _sinceId):
            local = _local
            maxId = _maxId
            sinceId = _sinceId
			onlyMedia = _onlyMedia
        case .home(let _maxId, let _sinceId, let _minId, let _limit):
            maxId = _maxId
            sinceId = _sinceId
            minId = _minId
            limit = _limit
        }

        if let maxId {
            params.append(("max_id",  maxId))
        }
        if let sinceId {
            params.append(("since_id", sinceId))
        }
        if let minId {
            params.append(("min_id", minId))
        }
        if let limit {
            params.append(("limit", "\(limit)"))
        }
        if let local = local {
            params.append(("local", local.asString))
        }
		if let onlyMedia = onlyMedia {
			params.append(("only_media", onlyMedia.asString))
		}
        return params
    }
    
    public var headers: [String: String]? {
        [:].contentTypeApplicationJson
    }
    
    public var httpBody: Data? {
        nil
    }
}
