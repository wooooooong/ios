//: Playground - noun: a place where people can play

import UIKit
import Foundation

//typealias, enum, tuples 등에 대한 이해
typealias Point = (Double, Double)

func distance(a : Point, b : Point) -> Double {
    let x = abs(a.0 - b.0)
    let y = abs(a.1 - b.1)
    return Double(sqrt(x*x + y*y))
}

distance(a: (1,1), b: (5,6))




// optional에 대한 이해
func age(_ from: String) -> Int {
    if let str = Int(from){
        return str
    }
    else{
        return 0
    }
}

age("931228")




// closure과 고차함수에 대한 이해
let closure1 : (Int) -> Int = { n in return n * n }

func complex(from array: [Int]) -> Int {
    
    let filtered =  array.filter({$0 % 2 == 0 || $0 % 3 == 0})
    let map = filtered.flatMap({$0 * 5})
    return map.reduce(0,{$0+$1})
}

let numbers = [1, 2, 3, 4, 5, 10, 11, 12]

complex(from: numbers)




// 파스칼 삼각형 이중 배열 만들기
func makePascalTriangle(numOfRows : Int) -> ([[Int]]) {
    var pascal = [[Int]]()
    for i in 0...numOfRows-1{
        var row = [Int]()
        for j in 0...i{
            if j == 0{
                row.append(1)
            }
            else if j == i{
                row.append(1)
            }
            else{
                row.append(pascal[i-1][j-1]+pascal[i-1][j])
            }
        }
        pascal.append(row)
    }
    
    return pascal
}

makePascalTriangle(numOfRows: 10)





// 구조체 및 CGPoint 이해
struct MyRect {
    var PointA : CGPoint
    var PointB : CGPoint
    var PointC : CGPoint
    var PointD : CGPoint
    init(){
        PointA = CGPoint(x: 0.0, y: 0.0)
        PointB = CGPoint(x: 0.0, y: 0.0)
        PointC = CGPoint(x: 0.0, y: 0.0)
        PointD = CGPoint(x: 0.0, y: 0.0)
    }
    init(origin:CGPoint, width:Double, height:Double){
        PointA = origin
        PointB = CGPoint(x: Double(origin.x) + width, y: Double(origin.y))
        PointC = CGPoint(x: Double(origin.x), y: Double(origin.y)+height)
        PointD = CGPoint(x: Double(origin.x) + width, y: Double(origin.y)+height)
    }
    mutating func moveTo(delta : CGPoint){
        PointA = CGPoint(x: Double(PointA.x) + Double(delta.x), y:Double(PointA.y) + Double(delta.y))
        PointB = CGPoint(x: Double(PointB.x) + Double(delta.x), y:Double(PointB.y) + Double(delta.y))
        PointC = CGPoint(x: Double(PointC.x) + Double(delta.x), y:Double(PointC.y) + Double(delta.y))
        PointD = CGPoint(x: Double(PointD.x) + Double(delta.x), y:Double(PointD.y) + Double(delta.y))
    }
}


print(MyRect())
var rect = MyRect(origin:CGPoint(x: 0.0, y: 0.0), width:5.0, height:10.0)
print(rect)
rect.moveTo(delta: CGPoint(x:-3,y:1.5))
print(rect)




// String 자르기

var birth = "93 12 28"
let separatedBirth = birth.components(separatedBy: " ")
print(separatedBirth[0])

birth = "931228"
var year = (birth as NSString).substring(to: 2)
var month = (birth as NSString).substring(with: NSMakeRange(2, 2))
var day = (birth as NSString).substring(with: NSMakeRange(4, 2))

var num =  birth.characters.count








