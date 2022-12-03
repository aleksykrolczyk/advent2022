//
//  main.swift
//  advent2022
//
//  Created by Aleksy Krolczyk on 02/12/2022.
//
//

import Foundation

let start = DispatchTime.now()


//Day01(preload(dayNumber: "01")).solve()
//Day02(preload(dayNumber: "02")).solve()
Day03(preload(dayNumber: "03")).solve()
//Day04(preload(dayNumber: "04")).solve()
//Day05(preload(dayNumber: "05")).solve()
//Day06(preload(dayNumber: "06")).solve()
//Day07(preload(dayNumber: "07")).solve()
//Day08(preload(dayNumber: "08")).solve()
//Day09(preload(dayNumber: "09")).solve()
//Day10(preload(dayNumber: "10")).solve()

let end = DispatchTime.now()
let duration = end.uptimeNanoseconds - start.uptimeNanoseconds
print("took: \(Double(duration) / 1_000_000_000)" )