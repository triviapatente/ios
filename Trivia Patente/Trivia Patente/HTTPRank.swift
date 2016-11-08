//
//  HTTPRank.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 07/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class HTTPRank: HTTPManager {
    func italian_rank(handler : @escaping (TPRankResponse) -> Void) {
        self.request(url: "/rank/global", method: .get, params: nil) { (response : TPRankResponse) in
            //sleep(3)
            let a = User(username: "Utente a", id: 1000, avatar: "https://yt3.ggpht.com/-F4Y7-A-tKCQ/AAAAAAAAAAI/AAAAAAAAAAA/GgD8W2uPsQI/s100-c-k-no-mo-rj-c0xffffff/photo.jpg", score: 11100)
            let b = User(username: "Utente b", id: 1002, avatar: nil, score: 11100)
            let c = User(username: "Utente c", id: 1003, avatar: "https://yt3.ggpht.com/-yjj95JJQEm8/AAAAAAAAAAI/AAAAAAAAAAA/qkyW_xNpwSo/s88-c-k-no-mo-rj-c0xffffff/photo.jpg", score: 8100)
            let d = User(username: "Utente d", id: 1004, avatar: "https://i.ytimg.com/vi/6pIR8XP8Kh8/hqdefault.jpg?custom=true&w=196&h=110&stc=true&jpg444=true&jpgq=90&sp=68&sigh=y8RCKvlXmBUTjavTviOIQLey84Y", score: 7155)
            let e = User(username: "Utente e", id: 1005, avatar: "https://scontent-mxp1-1.xx.fbcdn.net/v/t1.0-9/1503354_1411413165787940_1685526080_n.jpg?oh=e8178ca6d621e78972f0948802bd8b6e&oe=58A001F5", score: 7155)
            let f = User(username: "Utente f", id: 1006, avatar: "https://yt3.ggpht.com/-dt3sUNuUOZM/AAAAAAAAAAI/AAAAAAAAAAA/4E7K3mB-mYY/s88-c-k-no-mo-rj-c0xffffff/photo.jpg", score: 7000)
            let g = User(username: "Utente g", id: 1004, avatar: "https://i.ytimg.com/vi/6pIR8XP8Kh8/hqdefault.jpg?custom=true&w=196&h=110&stc=true&jpg444=true&jpgq=90&sp=68&sigh=y8RCKvlXmBUTjavTviOIQLey84Y", score: 6005)
            let h = User(username: "Utente h", id: 1005, avatar: "https://scontent-mxp1-1.xx.fbcdn.net/v/t1.0-9/1503354_1411413165787940_1685526080_n.jpg?oh=e8178ca6d621e78972f0948802bd8b6e&oe=58A001F5", score: 6000)
            let i = User(username: "Utente i", id: 1006, avatar: "https://yt3.ggpht.com/-dt3sUNuUOZM/AAAAAAAAAAI/AAAAAAAAAAA/4E7K3mB-mYY/s88-c-k-no-mo-rj-c0xffffff/photo.jpg", score: 5100)
            let l = User(username: "Utente l", id: 1006, avatar: "https://yt3.ggpht.com/-dt3sUNuUOZM/AAAAAAAAAAI/AAAAAAAAAAA/4E7K3mB-mYY/s88-c-k-no-mo-rj-c0xffffff/photo.jpg", score: 5000)
            response.users = [a, b, c, d, e, f, g, h, i, l]
            response.userPosition = 403023
            handler(response)
        }
    }
    func friends_rank(handler : @escaping (TPRankResponse) -> Void) {
        italian_rank(handler: handler)
    }
}
