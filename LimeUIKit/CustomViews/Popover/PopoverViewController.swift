//
//  PopoverViewController.swift
//  LimeUIKit
//
//  Created by Миша Перевозчиков on 28.06.2023.
//

import UIKit


protocol QualityCellDelegate: AnyObject {
   
   func didSelect(_ stream: Stream)
}


final class PopoverViewController: UIViewController {
   
   @IBOutlet var tableView: UITableView!
   
   weak var delegate: QualityCellDelegate?
   
   
   var streams: [Stream]
   
   
   init(streams: [Stream]) {
	  self.streams = streams
	  super.init(nibName: "PopoverViewController", bundle: nil)
   }
   
   
   required init?(coder: NSCoder) {
	  fatalError("init(coder:) has not been implemented")
   }
   
   
   override func viewDidLoad() {
	  super.viewDidLoad()
	  
	  configure()
	  
   }
   
   
   func configure() {
	  
	  tableView.dataSource = self
	  tableView.delegate = self
	  tableView.register(UINib(nibName: CellsID.qualityCell, bundle: nil), forCellReuseIdentifier: CellsID.qualityCell)
	  tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
   }
}


//MARK: - UITableViewDataSource
extension PopoverViewController: UITableViewDataSource {
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
	  streams.count
   }
   
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
	  
	  let cell = tableView.dequeueReusableCell(withIdentifier: CellsID.qualityCell) as! QualityCell
	  let resolution = streams[indexPath.row].resolution
	  cell.setLabel(with: resolution)
	  return cell
   }
}


//MARK: - UITableViewDelegate
extension PopoverViewController: UITableViewDelegate {
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
	  
	  let cell = tableView.cellForRow(at: indexPath) as! QualityCell
	  
	  cell.label.textColor = .white
	  
	  let stream = streams[indexPath.row]
	  
	  delegate?.didSelect(stream)
	  
	  dismiss(animated: true, completion: nil)
   }
   
   
   func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
	  
	  let cell = tableView.cellForRow(at: indexPath) as! QualityCell
	  cell.label.textColor = .black
   }
}
