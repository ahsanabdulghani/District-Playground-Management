//
//  MyBookingHistoryViewController.swift
//  FYPProject
//
//  Created by apple on 29/05/2023.
//

import UIKit

class MyBookingHistoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var bookingHistoryList = [Booking]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getBookingHistory()
    }
    
    @IBAction func Backbtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getBookingHistory() {
        let id = APIWrapper.userData.id
        let manager = BookingManager()
        bookingHistoryList = manager.getBookingHistory(id: id)
        print(bookingHistoryList)
        tableView.reloadData()
    }
}
extension MyBookingHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookingHistoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyBookingHistoryTableViewCell", for: indexPath) as! MyBookingHistoryTableViewCell
        
        let data = bookingHistoryList[indexPath.row]
        cell.lblGroundName.text = data.gname
        cell.lblfromdate.text = changeDateFormat(previousFormat: "yyyy-MM-dd'T'HH:mm:ss", newFormat: "dd MMM, yyyy", dateStr: data.Fromdate ?? "")
        cell.lbltodate.text = changeDateFormat(previousFormat: "yyyy-MM-dd'T'HH:mm:ss", newFormat: "dd MMM, yyyy", dateStr: data.Todate ?? "")
        cell.lblBookedby.text = data.c_name
        let startTime = changeDateFormat(previousFormat: "HH:mm:ss", newFormat: "h:mm a", dateStr: data.s_time ?? "")
        let endTime = changeDateFormat(previousFormat: "HH:mm:ss", newFormat: "h:mm a", dateStr: data.e_time ?? "")
        cell.lblTiming.text = "\(startTime) to \(endTime)"
        cell.lblAmount.text = String(data.amount ?? 0)
        cell.lblStatus.text = data.status
        
        if data.status == "pending" {
            cell.btnCancel.isHidden = true
            cell.btnGenerateBill.isHidden = true
        }
        else {
            cell.btnCancel.isHidden = true
            cell.btnGenerateBill.isHidden = false
        }
        
        cell.btnCancel.tag = indexPath.row
        cell.btnCancel.addTarget(self, action: #selector(onClickCancelBtn), for: .touchUpInside)
        cell.btnGenerateBill.tag = indexPath.row
        cell.btnGenerateBill.addTarget(self, action: #selector(onClickGenerateBillBtn), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
   
    @objc func onClickCancelBtn(_ sender: UIButton) {
        
    }
    
    @objc func onClickGenerateBillBtn(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(identifier: "GenerateBillViewController") as! GenerateBillViewController
        vc.bid = bookingHistoryList[sender.tag].id ?? 0
        vc.totalAmount = bookingHistoryList[sender.tag].amount ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

func changeDateFormat(previousFormat: String, newFormat: String, dateStr: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = previousFormat
    if let date = dateFormatter.date(from: dateStr) {
        dateFormatter.dateFormat = newFormat
        let dateStr = dateFormatter.string(from: date)
        return dateStr
    }
    return ""
}
