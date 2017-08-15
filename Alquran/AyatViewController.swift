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
import AVFoundation
import ReachabilitySwift

@IBDesignable class UITextViewFixed: UITextView {
  override func layoutSubviews() {
    super.layoutSubviews()
    setup()
  }
  func setup() {
    textContainerInset = UIEdgeInsets.zero
    textContainer.lineFragmentPadding = 0
  }
}

class AyatViewController: UIViewController {
  
  @IBOutlet weak var searchBar: UISearchBar!
  var searchActive : Bool = false
  var filteredAyattar = [NSManagedObject]()
  var selectedSurah: Surah!
  var selectedSure: NSManagedObject!
  var ayahs = [Ayah]()
  var filteredAyahs = [Ayah]()
  var selectedButtonsArray: Set = [400]
  var suraAlaq: [[String]] = []
  var audioPlayer = AVAudioPlayer()
  var currentCell = SWTableViewCell()
  var isSet = 0
  var index = 0
  var ayatIndex = 0
  var arabValue = false
  var kazValue = false
  var transValue = false
  var rusValue = false
  var tafValue = false
  var engValue = false
  
  @IBOutlet weak var tableView: UITableView!
  
  @IBAction func showTafsir(sender: UIButton) {
    let ac = sender.superview?.superview?.superview?.superview as! AyahTableViewCell
    ac.button.isHidden = true
  }
  
  override func viewWillAppear(_ animated: Bool) {
    let ud = UserDefaults.standard
    arabValue = ud.bool(forKey: "arab")
    kazValue = ud.bool(forKey: "kaz")
    transValue = ud.bool(forKey: "trans")
    rusValue = ud.bool(forKey: "rus")
    tafValue = ud.bool(forKey: "taf")
    engValue = ud.bool(forKey: "eng")
    self.tableView.reloadData()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = selectedSure.value(forKey: "kaz_name") as? String
    _ = selectedSure.value(forKey: "start_number") as? Int
    _ = selectedSure.value(forKey: "ayah_count") as? Int
    let sura_index = selectedSure.value(forKey: "index") as? Int
    index = sura_index!
    fetchObjects()
    
    self.tableView.estimatedRowHeight = 197
    self.tableView.rowHeight = UITableViewAutomaticDimension
  }
}

extension UIColor {
  convenience init(red: Int, green: Int, blue: Int) {
    let newRed = CGFloat(red)/255
    let newGreen = CGFloat(green)/255
    let newBlue = CGFloat(blue)/255
    
    self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
  }
}

@available(iOS 10.0, *)
extension AyatViewController: UITableViewDataSource, UISearchBarDelegate, UITableViewDelegate, SWTableViewCellDelegate, UITextViewDelegate, AVAudioPlayerDelegate {
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return ayahs.count
  }
  
  @available(iOS 10.0, *)
  func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool{
    print("salem. alem")
    let indexes = URL.absoluteString.components(separatedBy: "-")
    let wordIndex = Int(indexes[0])!+1
    let ayahIndex = Int(indexes[1])
    let wordAyat = ayahs[ayahIndex!]
    var message = "not defined yet"
    var mpaudio = "00004.mp3"
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let managedContext = appDelegate.managedObjectContext
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Word")
    let predicate = NSPredicate(format: "ayah == %@ AND index_to_ayah = %@", argumentArray: [wordAyat.ayah_index_within_sura, wordIndex])
    fetchRequest.predicate = predicate
    var eng_trans_message = ""
    do {
      let results =
        try managedContext.fetch(fetchRequest)
      for managedObject in results {
        if (managedObject as AnyObject).value(forKey: "audio") != nil{
          let audio = (managedObject as AnyObject).value(forKey: "audio") as! String
          if (audio.characters.count>=8){
            print("audio")
            mpaudio = audio[audio.characters.index(audio.startIndex, offsetBy: 0)...audio.characters.index(audio.startIndex, offsetBy: 8)]
            print(mpaudio)
          }
        }else{
          print("something gone wrong")
        }
        let qw: Int! = UserDefaults.standard.object(forKey: "qazWord") as? Int
        if (qw == 1){
          if let kaz = (managedObject as AnyObject).value(forKey: "kaz"){
            message = kaz as! String
          }
        }else if (qw == 2){
          if let rus = (managedObject as AnyObject).value(forKey: "rus"){
            message = rus as! String
          }
        }
        else if (qw == 3){
          if let eng = (managedObject as AnyObject).value(forKey: "eng_trans"){
            message = eng as! String
          }
        }
        if let eng_trans = (managedObject as AnyObject).value(forKey: "eng_trans"){
          eng_trans_message = eng_trans as! String
          //eng_trans_message+" "+eng_trans_message+" "+eng_trans_message+" "+eng_trans_message+" "+eng_trans_message+" "+eng_trans_message+" "+eng_trans_message+" "+eng_trans_message+" "+eng_trans_message+" "+eng_trans_message+" "+eng_trans_message+" "+
          eng_trans_message = eng_trans_message.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        }
        
      }
    } catch let error as NSError {
      print("Could not fetch \(error), \(error.userInfo)")
    }
    let arabwords = ayahs[ayahIndex!].arab_name.components(separatedBy: " ")
    let modifiedFont = NSString(format:"<div style=\"font-family: Arial; text-align: center; margin-left:auto; margin-right: auto; margin-bottom:0; margin-top:10; font-size: 16\">%@</div>", eng_trans_message+"<br>"+message) as String
    let eng_attrStr = try! NSAttributedString(
      data: modifiedFont.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
      options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
      documentAttributes: nil)
    print(eng_trans_message)
    let alert = UIAlertController(title: arabwords[wordIndex-1], message: eng_trans_message, preferredStyle: UIAlertControllerStyle.alert)
    alert.setValue(eng_attrStr, forKey: "attributedMessage")
    alert.view.tintColor = UIColor(red: 0x86, green: 0x14, blue: 0x27)
    alert.addAction(UIAlertAction(title: "♫ аудио ", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
      print("Handle Ok logic here")
      self.present(alert, animated: true, completion: nil)
      do{
        let reachability = try Reachability(hostname: "http://audio.recitequran.com/wbw/arabic/wisam_sharieff/")
        
        //if the Internet is reachable
        if reachability.isReachable() == true {
          let url = "http://audio.recitequran.com/wbw/arabic/wisam_sharieff/"+mpaudio
          let fileURL = Foundation.URL(string:url)
          let soundData = try? Data(contentsOf: fileURL!)
          if soundData != nil{
            self.audioPlayer =  try AVAudioPlayer(data: soundData!)
            self.audioPlayer.prepareToPlay()
            self.audioPlayer.volume = 1.0
            //self.audioPlayer.delegate = self
            self.audioPlayer.play()
          }
          
          print ("hi")
        }else {
          let alert = UIAlertController(title: "Интернет жоқ", message:  "Байланысты тексеріңіз", preferredStyle: UIAlertControllerStyle.alert)
          alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
          self.present(alert, animated: true, completion: nil)
        }
      }
      catch {
        print("Error getting the audio file")
      }
    }))
    alert.addAction(UIAlertAction(title: "кері", style: UIAlertActionStyle.default, handler: nil))
    
    self.present(alert, animated: true, completion: nil)
    alert.view.tintColor = UIColor(red: 0x86, green: 0x14, blue: 0x27)
    return false
  }
  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool){
    let cell = currentCell
    let img = UIImage(named:"bordoplay.png")
    (cell.rightUtilityButtons[1] as AnyObject).setImage(img, for: UIControlState())
    
  }
  
  
  func swipeableTableViewCell(_ cell: SWTableViewCell!, didTriggerRightUtilityButtonWith index: Int) {
    if index == 0 {
      do {
        let mycell = cell as! AyahTableViewCell
        let urlString = mycell.kaz.text! + " (" + mycell.ayahIndex.text!+")"
        //let objectsToShare = [urlString]
        let urlStringEncoded = urlString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        let url  = NSURL(string: "whatsapp://send?text=\(urlStringEncoded!)")
          UIApplication.shared.open(url! as URL, options: [:],
                                    completionHandler: {
                                      (success) in
          })
      }
      
    }else {
      do{
        let reachability = try Reachability(hostname: "http://www.everyayah.com")
        
        //if the Internet is reachable
        if reachability.isReachable() == true {
          if isSet > 0{ //initialising for the first time
            let cell = currentCell
            let img = UIImage(named:"bordoplay.png")
            (cell.rightUtilityButtons[1] as AnyObject).setImage(img, for: UIControlState())
          }
          
          do {
            let mycell = cell as! AyahTableViewCell
            var suraIndex = 1
            var ayahIndex = 1
            if (mycell.ayahIndex.text != ""){
              let indexes = mycell.ayahIndex.text!.components(separatedBy: ":")
              suraIndex = Int(indexes[0])!
              ayahIndex = Int(indexes[1])!
            }
            if ayahIndex == ayatIndex && self.audioPlayer.isPlaying{
              self.audioPlayer.stop()
            }else{
              ayatIndex = ayahIndex
              
              let img = UIImage(named:"ppp.png")
              (cell.rightUtilityButtons[1] as AnyObject).setImage(img, for: UIControlState())
              print ("audio play try", suraIndex, ayahIndex)
              
              let url = "http://www.everyayah.com/data/Alafasy_128kbps/"+String(format: "%03d", suraIndex)+String(format: "%03d", ayahIndex)+".mp3"
              let fileURL = URL(string:url)
              let soundData = try? Data(contentsOf: fileURL!)
              if soundData != nil{
                self.audioPlayer =  try AVAudioPlayer(data: soundData!)
                audioPlayer.prepareToPlay()
                audioPlayer.volume = 1.0
                audioPlayer.delegate = self
                let backgroundQueue = DispatchQueue.global()
                backgroundQueue.async(execute: {
                  self.audioPlayer.play()
                })
                currentCell = cell
                isSet = 1
                print(index)
              }
            }
          } catch {
            print("Error getting the audio file")
          }
        } else {
          let alert = UIAlertController(title: "Интернет жоқ", message:  "Байланысты тексеріңіз", preferredStyle: UIAlertControllerStyle.alert)
          alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
          self.present(alert, animated: true, completion: nil)
        }
        
      }
      catch {
        print("Error getting the audio file")
      }
      
    }
  }
  
  func fetchObjects(){
    let appDelegate =
      UIApplication.shared.delegate as! AppDelegate
    
    let managedContext = appDelegate.managedObjectContext
    //let managedContext = appDelegate.persistentContainer.viewContext
    
    //2
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Ayah")
    if (index > 1 && index != 9){
      print("not ninth sura")
      let predicate = NSPredicate(format: "%K == %D", "sura_index", 1)
      fetchRequest.predicate = predicate
      do {
        let results =
          try managedContext.fetch(fetchRequest)
        let managedObject = results[0]
        if let arab_name = (managedObject as AnyObject).value(forKey: "arab_name"), let ayah_index_quran = (managedObject as AnyObject).value(forKey: "ayah_index_quran"), let ayah_index_surah = (managedObject as AnyObject).value(forKey: "ayah_index_surah"),
          let eng_meaning = (managedObject as AnyObject).value(forKey: "eng_meaning"), let eng_transliteration = (managedObject as AnyObject).value(forKey: "eng_transliteration"), let kaz_meaning = (managedObject as AnyObject).value(forKey: "kaz_meaning"),
          let rus_meaning = (managedObject as AnyObject).value(forKey: "rus_meaning"), let rus_tafsir = (managedObject as AnyObject).value(forKey: "rus_tafsir"), let sura_index = (managedObject as AnyObject).value(forKey: "sura_index"),
          let transliteration = (managedObject as AnyObject).value(forKey: "transliteration"){
          let ayat = Ayah(arab_name: arab_name as! String, kaz_meaning: kaz_meaning as! String, transliteration: transliteration as! String, rus_meaning: rus_meaning as! String, rus_tafsir: rus_tafsir as! String, eng_trans: eng_transliteration as! String, english_name: eng_meaning as! String, si:sura_index as! Int, ais: ayah_index_surah as! Int, aiq: ayah_index_quran as! Int)
          ayahs.append(ayat)
        }
      }catch{
        print("failed to add bismillah")
      }
      
    }
    let predicate = NSPredicate(format: "%K == %D", "sura_index", index)
    fetchRequest.predicate = predicate
    
    
    //3
    do {
      let results =
        try managedContext.fetch(fetchRequest)
      for managedObject in results {
        if let arab_name = (managedObject as AnyObject).value(forKey: "arab_name"), let ayah_index_quran = (managedObject as AnyObject).value(forKey: "ayah_index_quran"), let ayah_index_surah = (managedObject as AnyObject).value(forKey: "ayah_index_surah"),
          let eng_meaning = (managedObject as AnyObject).value(forKey: "eng_meaning"), let eng_transliteration = (managedObject as AnyObject).value(forKey: "eng_transliteration"), let kaz_meaning = (managedObject as AnyObject).value(forKey: "kaz_meaning"),
          let rus_meaning = (managedObject as AnyObject).value(forKey: "rus_meaning"), let rus_tafsir = (managedObject as AnyObject).value(forKey: "rus_tafsir"), let sura_index = (managedObject as AnyObject).value(forKey: "sura_index"),
          let transliteration = (managedObject as AnyObject).value(forKey: "transliteration")
        {
          let ayat = Ayah(arab_name: arab_name as! String, kaz_meaning: kaz_meaning as! String, transliteration: transliteration as! String, rus_meaning: rus_meaning as! String, rus_tafsir: rus_tafsir as! String, eng_trans: eng_transliteration as! String, english_name: eng_meaning as! String, si:sura_index as! Int, ais: ayah_index_surah as! Int, aiq: ayah_index_quran as! Int)
          ayahs.append(ayat)
        }
      }
      //sureler = results as! [NSManagedObject]
    } catch let error as NSError {
      print("Could not fetch \(error), \(error.userInfo)")
    }
  }
  
  func setupHtmlLinkTextStyle(attributedString: NSAttributedString) -> NSMutableAttributedString {
    let updatedString = NSMutableAttributedString(attributedString: attributedString)
    attributedString.enumerateAttribute(NSLinkAttributeName,
                                        in: NSRange(location: 0, length: attributedString.length),
                                        options: [],
                                        using:
      {(attribute, range, stop) in
        if attribute != nil {
          var attributes = updatedString.attributes(at: range.location, longestEffectiveRange: nil, in: range)
          attributes[NSForegroundColorAttributeName] = UIColor.green
          attributes[NSUnderlineColorAttributeName] = UIColor.green
          attributes[NSStrokeColorAttributeName] = UIColor.black
          attributes["CustomLinkAttribute"] = attribute!
          attributes.removeValue(forKey: NSLinkAttributeName)
          updatedString.setAttributes(attributes, range: range)
        }
    })
    return updatedString
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if ((index == 1 || index == 9) || (indexPath.row > 0)){
      let cell = tableView.dequeueReusableCell(withIdentifier: "AyahCell", for: indexPath) as! AyahTableViewCell
      
      cell.arabic.isHidden = !arabValue
      cell.kaz.isHidden = !kazValue
      cell.rus.isHidden = !rusValue
      cell.tafsir.isHidden = !tafValue
      cell.transliteration.isHidden = !transValue
      cell.eng.isHidden = !engValue
      
      //
      //    let arabValue: Bool! = NSUserDefaults.standardUserDefaults().objectForKey("arab") as? Bool
      //    let kazValue: Bool! = NSUserDefaults.standardUserDefaults().objectForKey("kaz") as? Bool
      //    let transValue: Bool? = NSUserDefaults.standardUserDefaults().objectForKey("trans") as? Bool
      //    let rusValue: Bool? = NSUserDefaults.standardUserDefaults().objectForKey("rus") as? Bool
      //    let tafValue: Bool? = NSUserDefaults.standardUserDefaults().objectForKey("taf") as? Bool
      //    let engValue: Bool? = NSUserDefaults.standardUserDefaults().objectForKey("eng") as? Bool
      
      if arabValue {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 20
        paragraphStyle.alignment = NSTextAlignment.right
        let attrString = NSMutableAttributedString(string: ayahs[indexPath.row].arab_name, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 24)])
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        if checkForGhunna(ayat: ayahs[indexPath.row].arab_name){
          let addresses = getGhunnaAddresses(ayat: ayahs[indexPath.row].arab_name)
          for address in addresses{
            //let myRange = NSRange(location: address, length: 1)
            //if ayahs[indexPath.row].arab_name.contains("مَّ"){
            attrString.addAttribute(NSForegroundColorAttributeName, value: UIColor.orange, range: address)
            
            //cell.arab.linkTextAttributes
            //textView(,, shouldInteractWith: <#T##URL#>, in: <#T##NSRange#>)
            //attrString.link
          }
          //}
        }
        let arabwords = ayahs[indexPath.row].arab_name.components(separatedBy: " ")
        var startindex = 0
        for (index, arabword) in arabwords.enumerated() {
          if (index<arabwords.count){
            let newStr = String(index)+"-"+String(indexPath.row)
            print(newStr)
            attrString.addAttribute(NSLinkAttributeName, value: newStr, range: NSRange(location: startindex, length: arabword.utf16.count))
            startindex = startindex + arabword.utf16.count+1
            
          }
        }
        //attrString = setupHtmlLinkTextStyle(attributedString: attrString)
        
        cell.arabic.attributedText = attrString
        cell.arabic.delegate = self
        
      }
      
      if transValue {
        let qazTrans: Bool! = UserDefaults.standard.object(forKey: "qazTrans") as? Bool
        if qazTrans!{
          let modifiedFont = NSString(format:"<span style=\"font-family: Helvetica Neue Italic; font-style: italic; font-size: 16\">%@</span>", ayahs[indexPath.row].transliteration) as String
          let attrStr = try! NSMutableAttributedString(
            data: modifiedFont.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
            options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil)
          cell.transliteration.attributedText = attrStr
        }else{
          let modifiedFont = NSString(format:"<span style=\"font-family: Helvetica Neue Italic; font-style: italic; font-size: 16\">%@</span>", ayahs[indexPath.row].eng_transliteration) as String
          let eng_attrStr = try! NSMutableAttributedString(
            data: modifiedFont.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
            options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil)
          let transwords = ayahs[indexPath.row].eng_transliteration.components(separatedBy: " ")
          var startindex = 0
          for (i, t) in transwords.enumerated(){
            print(i, t)
            let newStr = String(i)+"-"+String(indexPath.row)
            let str = t.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            print("add", newStr, str, startindex)
            eng_attrStr.addAttribute(NSLinkAttributeName, value: newStr, range: NSRange(location: startindex, length: str.characters.count))
            startindex = startindex + str.characters.count+1
          }
          
          cell.transliteration.attributedText = eng_attrStr
          cell.transliteration.delegate = self

        }
      }
      if kazValue {
        cell.kaz.text = String(ayahs[indexPath.row].kaz_meaning)
      }
      if rusValue {
        cell.rus.text = ayahs[indexPath.row].rus_meaning
      }
      //cell.rus.attributedText = ats
      if engValue {
        cell.eng.text = ayahs[indexPath.row].eng_meaning
      }
      if tafValue {
        cell.tafsir.text = ayahs[indexPath.row].rus_tafsir
      }
      
      
      
      
      //cell.textLabel?.text = ayahs[indexPath.row].arab_name
      
      cell.delegate = self;
      let rutilityButtons: NSMutableArray = NSMutableArray()
      
      
      //cell.arab.setLinkForRange(mNSRange, withLinkHandler: handler)
      
      
      
      
      let mycolor = UIColor(red: 0xFF, green: 0xf5, blue: 0xf4)
      rutilityButtons.sw_addUtilityButton(with: mycolor, icon: UIImage(named:"share.png"))
      rutilityButtons.sw_addUtilityButton(with: mycolor, normalIcon: UIImage(named: "bordoplay.png"), selectedIcon: UIImage(named: "ppp.png"))
      
      
      cell.rightUtilityButtons = rutilityButtons as [AnyObject];
      if (indexPath.row > 0 && index > 1 && index != 9){
        
        cell.ayahIndex.text = String(index)+":"+String(indexPath.row)
      }else if (index == 1 || index == 9){
        cell.ayahIndex.text = String(index)+":"+String(indexPath.row+1)
      }else{
        cell.ayahIndex.text = ""
      }
      return cell}
    else{
      let cell = tableView.dequeueReusableCell(withIdentifier: "Bismillah", for: indexPath) as! AyahTableViewCell
      return cell
      
      
    }
  }
}


