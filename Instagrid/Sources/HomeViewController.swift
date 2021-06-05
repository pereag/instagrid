//
//  HomeViewController.swift
//  Instagrid
//
//  Created by Valc0d3 on 07/05/2021.
//

import UIKit

final class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - IBOutlets

    @IBOutlet private weak var viewTitleLabel: UILabel!
    @IBOutlet private weak var swipeLabel: UILabel!
    @IBOutlet private weak var swipeArrowImageview: UIImageView!
    
    @IBOutlet private weak var topLeftView: UIView!
    @IBOutlet private weak var topRightView: UIView!
    @IBOutlet private weak var bottomLeftView: UIView!
    @IBOutlet private weak var bottomRightView: UIView!

    // MARK: - Properties

    private lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary;
        imagePicker.allowsEditing = true
        return imagePicker
    }()

    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - IBActions

    @IBAction private func didPressLayoutOne() {
        bottomRightView.isHidden = false
        topRightView.isHidden = true
    }

    @IBAction private func didPressLayoutTwo() {
        bottomRightView.isHidden = true
        topRightView.isHidden = false
    }
    
    @IBAction private func didPressLayoutTree() {
        bottomRightView.isHidden = false
        topRightView.isHidden = false
    }
    
    @IBAction func didPressTopLeftButton() {
        openPhotoLibrary()
    }
    
    @IBAction func didPressTopRightButton() {
        openPhotoLibrary()
    }
    
    @IBAction func didPressBottomLeftButton() {
        openPhotoLibrary()
    }
    
    @IBAction func didPressBottomRightButton() {
        openPhotoLibrary()
    }
    
    // MARK: - Functions
    
    func openPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            self.present(imagePicker, animated: true, completion: nil)
        }
    }

    // MARK: - UIImagePickerControllerDelegate

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Did Cqncel")
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        
        let imageView = UIImageView(image: image)
        topLeftView.addSubview(imageView)
        picker.dismiss(animated: true, completion: nil)
    }
}



