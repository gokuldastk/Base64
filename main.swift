
print("Enter text to encode: ")
if let input = readLine() {
    
    let base64 = Base64()
    
    let encoded = base64.base64Encode(input: input)
    print("Encoded:", encoded)

    if let decoded = base64.base64Decode(base64Input: encoded) {
        print("Decoded:", decoded)
    } else {
        print(" Decoding failed.")
    }
}
