//
//  ViewController.m
//  Map4dMap Utils Development Demo
//
//  Created by Huy Dang on 12/3/21.
//

#import "ViewController.h"
#import <Map4dMap/Map4dMap.h>
#import <iPostMapUtils/MarkerCluster.h>

static const NSUInteger kClusterItemCount = 500;
static const double kCameraLatitude = 16.0432432;
static const double kCameraLongitude = 108.032432;

@interface ViewController ()

@end

@implementation ViewController {
  MFMapView *_mapView;
  MFClusterManager *_clusterManager;
}

- (void)loadView {
  _mapView = [[MFMapView alloc] initWithFrame:CGRectZero];
  self.view = _mapView;
  
  CLLocationCoordinate2D target = CLLocationCoordinate2DMake(kCameraLatitude, kCameraLongitude);
  MFCameraPosition* camera = [[MFCameraPosition alloc] initWithTarget:target zoom:10];
  [_mapView moveCamera:[MFCameraUpdate setCamera:camera]];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Set up the cluster manager with default icon generator and renderer.
  id<MFClusterAlgorithm> algorithm = [[MFNonHierarchicalDistanceBasedAlgorithm alloc] init];
  id<MFClusterIconGenerator> iconGenerator = [[MFDefaultClusterIconGenerator alloc] init];
  id<MFClusterRenderer> renderer =
      [[MFDefaultClusterRenderer alloc] initWithMapView:_mapView
                                    clusterIconGenerator:iconGenerator];
  _clusterManager =
      [[MFClusterManager alloc] initWithMap:_mapView algorithm:algorithm renderer:renderer];

  // Register self to listen to MFMapViewDelegate events.
  [_clusterManager setMapDelegate:(id<MFMapViewDelegate>)self];
  
  // Generate and add random items to the cluster manager.
  [self generateClusterItems];

  // Call cluster() after items have been added to perform the clustering and rendering on map.
  [_clusterManager cluster];
}

#pragma mark MFMapViewDelegate

- (BOOL)mapview:(MFMapView *)mapView didTapMarker:(MFMarker *)marker {
  [_mapView animateCamera:[MFCameraUpdate setTarget:marker.position]];
  if ([marker.userData conformsToProtocol:@protocol(MFCluster)]) {
    [_mapView animateCamera:[MFCameraUpdate setTarget:_mapView.camera.target
                                                 zoom:_mapView.camera.zoom + 1]];
    NSLog(@"Did tap marker cluster");
    return YES;
  }
  NSLog(@"Did tap marker");
  return NO;
}

#pragma mark Private

// Randomly generates cluster items within some extent of the camera and adds them to the
// cluster manager.
- (void)generateClusterItems {
  const double extent = 0.2;
  for (int index = 1; index <= kClusterItemCount; ++index) {
    double lat = kCameraLatitude + extent * [self randomScale];
    double lng = kCameraLongitude + extent * [self randomScale];
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(lat, lng);
    MFMarker *marker = [[MFMarker alloc] init];
    marker.position = position;
    [_clusterManager addItem:(id<MFClusterItem>)marker];
  }
}

// Returns a random value between -1.0 and 1.0.
- (double)randomScale {
  return (double)arc4random() / UINT32_MAX * 2.0 - 1.0;
}


@end
