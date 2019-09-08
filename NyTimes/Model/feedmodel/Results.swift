//
//  Results.swift
//  Hello-iOS
//
//  Created by Herock Hasan on 18/5/18.
//  Copyright © 2018 Herock Hasan. All rights reserved.
//

import Foundation
struct NyResults : Codable {
	let url : String?
	let section : String?
	let type : String?
	let title : String?
	let abstract : String?
	let published_date : String?
	let media : [Media]?

    enum Status : String, Decodable { case success, error }
    
	enum CodingKeys: String, CodingKey {

		case url = "url"
		case section = "section"
		case type = "type"
		case title = "title"
		case abstract = "abstract"
		case published_date = "published_date"
		case media = "media"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		url = try values.decodeIfPresent(String.self, forKey: .url)
		section = try values.decodeIfPresent(String.self, forKey: .section)
		type = try values.decodeIfPresent(String.self, forKey: .type)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		abstract = try values.decodeIfPresent(String.self, forKey: .abstract)
		published_date = try values.decodeIfPresent(String.self, forKey: .published_date)
        do { media = try values.decode([Media].self, forKey: .media) }
        catch { media = [Media]() }
	}

}
