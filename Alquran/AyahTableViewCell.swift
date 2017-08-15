//
//  SurahTableViewCell.swift
//  Alquran
//
//  Created by Asset Sarsengaliyev on 8/18/16.
//  Copyright © 2016 Alquran. All rights reserved.
//

import UIKit

class AyahTableViewCell: SWTableViewCell {
  @IBOutlet weak var arab: FRHyperLabel!
  @IBOutlet var trans: FRHyperLabel!
  @IBOutlet var kaz: UILabel!
  @IBOutlet weak var ayahIndex: UILabel!
  @IBOutlet weak var rus: UILabel!
  @IBOutlet weak var eng: UILabel!
  @IBOutlet weak var button: UIButton!
  @IBOutlet weak var tafsir: UILabel!
    @IBOutlet weak var transliteration: UITextView!
  
    @IBOutlet weak var arabic: UITextView!
  override func prepareForReuse()
  {
    super.prepareForReuse()
    // Reset the cell for new row's data
  }
  
  
  
}

