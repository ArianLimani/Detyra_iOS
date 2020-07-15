//
//  Validation.swift
//  Detyra_iOS
//
//  Created by Arian Limani on 7/15/20.
//  Copyright © 2020 FitimHajredini. All rights reserved.
//

import Foundation

class Validation{
    public func validateName(name: String) ->Bool {
        let nameRegex = "^\\w{3,18}$"
        let trimmedString = name.trimmingCharacters(in: .whitespaces)
        let validateName = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        let isValidateName = validateName.evaluate(with: trimmedString)
        return isValidateName
    }

    public func validateEmailId(emailID: String) -> Bool {
        let emailRegEx = "^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@+(student.uni-pr.edu)$"
        let trimmedString = emailID.trimmingCharacters(in: .whitespaces)
        let validateEmail = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let isValidateEmail = validateEmail.evaluate(with: trimmedString)
        return isValidateEmail
    }
    public func validatePassword(password: String) -> Bool {
        let passRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{6,}$"
        let trimmedString = password.trimmingCharacters(in: .whitespaces)
        let validatePassord = NSPredicate(format:"SELF MATCHES %@", passRegEx)
        let isvalidatePass = validatePassord.evaluate(with: trimmedString)
        return isvalidatePass
    }

}
