//
//  GeometryBridge.swift
//  Prototope
//
//  Created by Andy Matuschak on 2/2/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Foundation
import JavaScriptCore
import Prototope

@objc public protocol PointJSExport: JSExport {
	// TODO make these writable, add observers to the bridges which vend them
	var x: Double { get }
	var y: Double { get }
	class var zero: PointJSExport // exported manually
	init(args: NSDictionary)
	func distanceToPoint(point: PointJSExport) -> Double
	var length: Double { get }

	func equals(point: PointJSExport) -> Bool
	func add(point: PointJSExport) -> PointJSExport
	func subtract(point: PointJSExport) -> PointJSExport
	func multiply(scalar: Double) -> PointJSExport
	func divide(scalar: Double) -> PointJSExport
}

@objc public class PointBridge: NSObject, PointJSExport, BridgeType {
	public class func addToContext(context: JSContext) {
		context.setObject(self, forKeyedSubscript: "Point")
		let pointBridge = context.objectForKeyedSubscript("Point")
		pointBridge.setObject(self(args: ["x": 0, "y": 0]), forKeyedSubscript: "zero")
	}

	var point: Prototope.Point
	public required init(args: NSDictionary) {
		point = Point(
			x: (args["x"] as Double?) ?? 0,
			y: (args["y"] as Double?) ?? 0
		)
		super.init()
	}

	init(_ point: Prototope.Point) {
		self.point = point
		super.init()
	}

	public var x: Double { return point.x }
	public var y: Double { return point.y }

	public func distanceToPoint(other: PointJSExport) -> Double {
		return point.distanceToPoint((other as JSExport as PointBridge).point)
	}

	public var length: Double { return point.length }

	public func equals(other: PointJSExport) -> Bool {
		return point == (other as JSExport as PointBridge).point
	}

	public func add(other: PointJSExport) -> PointJSExport {
		return PointBridge(point + (other as JSExport as PointBridge).point)
	}

	public func subtract(other: PointJSExport) -> PointJSExport {
		return PointBridge(point - (other as JSExport as PointBridge).point)
	}

	public func multiply(scalar: Double) -> PointJSExport {
		return PointBridge(point * scalar)
	}

	public func divide(scalar: Double) -> PointJSExport {
		return PointBridge(point / scalar)
	}
}


@objc public protocol SizeJSExport: JSExport {
	var width: Double { get }
	var height: Double { get }
	class var zero: SizeJSExport // exported manually
	init(args: NSDictionary)

	func equals(other: SizeJSExport) -> Bool
	func add(other: SizeJSExport) -> SizeJSExport
	func multiply(scalar: Double) -> SizeJSExport
}

@objc public class SizeBridge: NSObject, SizeJSExport, BridgeType {
	public class func addToContext(context: JSContext) {
		context.setObject(self, forKeyedSubscript: "Size")
		let sizeBridge = context.objectForKeyedSubscript("Size")
		sizeBridge.setObject(self(args: ["width": 0, "height": 0]), forKeyedSubscript: "zero")
	}

	var size: Size
	public required init(args: NSDictionary) {
		size = Size(
			width: (args["width"] as Double?) ?? 0,
			height: (args["height"] as Double?) ?? 0
		)
		super.init()
	}

	init(_ size: Size) {
		self.size = size
		super.init()
	}

	public var width: Double { return size.width }
	public var height: Double { return size.height }

	public func equals(other: SizeJSExport) -> Bool {
		return size == (other as JSExport as SizeBridge).size
	}

	public func add(other: SizeJSExport) -> SizeJSExport {
		return SizeBridge(size + (other as JSExport as SizeBridge).size)
	}

	public func multiply(scalar: Double) -> SizeJSExport {
		return SizeBridge(size * scalar)
	}
}
