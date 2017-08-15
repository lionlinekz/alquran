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
import CoreData


@available(iOS 10.0, *)
class SuraViewController: UIViewController, UISearchBarDelegate {
  
    @IBOutlet weak var searchBar: UISearchBar!
  var sureler = [NSManagedObject]()
  //let surahs = Surah.surahsFromBundle()
  let surahToJuz = [
    1 : "1 пара",
    2 : "1-3 паралар",
    3 : "3-4 паралар",
    4 : "4-6 паралар",
    5 : "6-7 паралар",
    6: "7-8 паралар",
    7 : "8-9 паралар",
    8 : "9-10 паралар",
    9 : "10-11 паралар",
    10 : "11 пара",
    11 : "11-12 паралар",
    12 : "12-13 паралар",
    13 : "13 пара",
    14 : "13 пара",
    15 : "13 пара",
    16 : "14 пара",
    17 : "14 пара",
    18 : "15-16 паралар",
    19 : "16 пара",
    20 : "16 пара",
    21 : "16 пара",
    22 : "17 пара",
    23 : "17 пара",
    24 : "18 пара",
    25 : "18-19 паралар",
    26 : "19 пара",
    27 : "19-20 паралар",
    28 : "20 пара",
    29 : "20-21 паралар",
    30 : "21 пара",
    31 : "21 пара",
    32 : "21 пара",
    33 : "21-22 паралар",
    34 : "22 пара",
    35 : "22 пара",
    36 : "22-23 паралар",
    37 : "23 пара",
    38 : "23 пара",
    39 : "23-24 паралар",
    40 : "24 пара",
    41 : "24-25 паралар",
    42 : "25 пара",
    43 : "25 пара",
    44 : "25 пара",
    45 : "25 пара",
    46 : "25 пара",
    47 : "26 пара",
    48 : "26 пара",
    49 : "26 пара",
    50 : "26 пара",
    51 : "26-27 паралар",
    52 : "27 пара",
    53 : "27 пара",
    54 : "27 пара",
    55 : "27 пара",
    56 : "27 пара",
    57 : "27 пара",
    58 : "27 пара",
    59 : "28 пара",
    60 : "28 пара",
    61 : "28 пара",
    62 : "28 пара",
    63 : "28 пара",
    64 : "28 пара",
    65 : "28 пара",
    66 : "28 пара",
    67 : "28 пара",
    68 : "29 пара",
    69 : "29 пара",
    70 : "29 пара",
    71 : "29 пара",
    72 : "29 пара",
    73 : "29 пара",
    74 : "29 пара",
    75 : "29 пара",
    76 : "29 пара",
    77 : "29 пара",
    78 : "29 пара",
    79 : "30 пара",
    80 : "30 пара",
    81 : "30 пара",
    82 : "30 пара",
    83 : "30 пара",
    84 : "30 пара",
    85 : "30 пара",
    86 : "30 пара",
    87 : "30 пара",
    88 : "30 пара",
    89 : "30 пара",
    90 : "30 пара",
    91 : "30 пара",
    92 : "30 пара",
    93 : "30 пара",
    94 : "30 пара",
    95 : "30 пара",
    96 : "30 пара",
    97 : "30 пара",
    98 : "30 пара",
    99 : "30 пара",
    100 : "30 пара",
    101 : "30 пара",
    102 : "30 пара",
    103 : "30 пара",
    104 : "30 пара",
    105 : "30 пара",
    106 : "30 пара",
    107 : "30 пара",
    108 : "30 пара",
    109 : "30 пара",
    110 : "30 пара",
    111 : "30 пара",
    112 : "30 пара",
    113 : "30 пара",
    114 : "30 пара"
]
  
    var sorted = true
  
  func get_russian_tafsir(_ russian:String) -> String {
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
  
  func get_russian_aya(_ russian:String) -> String {
    if let rangeOfZero = russian.range(of: "[[",
                                               options: NSString.CompareOptions.backwards) {
      // Found a zero, get the following text
      let prefix = String(russian.characters.prefix(upTo: rangeOfZero.lowerBound))// "984"
      return prefix
      
    }
    return russian
    
  }
  
  func saveAyahsToCoreData(_ start_index: Int, length: Int, sura_index: Int) -> [Ayah] {
    
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
        let appDelegate =
          UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entity(forEntityName: "Ayah",
                                                        in:managedContext)
        
        let ayat = NSManagedObject(entity: entity!,
                                   insertInto: managedContext)
        ayat.setValue(kaz_name!, forKey: "kaz_meaning")
        ayat.setValue(arab_name!, forKey: "arab_name")
        ayat.setValue(transliteration!, forKey: "transliteration")
        ayat.setValue(eng_trans!, forKey: "eng_transliteration")
        ayat.setValue(english_name!, forKey: "eng_meaning")
        ayat.setValue(sura_index+1, forKey: "sura_index")
        ayat.setValue(j+1, forKey: "ayah_index_quran")
        ayat.setValue(i+1, forKey: "ayah_index_surah")
        ayat.setValue(get_russian_aya(russian_name!), forKey: "rus_meaning")
        ayat.setValue(get_russian_tafsir(russian_name!), forKey: "rus_tafsir")
                do {
                  try managedContext.save()
                  //5
                } catch let error as NSError  {
                  print("Could not save \(error), \(error.userInfo)")
                }
        
        
        
        
        
        j += 1
      }
      
    } catch {
      return ayahs
    }
    
    return ayahs
  }

  
  func wordsToCoreData() {
    
    guard let path = Bundle.main.path(forResource: "worddata", ofType: "json"),
      let data = try? Data(contentsOf: URL(fileURLWithPath: path))else{
        return
    }
    do {
      let rootObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any]
      
      guard let wordObjects = rootObject?["words"] as? [[String: AnyObject]] else {
        return
      }
      var i = 1
      for wordObject in wordObjects {
        print("word ",i);
        let fields = wordObject["fields"] as? [String: AnyObject]
        let ayat = fields!["ayat"] as? Int
        let index_to_quran = fields!["index_to_quran"] as? Int
        let index_to_ayat = fields!["index_to_ayat"] as? Int
        let arab = fields!["arab"] as? String
        let qazaq = fields!["qazaq"] as? String
        let audio = fields!["qazaq_comment"] as? String
        let rus = fields!["rus"] as? String
        let eng = fields!["eng"] as? String
        let eng_trans = fields!["eng_trans"] as? String

        let appDelegate =
          UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entity(forEntityName: "Word",
                                                        in:managedContext)
        
        let word = NSManagedObject(entity: entity!,
                                   insertInto: managedContext)
        word.setValue(ayat, forKey: "ayah")
        word.setValue(index_to_quran, forKey: "index_to_quran")
        word.setValue(index_to_ayat, forKey: "index_to_ayah")
        word.setValue(arab, forKey: "arab")
        word.setValue(qazaq, forKey: "kaz")
        word.setValue(audio, forKey: "audio")
        word.setValue(rus, forKey: "rus")
        word.setValue(eng, forKey: "eng")
        word.setValue(eng_trans, forKey: "eng_trans")
        do {
          try managedContext.save()
          //5
        } catch let error as NSError  {
          print("Could not save \(error), \(error.userInfo)")
        }
        
        
        
        
        
        
        
        i = i + 1
      }
      
    } catch {
    }
    
    
  }

  
  
   func surahsToCoreData() {
    
    guard let path = Bundle.main.path(forResource: "sureler", ofType: "json"),
      let data = try? Data(contentsOf: URL(fileURLWithPath: path))else{
        return
    }
    do {
      let rootObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any]
      
      guard let surahObjects = rootObject?["sureler"] as? [[String: AnyObject]] else {
        return
      }
      var i = 1
      for surahObject in surahObjects {
        let kaz_name = surahObject["FIELD6"] as? String,
        kaz_meaning = surahObject["FIELD7"]  as? String,
        arab_name = surahObject["FIELD5"] as? String,
        ayah_count = surahObject["FIELD2"] as? Int,
        city_type = surahObject["FIELD8"] as? String,
        start = surahObject["FIELD1"] as? Int

        let appDelegate =
          UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entity(forEntityName: "Sura",
                                                        in:managedContext)
        
        let sura = NSManagedObject(entity: entity!,
                                     insertInto: managedContext)
        sura.setValue(kaz_name, forKey: "kaz_name")
        sura.setValue(kaz_meaning, forKey: "kaz_meaning")
        sura.setValue(arab_name, forKey: "arab_name")
        sura.setValue(ayah_count, forKey: "ayah_count")
        sura.setValue(city_type, forKey: "city_type")
        sura.setValue(start, forKey: "start_number")
        sura.setValue(i, forKey: "index")
        do {
          try managedContext.save()
          //5
        } catch let error as NSError  {
          print("Could not save \(error), \(error.userInfo)")
        }

        
        

        
        
        
        i = i + 1
      }
      
    } catch {
    }
    
    
  }

  
  @IBOutlet weak var sortButton: UIBarButtonItem!
    @IBAction func sort(_ sender: UIBarButtonItem) {
      var image = UIImage(named: "asc.png")

        if (sorted){
            image = UIImage(named: "asc.png")

          sorted = false
        }else{
          image = UIImage(named: "desc.png")
          sorted = true
      }
      
      image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
      sortButton.image = image
      self.tableView.reloadData()
    }
  
  @IBOutlet weak var tableView: UITableView!
  var searchActive : Bool = false
  //var filtered:[Surah] = []
  var filteredSureler = [NSManagedObject]()


  
  override func viewDidLoad() {
    super.viewDidLoad()
    print("I am in viewdidload, showing suras")
    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String

    let documentsURL = URL(string: documentsPath)!
    print(documentsURL)
    searchBar.delegate = self
    let arabValue: Bool? = UserDefaults.standard.object(forKey: "arab") as? Bool
    if arabValue == nil{
      UserDefaults.standard.set(true, forKey: "arab")
      UserDefaults.standard.synchronize()
    }
    let kazValue: Bool? = UserDefaults.standard.object(forKey: "kaz") as? Bool
    if kazValue == nil{
      UserDefaults.standard.set(true, forKey: "kaz")
      UserDefaults.standard.synchronize()
    }
    let transValue: Bool? = UserDefaults.standard.object(forKey: "trans") as? Bool
    if transValue == nil{
      UserDefaults.standard.set(true, forKey: "trans")
      UserDefaults.standard.synchronize()
    }
    let rusValue: Bool? = UserDefaults.standard.object(forKey: "rus") as? Bool
    if rusValue == nil{
      UserDefaults.standard.set(false, forKey: "rus")
      UserDefaults.standard.synchronize()
    }
    let tafValue: Bool? = UserDefaults.standard.object(forKey: "taf") as? Bool
    if tafValue == nil{
      UserDefaults.standard.set(false, forKey: "taf")
      UserDefaults.standard.synchronize()
    }
    let engValue: Bool? = UserDefaults.standard.object(forKey: "eng") as? Bool
    if engValue == nil{
      UserDefaults.standard.set(false, forKey: "eng")
      UserDefaults.standard.synchronize()
    }
    let qazTrans: Bool? = UserDefaults.standard.object(forKey: "qazTrans") as? Bool
    if qazTrans == nil{
      UserDefaults.standard.set(true, forKey: "qazTrans")
      UserDefaults.standard.synchronize()
    }
    let qazWord: Int? = UserDefaults.standard.object(forKey: "qazWord") as? Int
    if qazWord == nil{
      UserDefaults.standard.set(1, forKey: "qazWord")
      UserDefaults.standard.synchronize()
    }
    let defLoaded: Bool? = UserDefaults.standard.object(forKey: "def") as? Bool
    if defLoaded == nil{
      UserDefaults.standard.set(true, forKey: "def")
      UserDefaults.standard.synchronize()
//      self.surahsToCoreData()
//      self.fetchObjects()
//      self.saveAyahs()
//      self.wordsToCoreData()
     self.fetchObjects()

    }else{
    //self.surahsToCoreData()
    self.fetchObjects()
    //self.saveAyahs()
    }
    

  }
  
  func saveAyahs(){
    var i = 1
    for sure in sureler{
      print (i)
      autoreleasepool {
        let index = sure.value(forKey: "index") as! Int
        saveAyahsToCoreData(sure.value(forKey: "start_number") as! Int, length: sure.value(forKey: "ayah_count") as! Int, sura_index: index-1)
      }
      
      i=i+1
    }
  }
  
  func fetchObjects(){
    let appDelegate =
      UIApplication.shared.delegate as! AppDelegate
    
    let managedContext = appDelegate.managedObjectContext
    
    //2
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Sura")
    
    //3
    do {
      let results =
        try managedContext.fetch(fetchRequest)
      sureler = results as! [NSManagedObject]
    } catch let error as NSError {
      print("Could not fetch \(error), \(error.userInfo)")
    }
  }
  
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    searchActive = false;
  }
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    searchActive = false;
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchActive = false;
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchActive = false;
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

    filteredSureler = sureler.filter({ (obj) -> Bool in
      String(describing: obj.value(forKey: "kaz_name")!).range(of: searchText, options: .caseInsensitive) != nil ||
      String(describing: obj.value(forKey: "kaz_meaning")!).range(of: searchText, options: .caseInsensitive) != nil ||
      String(describing: obj.value(forKey: "index")!).range(of: searchText, options: .caseInsensitive) != nil
    })
    if(filteredSureler.count == 0){
      searchActive = false;
    } else {
      searchActive = true;
    }
    self.tableView.reloadData()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if (filteredSureler.count>0 && filteredSureler.count<114){
      searchActive = true
    }
    if segue.identifier == "ShowArtist" {
      if let destination = segue.destination as? AyatViewController,
        let indexPath = tableView.indexPathForSelectedRow {
        var index = indexPath.row
        if (!sorted && index>0){
          index = 114 - indexPath.row
        }
        var sure = sureler[index]
        if(searchActive){
          sure = filteredSureler[index]
        }
        destination.selectedSure = sure

      }
    }
  }
}

@available(iOS 10.0, *)
extension SuraViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if(searchActive) {
      return filteredSureler.count
    }
    return sureler.count
    
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",
                                                           for: indexPath) as! SurahTableViewCell
    var index = indexPath.row
    if (!sorted && index>0){
      index = 114 - indexPath.row
    }
    //var sura = surahs[index]
    var sure = sureler[index]
    if(searchActive){
      // = filtered[index]
      sure = filteredSureler[index]
    }
    let view = UIView()
    let mycolor = UIColor(red: 0xf1, green: 0xca, blue: 0xd1)
    view.backgroundColor = mycolor
    cell.selectedBackgroundView = view
    
    //cell.name.text = String(sura.index) + ". " + sura.kaz_name+" ("+sura.kaz_meaning+")"
    cell.name.text = String(describing: sure.value(forKey: "index")!) + ". " + String(describing: sure.value(forKey: "kaz_name")!)+" ("+String(describing: sure.value(forKey: "kaz_meaning")!)+")"
    cell.arabic_name.text = sure.value(forKey: "arab_name") as? String //sura.arab_name
    cell.desc.text = String(describing: sure.value(forKey: "ayah_count")!) + " аят, "+String(describing: sure.value(forKey: "city_type")!) + ", " + String(surahToJuz[sure.value(forKey: "index") as! Int]!)
    return cell
  }
}


