//
//  FilterViewController.swift
//  growlers
//
//  Created by Chris Budro on 5/1/15.
//  Copyright (c) 2015 chrisbudro. All rights reserved.
//

import UIKit

protocol FilterDelegate: class {
  func filterWasUpdated(filter: Filter)
  
}

class FilterViewController: UITableViewController {
  
  //MARK: Constants
  let kSliderValueMultiplier: Float = 50
  let kSliderMinimumValue: Float = 0.02
  
  //MARK: Outlets
  @IBOutlet weak var clearFilterCell: UITableViewCell!
  @IBOutlet weak var breweriesSelectedLabel: UILabel!
  @IBOutlet weak var stylesSelectedLabel: UILabel!
  @IBOutlet weak var retailersSelectedLabel: UILabel!
  
  @IBOutlet weak var sortByTimeCell: UITableViewCell!
  @IBOutlet weak var sortByBreweryCell: UITableViewCell!
  @IBOutlet weak var sortByBeerCell: UITableViewCell!
  
  @IBOutlet weak var retailerFilterCell: UITableViewCell!
  @IBOutlet weak var breweryFilterCell: UITableViewCell!
  @IBOutlet weak var categoryFilterCell: UITableViewCell!
  
  @IBOutlet weak var abvMinTextField: UITextField!
  @IBOutlet weak var abvMaxTextField: UITextField!
  
  @IBOutlet weak var distanceSlider: UISlider!
  @IBOutlet weak var distanceCell: UITableViewCell!
  
  @IBOutlet weak var chooseLocationCell: UITableViewCell!
  @IBOutlet weak var selectedLocationLabel: UILabel!
  
  //MARK: Properties
  weak var delegate: FilterDelegate?
  var filter: Filter!
  
  //MARK: Life Cycle Methods
  override func viewDidLoad() {
    abvMinTextField.delegate = self
    abvMaxTextField.delegate = self
    
    distanceSlider.addTarget(self, action: "sliderValueChanged:", forControlEvents: .TouchUpInside)
    distanceSlider.minimumValue = kSliderMinimumValue
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    setLabels()
  }
  
  //MARK: Helper Methods
  func setBreweryLabel() {
    if (filter.breweryIds.isEmpty) {
      breweriesSelectedLabel.text = "All Breweries"
    } else {
      let breweryText = filter.breweryIds.count == 1 ? "Brewery" : "Breweries"
      breweriesSelectedLabel.text = "\(filter.breweryIds.count) \(breweryText) Selected"
    }
  }
  
  func setCategoryLabel() {
    if (filter.categoryIds.isEmpty) {
      stylesSelectedLabel.text = "All Categories"
    } else {
      let categoryText = filter.categoryIds.count == 1 ? "Category" : "Categories"
      stylesSelectedLabel.text = "\(filter.categoryIds.count) \(categoryText) Selected"
    }
    
  }
  
  func setRetailerLabel() {
    if (filter.retailerIds.isEmpty) {
      retailersSelectedLabel.text = "All Retailers"
    } else {
      let retailerText = filter.retailerIds.count == 1 ? "Retailer" : "Retailers"
      retailersSelectedLabel.text = "\(filter.retailerIds.count) \(retailerText) Selected"
    }
  }
  
  func setSortOrder() {
    if filter.sortDescriptor.key == SortOrder.WhenTapped.rawValue {
      sortByTimeCell.accessoryType = .Checkmark
      sortByBeerCell.accessoryType = .None
      sortByBreweryCell.accessoryType = .None
    } else if filter.sortDescriptor.key == SortOrder.Brewery.rawValue {
      sortByBreweryCell.accessoryType = .Checkmark
      sortByTimeCell.accessoryType = .None
      sortByBeerCell.accessoryType = .None
    } else if filter.sortDescriptor.key == SortOrder.Beer.rawValue {
      sortByBeerCell.accessoryType = .Checkmark
      sortByBreweryCell.accessoryType = .None
      sortByTimeCell.accessoryType = .None
    }
  }
  
  func setDistanceSlider() {
    distanceSlider.setValue(Float(LocationService.shared.searchRadiusInMiles) / kSliderValueMultiplier, animated: true)
  }
  
  func setSelectedLocationLabel() {
    LocationService.shared.selectedLocationIfAvailable { (locationDetails, error) -> Void in
      if let locationDetails = locationDetails {
        self.selectedLocationLabel.text = locationDetails.name
      }
    }
  }

  func setLabels() {
    setBreweryLabel()
    setCategoryLabel()
    setRetailerLabel()
    setSortOrder()
    setDistanceSlider()
    setSelectedLocationLabel()
    
    abvMinTextField.text = "\(filter.abvRange.min)"
    abvMaxTextField.text = "\(filter.abvRange.max)"
  }
  
  //MARK: Actions
  @IBAction func doneWasPressed(sender: UIBarButtonItem) {
    abvMinTextField.resignFirstResponder()
    abvMaxTextField.resignFirstResponder()
    if filter.isDirty || LocationService.shared.locationIsDirty {
      delegate?.filterWasUpdated(filter)
    }
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func cancelWasPressed(sender: UIBarButtonItem) {
    filter.isDirty = false
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func sliderValueChanged(slider: UISlider) {
    let maxDistance = Double(round(slider.value * kSliderValueMultiplier))
    LocationService.shared.setSearchRadius(maxDistance)
  }
}

//MARK: Table View Delegate
extension FilterViewController {
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    switch tableView.cellForRowAtIndexPath(indexPath)! {
    case clearFilterCell:
      filter.clearFilter()
    case sortByBeerCell:
      filter.sortDescriptor = NSSortDescriptor(key: SortOrder.Beer.rawValue, ascending: true)
    case sortByBreweryCell:
      filter.sortDescriptor = NSSortDescriptor(key: SortOrder.Brewery.rawValue, ascending: true)
    case sortByTimeCell:
      filter.sortDescriptor = NSSortDescriptor(key: SortOrder.WhenTapped.rawValue, ascending: true)
      
      
    case retailerFilterCell:
      let vc = RetailerFilterTableViewController(style: .Plain)
      vc.queryManager = QueryManager(type: .Retailer, filter: filter)
      vc.delegate = self
      navigationController?.pushViewController(vc, animated: true)
    case breweryFilterCell:
      let vc = BreweryFilterTableViewController(style: .Plain)
      vc.queryManager = QueryManager(type: .Brewery, filter: filter)
      vc.delegate = self
      navigationController?.pushViewController(vc, animated: true)
    case categoryFilterCell:
      let vc = StyleFilterTableViewController(style: .Plain)
      vc.queryManager = QueryManager(type: .BeerStyle, filter: filter)
      vc.delegate = self
      navigationController?.pushViewController(vc, animated: true)
      
      
    case chooseLocationCell:
      let vc = LocationSearchTableViewController()
      vc.delegate = self
      navigationController?.pushViewController(vc, animated: true)
    default:
      break
    }
    
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    tableView.reloadData()
    setLabels()
  }
}

//MARK: Text Field Delegate
extension FilterViewController: UITextFieldDelegate {
  func textFieldDidEndEditing(textField: UITextField) {
    let alert = UIAlertController(title: "ABV Error", message: "The ABV values are not valid.  Please enter valid whole numbers", preferredStyle: .Alert)
    let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
    
    alert.addAction(alertAction)
    
    if textField == abvMinTextField {
      if let
        text = textField.text,
        abvMin = Int(text) {
          filter.abvRange.min = abvMin
      } else {
        presentViewController(alert, animated: true, completion: nil)
      }
    } else if textField == abvMaxTextField {
      if let
        text = textField.text,
        abvMax = Int(text) {
          filter.abvRange.max = abvMax
      } else {
        presentViewController(alert, animated: true, completion: nil)
      }
    }
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}

//MARK: Filter Delegate
extension FilterViewController: FilterDelegate {
  func filterWasUpdated(filter: Filter) {
    if filter.isDirty {
      self.filter = filter
    }
  }
}

//MARK: LocationPicker Delegate
extension FilterViewController: LocationPickerDelegate {
  func customLocationWasPicked(locationDetails: LocationDetails) {
    LocationService.shared.setSelectedLocation(locationDetails)
    setLabels()
  }
  
  func currentLocationWasPicked() {
    LocationService.shared.setSelectedLocationToCurrentLocation()
    setLabels()
  }
}

















