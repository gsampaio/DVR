extension Error {
    var dictionary: [String: Any] {
        let error = self as NSError

        var dictionary = [String: Any]()
        dictionary["domain"] = error.domain
        dictionary["code"] = error.code

        let data = NSKeyedArchiver.archivedData(withRootObject: error).base64EncodedString()
        dictionary["data"] = data

        return dictionary
    }
}

extension NSError {
    convenience init?(dictionary: [String: Any]) {
        guard let code = dictionary["code"] as? Int, let domain = dictionary["domain"] as? String else {
            return nil
        }

        if let base64String = dictionary["data"] as? String {
            let data = Data(base64Encoded: base64String, options: [])
            if let error = data.flatMap(NSKeyedUnarchiver.unarchiveObject) as? NSError {
                self.init(domain: error.domain, code: error.code, userInfo: error.userInfo)
            } else {
                return nil
            }
        } else {
            self.init(domain: domain, code: code, userInfo: nil)
        }
    }
}
