//
//  Base64.swift
//  base64
//
//  Created by Gokul on 14/07/25.
//

import Foundation

class Base64 {
    
    private let base64Table = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/")
    
    func base64Encode(input: String) -> String {

        var bitArray: [Int] = []

        for char in input {
            let asciiValue = Int(char.asciiValue ?? 0)
            let binaryString = String(asciiValue, radix: 2)
            let paddedBinary = String(repeating: "0", count: 8 - binaryString.count) + binaryString
            for bit in paddedBinary {
                bitArray.append(Int(String(bit))!)
            }
        }
        
        let extraBits = bitArray.count % 6
        if extraBits != 0 {
            let paddingBits = 6 - extraBits
            bitArray += Array(repeating: 0, count: paddingBits)
        }
        
        var base64Result = ""
        for i in stride(from: 0, to: bitArray.count, by: 6) {
            let chunk = Array(bitArray[i..<i+6])
            let binaryString = chunk.map(String.init).joined()
            let chunkValue = Int(binaryString, radix: 2)!
            base64Result.append(base64Table[chunkValue])
        }
        switch input.utf8.count % 3 {
        case 1: base64Result += "=="
        case 2: base64Result += "="
        default: break
        }
        
        return base64Result
    }
    
    func base64Decode( base64Input: String) -> String? {
       
        let cleanedInput = base64Input.filter { $0 != "=" }
        var bitString = ""
        for char in cleanedInput {
            guard let index = base64Table.firstIndex(of: char) else {
                print("Invalid Base64 character found: \(char)")
                return nil
            }
            let binaryChunk = String(index, radix: 2)
            let paddedBinary = String(repeating: "0", count: 6 - binaryChunk.count) + binaryChunk
            bitString += paddedBinary
        }
        
        var decodedString = ""
        
        var remainingBits = bitString
        
        while remainingBits.count >= 8 {
            let chunk = String(remainingBits.prefix(8))
            remainingBits = String(remainingBits.dropFirst(8))
            if let ascii = Int(chunk, radix: 2),
            let scalar = UnicodeScalar(ascii) {
                decodedString.append(Character(scalar))
                } else {
                    print("Could not decode chunk: \(chunk)")
                    return nil
                }
        }
        
        return decodedString
    }
}
