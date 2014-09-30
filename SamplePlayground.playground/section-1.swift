// Playground - noun: a place where people can play

import UIKit

//=== 循環参照
class HTMLElement {
    var name:String
    var text:String?

    lazy var asHTML: ()->String = {
        [unowned self] in
        if let text = self.text {
            return "<\(self.name)>\(text)</\(self.name)>"
        } else {
            return "<\(self.name) />"
        }
    }
    init(name:String, text:String?=nil) {
        self.name = name
        self.text = text
    }
    deinit {
        //        println("\(name) is being deinitialized.")
        println("being deinitialized.")
    }
}



var p: HTMLElement? = HTMLElement(name: "p", text: "hello, world")
println(p!.asHTML())

p = nil



//=== クイックソート ===========================
class QuickSorter {
    var ar:[Int]
    var cmp:((Int,Int)->Int) = { (a, b) in
        if a == b { return 0 }
        return (a < b) ? 1 : -1
    }
    func sort(left l: Int = -1, right r: Int = -1)->[Int] {
        var l_ = l < 0 ? 0 : l
        var r_ = r < 0 ? self.ar.count : r
        
        if l_ < r_ {
            let i = self.p(left: l_, right: r_)
            self.sort(left: l_,  right: i - 1)
            self.sort(left: i+1, right: r_)
        }
        return self.ar
    }
    init(ar:[Int], cmp:((Int, Int)->Int)?=nil) {
        self.ar = ar
        if let r = cmp {
            self.cmp = cmp!
        }
    }
    func p(left l:Int, right r:Int)->Int {
        var i = l
        for (var j=(l+1); j < r ; j++) {
            if self.cmp(self.ar[j], self.ar[l]) > 0 {
                i++
                (self.ar[i], self.ar[j]) = (self.ar[j], self.ar[i])
            }
        }
        (self.ar[i], self.ar[l]) = (self.ar[l], self.ar[i])
        return i
    }

}


var q = QuickSorter(ar: [42, 12, 88, 62, 63, 56, 1, 77, 88, 97, 97, 20, 45, 91, 62, 2, 15, 31, 59, 5] ){ $0 > $1 ? 1 : -1 }
q.sort()




//=== 三角関数、指数関数のテイラー展開による四則演算での近似値の計算
class TrigonometricFunction {
    func kaijo(num:Double)->Double {
        var n:Double = num
        var r:Double = 1
        while n > 0 {
            r *= n
            n--
        }
        return r
    }
    func sum(x:Double, start_n:Int, callback:(Double,Int)->Double)->Double {
        var r:Double = 0
        for (var n=start_n; n<10; n++) {
            r += callback(x, n)
        }
        return r
    }
    func sin(x:Double)->Double {
        return self.sum(x, start_n:1) { [unowned self] x_, n in
            return (n % 2 == 1 ? 1 : -1) * pow(x_, Double(n*2-1)) / self.kaijo(Double(n*2-1))
        }
    }
    func cos(x:Double)->Double {
        return self.sum(x, start_n:0) { [unowned self] x_, n in
            return (n % 2 == 0 ? 1 : -1) * pow(x_, Double(n*2)) / self.kaijo(Double(n*2))
        }
    }
    func expo(x:Double)->Double {
        return self.sum(x, start_n:0) { [unowned self] x_, n in
            return pow(x_, Double(n)) / self.kaijo(Double(n))
        }
    }
    init() {
    }
}
var t = TrigonometricFunction()

let PI = 3.141
t.sin(PI / 2)
t.cos(PI / 2)

t.expo(1)






