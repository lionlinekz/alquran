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


struct Surah {
  let kaz_name: String
  let kaz_meaning: String
  let arab_name: String
  let ayah_count:Int
  let city_type:String
  let juz: String
  let index: Int
  let start_number: Int
  
  
  init(kaz_name: String, kaz_meaning: String, arab_name: String, ayah_count: Int, city_type: String, juz: String, index: Int, start_number: Int) {
    self.kaz_name = kaz_name
    self.kaz_meaning = kaz_meaning
    self.arab_name = arab_name
    self.ayah_count = ayah_count
    self.city_type = city_type
    self.juz = juz
    self.index = index
    self.start_number = start_number
  }
  
  static func surahsFromBundle() -> [Surah] {
    
    var surahs = [Surah]()
    
    guard let path = Bundle.main.path(forResource: "sureler", ofType: "json"),
      let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
        return surahs
    }
    
    do {
      let rootObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any]
      
      guard let surahObjects = rootObject?["sureler"] as? [[String: AnyObject]] else {
        return surahs
      }
      var i = 1
      for surahObject in surahObjects {
        let kaz_name = surahObject["FIELD6"] as? String,
          kaz_meaning = surahObject["FIELD7"]  as? String,
          arab_name = surahObject["FIELD5"] as? String,
          ayah_count = surahObject["FIELD2"] as? Int,
          city_type = surahObject["FIELD8"] as? String,
          start = surahObject["FIELD1"] as? Int
        let surah = Surah(kaz_name: kaz_name!, kaz_meaning: kaz_meaning!, arab_name: arab_name!, ayah_count: ayah_count!, city_type: city_type!, juz:"", index: i, start_number: start!)
          surahs.append(surah)
        i = i + 1
      }
      
    } catch {
      return surahs
    }
    
    return surahs
  }
  
}
