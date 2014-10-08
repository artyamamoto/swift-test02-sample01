// Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
/*
class md5_ {
    
}
func md5(s:String) {
    var data = NSData(s)
    var buffer:[UInt8] = [UInt8](count:data.length, repeatedValue:0)
    NSString(s).getBytes(buffer)
}

md5("あいうえお")
*/

var s = __FILE__
var l = __LINE__
var c = __COLUMN__
var f = __FUNCTION__

println("\(__FILE__)")


func test(l:Int = __LINE__) {
    println("line: \(l)")
}
func test2(l:Int = __LINE__) {
    println("line: \(l)")
}

test2()

test()
