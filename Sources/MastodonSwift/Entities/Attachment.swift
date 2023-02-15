import Foundation

public struct Attachment: Codable {
    public enum AttachmentType: String, Codable {
        case unknown    = "unknown"
        case image      = "image"
        case gifv       = "gifv"
        case video      = "video"
        case audio      = "audio"
    }
	
	public struct AttachmentMeta: Codable {
		public let focus: AttachmentFocus?
		
		public struct AttachmentFocus: Codable {
			public let x: Double
			public let y: Double
		}
	}
    
    public let id: String
    public let type: AttachmentType
    public let url: URL
    public let previewUrl: URL?

    public let remoteUrl: URL?
    public let description: String?
    public let blurhash: String?
	
	public let meta: AttachmentMeta?

    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case url
        case previewUrl = "preview_url"

        case remoteUrl = "remote_url"
        case description
        case blurhash
		
		case meta
    }
}
