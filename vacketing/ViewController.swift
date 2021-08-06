//
//  ViewController.swift
//  vacketing
//
//  Created by 강성수 on 2021/07/20.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var myMap: MKMapView!
    @IBOutlet weak var currentLocation1: UILabel!
    @IBOutlet weak var currentLocation2: UILabel!
    
    let locationManager = CLLocationManager()
    
    // viewWillAppear 나타나기 전 딱 한 번 호출(레이아웃 작업)
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("First : viewDidLoad")
        
        currentLocation1.text = ""
        currentLocation2.text = ""
        locationManager.delegate = self
        
        // 정확도를 최고로 설정
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // 위치 데이터를 추적하기 위해 사용자에게 승인 요구
        locationManager.requestWhenInUseAuthorization()
        
        // 위치 업데이트를 시작
        locationManager.startUpdatingLocation()
        
        // 위치 보기 설정
        myMap.showsUserLocation = true
        
    }
    
    // 위도와 경도, 스팬(영역 폭)을 입력받아 지도에 표시
    func goLocation(latitudeValue: CLLocationDegrees,
                    longtudeValue: CLLocationDegrees,
                    delta span: Double) -> CLLocationCoordinate2D {
        let pLocation = CLLocationCoordinate2DMake(latitudeValue, longtudeValue)
        let spanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        let pRegion = MKCoordinateRegion(center: pLocation, span: spanValue)
        myMap.setRegion(pRegion, animated: true)
        return pLocation
    }
    
    // 특정 위도와 경도에 핀 설치하고 핀에 타이틀과 서브 타이틀의 문자열 표시
    func setAnnotation(latitudeValue: CLLocationDegrees,
                       longitudeValue: CLLocationDegrees,
                       delta span : Double,
                       title strTitle: String,
                       subtitle strSubTitle: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = goLocation(latitudeValue: latitudeValue, longtudeValue: longitudeValue, delta: span)
        annotation.title = strTitle
        annotation.subtitle = strSubTitle
        myMap.addAnnotation(annotation)
    }
    
    // 위치 정보에서 국가, 지역, 도로를 추출하여 레이블에 표시
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let pLocation = locations.last
        _ = goLocation(latitudeValue: (pLocation?.coordinate.latitude)!,
                       longtudeValue: (pLocation?.coordinate.longitude)!,
                       delta: 0.01)
        CLGeocoder().reverseGeocodeLocation(pLocation!, completionHandler: {(placemarks, error) -> Void in
            let pm = placemarks!.first
            let country = pm!.country
            var address: String = ""
            if country != nil {
                address = country!
            }
            if pm!.locality != nil {
                address += " "
                address += pm!.locality!
            }
            if pm!.thoroughfare != nil {
                address += " "
                address += pm!.thoroughfare!
            }
            self.currentLocation1.text = "현재 위치"
            self.currentLocation2.text = address
        })
        locationManager.stopUpdatingLocation()
        
    }
    
    // 세크먼트 컨트롤을 선택하였을 때 호출
    @IBAction func sgChangeLocation(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            // "현재 위치에서 검색" 선택 - 현재 위치 표시
            self.currentLocation1.text = ""
            self.currentLocation2.text = ""
            locationManager.startUpdatingLocation()
        } else if sender.selectedSegmentIndex == 1 {
            // "지도 위치에서 검색" 선택 - 핀을 설치하고 위치 정보 표시
            setAnnotation(latitudeValue: 37.4841955, longitudeValue: 126.932492, delta: 0.1, title: "에이치플러스 양지병원", subtitle: "서울특별시 관악구 남부순환로 1636")
            self.currentLocation1.text = "보고 계신 위치"
            self.currentLocation2.text = "에이치플러스 양지병원"
        } else if sender.selectedSegmentIndex == 2 {
            // "장소 검색" 선택 - 핀을 설치하고 위치 정보 표시
            setAnnotation(latitudeValue: 37.4737258, longitudeValue: 126.918517, delta: 0.1, title: "아이랑소아청소년과의원", subtitle: "서울특별시 관악구 난곡로 210 2층")
                       self.currentLocation1.text = "검색한 장소 위치"
                       self.currentLocation2.text = "아이랑소아청소년과의원"
        }
    }
    
    // 뷰가 나타나려 할 때마다 호출 (가변성을 가진 작업)
    override func viewWillAppear(_ animated: Bool) {
        print("First : viewWillAppear")
    }
    
    // 뷰가 완전히 나타나고 난 후 호출
    override func viewDidAppear(_ animated: Bool) {
        print("First : viewDidAppear")
    }

    // 뷰가 사라지려 할 때 호출
    override func viewWillDisappear(_ animated: Bool) {
        print("First : viewWillDisappear")
    }
    
    // 뷰가 완전히 사라지고 난 후 호출
    override func viewDidDisappear(_ animated: Bool) {
        print("First : viewDidDisappear")
    }

}

