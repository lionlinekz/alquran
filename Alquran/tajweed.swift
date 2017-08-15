//
//  tajweed.swift
//  Alquran
//
//  Created by Asset Sarsengaliyev on 3/20/17.
//  Copyright © 2017 Alquran. All rights reserved.
//

import Foundation

func checkForQalqala(ayat: String) -> Bool {
  var matched = matches(for: "(?:دْ|طْ)", in: ayat)
  if (matched.count>0){
    return true
  }
  matched = matches(for: "[ق|قِ|قُ|قْ|ق]$", in: ayat)
  if (matched.count>0){
    return true
  }
  return false
}

func checkForGhunna(ayat: String) -> Bool {
  let n_searchstr = "نّ"
  let m_searchstr = "مّ"
  let narabicMatch = ayat.range(of: n_searchstr, options: NSString.CompareOptions.diacriticInsensitive)
  let marabicMatch = ayat.range(of: m_searchstr, options: NSString.CompareOptions.diacriticInsensitive)
  if narabicMatch == nil && marabicMatch == nil{
    return false
  }
  return true
}

func matches(for regex: String, in text: String) -> [String] {
  
  do {
    let regex = try NSRegularExpression(pattern: regex)
    let nsString = text as NSString
    let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
    print(results[0].range.location, results[0].range.length)
    return results.map { nsString.substring(with: $0.range)}
  } catch let error {
    print("invalid regex: \(error.localizedDescription)")
    return []
  }
}

func  getQalqalaAddresses(ayat: String)->[NSRange] {
  return getRange(ayat: ayat, pattern: "")
}

func getRange(ayat:String, pattern:String)->[NSRange] {
  var ranges: [NSRange]
  do {
    let regex = try NSRegularExpression(pattern: pattern, options: [NSRegularExpression.Options.ignoreMetacharacters])
    ranges = regex.matches(in: ayat, options: [], range: NSMakeRange(0, ayat.characters.count)).map {$0.range}
  }
  catch {
    ranges = []
  }
  return ranges
}

func getGhunnaAddresses(ayat: String)->[NSRange] {
  let n_searchstr = "نّ"
  let m_searchstr = "مّ"
  var ranges: [NSRange]
  
  do {
    // Create the regular expression.
    let n_regex = try NSRegularExpression(pattern: n_searchstr, options: [NSRegularExpression.Options.ignoreMetacharacters])
    
    // Use the regular expression to get an array of NSTextCheckingResult.
    // Use map to extract the range from each result.
    let n_ranges = n_regex.matches(in: ayat, options: [], range: NSMakeRange(0, ayat.characters.count)).map {$0.range}
    let m_regex = try NSRegularExpression(pattern: m_searchstr, options: [NSRegularExpression.Options.ignoreMetacharacters])
    
    // Use the regular expression to get an array of NSTextCheckingResult.
    // Use map to extract the range from each result.
    let m_ranges = m_regex.matches(in: ayat, options: [], range: NSMakeRange(0, ayat.characters.count)).map {$0.range}
    ranges = concatTwoRanges(first: fixRanges(ranges: n_ranges, ayat: ayat), second: fixRanges(ranges: m_ranges, ayat: ayat))
  }
  catch {
    // There was a problem creating the regular expression
    ranges = []
  }
  return ranges
}

func fixRanges(ranges: [NSRange], ayat: String)->[NSRange]{
  var zanges: [NSRange]
  zanges = []
  for r in ranges{
    let index = r.length + r.location
    var i = 0
    for a in ayat.utf16{
      if index == i {
        if a>1610 && a<1622{
          print("hi")
          zanges.append(NSRange(location: r.location, length: r.length+1))
        }else{
          zanges.append(r)
        }
      }else if (i>index){
        break;
      }
      i += 1
    }
  }
  return zanges
}

func concatTwoRanges(first: [NSRange], second: [NSRange])->[NSRange] {
  var ranges: [NSRange]
  ranges = []
  for f in first{
    ranges.append(f)
  }
  for s in second{
    ranges.append(s)
  }
  return ranges
}

