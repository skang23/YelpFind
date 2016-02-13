//
//  MapViewController.swift
//  Yelp
//
//  Created by Suyeon Kang on 2/13/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
class MapViewController: UIViewController , MKMapViewDelegate {
    
    var lat: Double!
    var long: Double!
    var name:String?
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(lat)
        print(long)
        self.navigationItem.title = name
        let centerLocation = CLLocation(latitude: lat, longitude: long)
        goToLocation(centerLocation)
        let coord = CLLocationCoordinate2DMake(lat, long)
        addAnnotationAtCoordinate(coord)
        // Do any additional setup after loading the view.
    }
    func addAnnotationAtCoordinate(coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = name
        mapView.addAnnotation(annotation)
    }
    
    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
