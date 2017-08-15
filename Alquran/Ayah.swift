/*
 * Copyright (c) 2016 Asset Sarsengaliyev
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */


import UIKit

struct Ayah {
  let arab_name: String
  let kaz_meaning: String
  let transliteration: String
  let rus_meaning:String
  let rus_tafsir:String
  let eng_transliteration: String
  let eng_meaning: String
  let sura_index: Int
  let ayah_index_within_sura: Int
  let ayah_index_within_quran: Int

  
  
  init(arab_name: String, kaz_meaning: String, transliteration: String, rus_meaning: String, eng_trans: String, english_name: String, si:Int, ais: Int, aiq: Int) {
    self.arab_name = arab_name
    self.kaz_meaning = kaz_meaning
    self.transliteration = transliteration
    self.rus_meaning = Ayah.get_russian_aya(rus_meaning)
    self.rus_tafsir = Ayah.get_russian_tafsir(rus_meaning)
    self.eng_transliteration = eng_trans
    self.eng_meaning = english_name
    self.sura_index = si
    self.ayah_index_within_sura = ais
    self.ayah_index_within_quran = aiq
  }
  
  init(arab_name: String, kaz_meaning: String, transliteration: String, rus_meaning: String, rus_tafsir: String, eng_trans: String, english_name: String, si:Int, ais: Int, aiq: Int) {
    self.arab_name = arab_name
    self.kaz_meaning = kaz_meaning
    self.transliteration = transliteration
    self.rus_meaning = rus_meaning
    self.rus_tafsir = rus_tafsir
    self.eng_transliteration = eng_trans
    self.eng_meaning = english_name
    self.sura_index = si
    self.ayah_index_within_sura = ais
    self.ayah_index_within_quran = aiq
  }
  
  static func get_russian_tafsir(_ russian:String) -> String {
    if let rangeOfZero = russian.range(of: "[[",
                                            options: NSString.CompareOptions.backwards) {
      // Found a zero, get the following text
      let suffix = String(russian.characters.suffix(from: rangeOfZero.upperBound)) // "984"
      //print (suffix)
      let rangeOfTLD = Range(suffix.startIndex..<suffix.characters.index(suffix.endIndex, offsetBy: -2))
      let tld = suffix[rangeOfTLD] // "com"
      return tld
      
    }
    return ""
  }
  
  static func get_russian_aya(_ russian:String) -> String {
    if let rangeOfZero = russian.range(of: "[[",
                                            options: NSString.CompareOptions.backwards) {
      // Found a zero, get the following text
      let prefix = String(russian.characters.prefix(upTo: rangeOfZero.lowerBound))// "984"
      return prefix
      
    }
    return russian

  }
  
  static func ayahsFromBundle(_ start_index: Int, length: Int, sura_index: Int) -> [Ayah] {
    
    var ayahs = [Ayah]()
    
    guard let path = Bundle.main.path(forResource: "ayattar", ofType: "json"),
      let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
        return ayahs
    }
    guard let arab_path = Bundle.main.path(forResource: "quran", ofType: "json"),
      let arab_data = try? Data(contentsOf: URL(fileURLWithPath: arab_path)) else {
        return ayahs
    }
    guard let russian_path = Bundle.main.path(forResource: "russian", ofType: "json"),
      let russian_data = try? Data(contentsOf: URL(fileURLWithPath: russian_path)) else {
        return ayahs
    }
    guard let english_path = Bundle.main.path(forResource: "english", ofType: "json"),
      let english_data = try? Data(contentsOf: URL(fileURLWithPath: english_path)) else {
        return ayahs
    }

    guard let engtrans_path = Bundle.main.path(forResource: "transliteration", ofType: "json"),
      let engtrans_data = try? Data(contentsOf: URL(fileURLWithPath: engtrans_path)) else {
        return ayahs
    }

    
    do {
     let arabRootObject = try JSONSerialization.jsonObject(with: arab_data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any]
      let russianRootObject = try JSONSerialization.jsonObject(with: russian_data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any]
      let rootObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any]
      let engtransRootObject = try JSONSerialization.jsonObject(with: engtrans_data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any]
      let englishObject = try JSONSerialization.jsonObject(with: english_data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any]


      
      guard let ayahObjects = rootObject?["ayattar"] as? [[String: AnyObject]] else {
        return ayahs
      }
      guard let arabAyahObjects = arabRootObject?["sura"] as? [[String: AnyObject]] else {
        return ayahs
      }
      guard let russianAyahObjects = russianRootObject?["sura"] as? [[String: AnyObject]] else {
        return ayahs
      }
      guard let englishAyahObjects = englishObject?["sura"] as? [[String: AnyObject]] else {
        return ayahs
      }
      guard let engtransAyahObjects = engtransRootObject?["Chapter"] as? [[String: AnyObject]] else {
        return ayahs
      }
      var suraObject = arabAyahObjects[sura_index]
      var russianSuraObject = russianAyahObjects[sura_index]
      var engtransSuraObject = engtransAyahObjects[sura_index]
      var englishSuraObject = englishAyahObjects[sura_index]
      var arab_ayahs = suraObject["aya"] as? [[String: AnyObject]]
      var russian_ayahs = russianSuraObject["aya"] as? [[String: AnyObject]]
      var engtrans_ayahs = engtransSuraObject["Verse"] as? [[String:AnyObject]]
      var english_ayahs = englishSuraObject["aya"] as? [[String: AnyObject]]
      var j = 0
      for i in start_index ..< start_index+length {
        var ayahObject = ayahObjects[i]
        var arabAya = arab_ayahs![j]
        var russianAya = russian_ayahs![j]
        var engtransAya = engtrans_ayahs![j]
        var englishAya = english_ayahs![j]
        //var arabAyahObject = arabAyahObjects[i]
        //NSLog(String(arabAyahObject))
        let kaz_name = ayahObject["Kk value"] as? String
        let transliteration = ayahObject["Cyr value"] as? String
        let arab_name = arabAya["-text"] as? String
        let russian_name = russianAya["-text"] as? String
        let english_name = englishAya["-text"] as? String
        let eng_trans = engtransAya["#cdata-section"] as? String
        let ayah = Ayah(arab_name: arab_name!, kaz_meaning: kaz_name!, transliteration: transliteration!, rus_meaning: russian_name!, eng_trans: eng_trans!, english_name: english_name!, si: sura_index-1, ais: j+1, aiq: i+1)
        ayahs.append(ayah)
        
                
        j += 1
      }
      
    } catch {
      return ayahs
    }
    
    return ayahs
  }
  
}
