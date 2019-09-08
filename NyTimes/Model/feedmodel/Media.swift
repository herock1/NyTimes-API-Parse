//
//  Media.swift
//  Hello-iOS
//
//  Created by Herock Hasan on 18/5/18.
//  Copyright © 2018 Herock Hasan. All rights reserved.
//

import Foundation
struct Media : Codable {
	let media_metadata : [Media_metadata]?

	enum CodingKeys: String, CodingKey {

		case media_metadata = "media-metadata"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		media_metadata = try values.decodeIfPresent([Media_metadata].self, forKey: .media_metadata)
	}

}
