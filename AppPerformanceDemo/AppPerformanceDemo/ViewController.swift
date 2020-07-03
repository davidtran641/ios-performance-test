//
//  ViewController.swift
//  AppPerformanceDemo
//
//  Created by Tran Duc on 7/3/20.
//

import UIKit

final class ViewController: UIViewController {

  private lazy var dataSource = TableViewDataSource(imageLoader: ImageLoader())
  private var tableView: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    loadItemList()
  }

  private func setupView() {
    self.tableView = UITableView(frame: self.view.frame)
    self.view.addSubview(tableView)
    dataSource.register(for: tableView)
  }

  private func loadItemList() {
    let itemList = [
      Item(title: "Item 1", imageUrl: "https://images5.alphacoders.com/108/1082961.jpg"),
      Item(title: "Item 2", imageUrl: "https://images2.alphacoders.com/716/71660.jpg"),
      Item(title: "Item 3", imageUrl: "https://images5.alphacoders.com/108/1081917.jpg"),
      Item(title: "Item 4", imageUrl: "https://images3.alphacoders.com/689/689452.jpg"),
      Item(title: "Item 5", imageUrl: "https://images4.alphacoders.com/572/5726.jpg"),
    ]

    dataSource.updateItemList(itemList + itemList + itemList)
    self.tableView.reloadData()
  }
}

struct Item {
  var title: String
  var imageUrl: String
}

final class TableViewDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
  private enum Constants {
    static let cellId = "cell"
  }

  private var itemList: [Item] = []
  private let imageLoader: ImageLoader

  init(imageLoader: ImageLoader) {
    self.imageLoader = imageLoader
    super.init()
  }

  func updateItemList(_ itemList: [Item]) {
    self.itemList = itemList
  }

  func register(for tableView: UITableView) {
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cellId)

    tableView.dataSource = self
    tableView.delegate = self
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemList.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellId, for: indexPath)
    let item = itemList[indexPath.row]
    cell.textLabel?.text = item.title

    imageLoader.loadImage(from: URL(string: item.imageUrl)!) { (image) in
//      cell.imageView?.image = image
    }
    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }

}

final class ImageLoader {
  func loadImage(from url: URL, handler: @escaping (UIImage?) -> Void) {
    URLSession.shared.dataTask(with: url) { (data, response, error) in
      if let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
         let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
         let data = data, error == nil,
         let image = UIImage(data: data) {
        DispatchQueue.main.async {
          handler(image)
        }
      } else {
        DispatchQueue.main.async {
          handler(nil)
        }
      }
    }.resume()
  }
}
