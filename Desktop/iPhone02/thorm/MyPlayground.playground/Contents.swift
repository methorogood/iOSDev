//: Playground - noun: a place where people can play

import UIKit

let date = Date()
let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
let stringOutput = dateFormatter.string(from: date)

print(stringOutput)



