package com.view.playRoom {

import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Shape;
import nape.shape.Polygon;
import nape.shape.Circle;
import nape.geom.Vec2;
import nape.dynamics.InteractionFilter;
import nape.phys.Material;
import nape.phys.FluidProperties;
import nape.callbacks.CbType;
import nape.geom.AABB;

import flash.display.DisplayObject;
import flash.geom.Rectangle;
import flash.utils.Dictionary;

public class PhysicsData {

	public static function createBody(name:String,graphic:DisplayObject=null):Body {
		var xret:BodyPair = lookup(name);
		if(graphic==null) return xret.body.copy();

		var ret:Body = xret.body.copy();
		graphic.x = graphic.y = 0;
		graphic.rotation = 0;
		var bounds:Rectangle = graphic.getBounds(graphic);
		var offset:Vec2 = Vec2.get(bounds.x-xret.anchor.x, bounds.y-xret.anchor.y);

		ret.graphic = graphic;
		ret.graphicUpdate = function(b:Body):void {
			var gp:Vec2 = b.localToWorld(offset);
			graphic.x = gp.x;
			graphic.y = gp.y;
			graphic.rotation = (b.rotation*180/Math.PI)%360;
		}	

		return ret;
	}

	public static function registerMaterial(name:String,material:Material):void {
		if(materials==null) materials = new Dictionary();
		materials[name] = material;	
	}
	public static function registerFilter(name:String,filter:InteractionFilter):void {
		if(filters==null) filters = new Dictionary();
		filters[name] = filter;
	}
	public static function registerFluidProperties(name:String,properties:FluidProperties):void {
		if(fprops==null) fprops = new Dictionary();
		fprops[name] = properties;
	}
	public static function registerCbType(name:String,cbType:CbType):void {
		if(types==null) types = new Dictionary();
		types[name] = cbType;
	}

	//----------------------------------------------------------------------	

	private static var bodies   :Dictionary;
	private static var materials:Dictionary;
	private static var filters  :Dictionary;
	private static var fprops   :Dictionary;
	private static var types    :Dictionary;
	private static function material(name:String):Material {
		if(name=="default") return new Material();
		else {
			if(materials==null || materials[name] === undefined)
				throw "Error: Material with name '"+name+"' has not been registered";
			return materials[name] as Material;
		}
	}
	private static function filter(name:String):InteractionFilter {
		if(name=="default") return new InteractionFilter();
		else {
			if(filters==null || filters[name] === undefined)
				throw "Error: InteractionFilter with name '"+name+"' has not been registered";
			return filters[name] as InteractionFilter;
		}
	}
	private static function fprop(name:String):FluidProperties {
		if(name=="default") return new FluidProperties();
		else {
			if(fprops==null || fprops[name] === undefined)
				throw "Error: FluidProperties with name '"+name+"' has not been registered";
			return fprops[name] as FluidProperties;
		}
	}
	private static function cbtype(name:String):CbType {
		if(name=="null") return null;
		else {
			if(types==null || types[name] === undefined)
				throw "Error: CbType with name '"+name+"' has not been registered";
			return types[name] as CbType;
		}	
	}

	private static function lookup(name:String):BodyPair {
		if(bodies==null) init();
		if(bodies[name] === undefined) throw "Error: Body with name '"+name+"' does not exist";
		return bodies[name] as BodyPair;
	}

	//----------------------------------------------------------------------	

	private static function init():void {
		bodies = new Dictionary();

		var body:Body;
		var mat:Material;
		var filt:InteractionFilter;
		var prop:FluidProperties;
		var cbType:CbType;
		var s:Shape;
		var anchor:Vec2;

		
			body = new Body();
			body.cbType = cbtype("null");

			
				mat = material("default");
				filt = filter("default");
				prop = fprop("default");
				cbType = cbtype("null");

				
					s = new Circle(
						10,
						Vec2.weak(-10,227),
						mat,
						filt
					);
					s.body = body;
					s.fluidEnabled = false;
					s.fluidProperties = prop;
					s.cbType = cbType;
				
			
				mat = material("default");
				filt = filter("default");
				prop = fprop("default");
				cbType = cbtype("null");

				
					
						s = new Polygon(
							[   Vec2.weak(43,0)   ,  Vec2.weak(38,7)   ,  Vec2.weak(38,23)   ,  Vec2.weak(43,18)   ,  Vec2.weak(51,0)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(222,147)   ,  Vec2.weak(228,147)   ,  Vec2.weak(230,145)   ,  Vec2.weak(231,137)   ,  Vec2.weak(230,132)   ,  Vec2.weak(225,123)   ,  Vec2.weak(219,143)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(41,23)   ,  Vec2.weak(43,18)   ,  Vec2.weak(38,23)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(39,35)   ,  Vec2.weak(38,37)   ,  Vec2.weak(48,69)   ,  Vec2.weak(54,69)   ,  Vec2.weak(43,35)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(215,90)   ,  Vec2.weak(210,86)   ,  Vec2.weak(202,86)   ,  Vec2.weak(194,90)   ,  Vec2.weak(184,101)   ,  Vec2.weak(182,110)   ,  Vec2.weak(196,106)   ,  Vec2.weak(216,96)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(67,0)   ,  Vec2.weak(61,6)   ,  Vec2.weak(96,33)   ,  Vec2.weak(98,19)   ,  Vec2.weak(96,12)   ,  Vec2.weak(90,5)   ,  Vec2.weak(79,0)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(236,171)   ,  Vec2.weak(232,168)   ,  Vec2.weak(222,169)   ,  Vec2.weak(208,176)   ,  Vec2.weak(199,207)   ,  Vec2.weak(222,197)   ,  Vec2.weak(235,183)   ,  Vec2.weak(237,175)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(13,156)   ,  Vec2.weak(2,163)   ,  Vec2.weak(0,167)   ,  Vec2.weak(9,186)   ,  Vec2.weak(20,192)   ,  Vec2.weak(30,166)   ,  Vec2.weak(21,157)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(12,46)   ,  Vec2.weak(12,55)   ,  Vec2.weak(17,61)   ,  Vec2.weak(23,63)   ,  Vec2.weak(37,62)   ,  Vec2.weak(38,37)   ,  Vec2.weak(16,40)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(234,115)   ,  Vec2.weak(234,103)   ,  Vec2.weak(231,99)   ,  Vec2.weak(227,97)   ,  Vec2.weak(216,96)   ,  Vec2.weak(225,123)   ,  Vec2.weak(229,122)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(54,71)   ,  Vec2.weak(57,74)   ,  Vec2.weak(108,102)   ,  Vec2.weak(55,25)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(46,32)   ,  Vec2.weak(43,35)   ,  Vec2.weak(54,69)   ,  Vec2.weak(48,32)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(237,181)   ,  Vec2.weak(237,175)   ,  Vec2.weak(235,183)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(219,143)   ,  Vec2.weak(225,123)   ,  Vec2.weak(216,96)   ,  Vec2.weak(202,109)   ,  Vec2.weak(198,129)   ,  Vec2.weak(198,142)   ,  Vec2.weak(200,145)   ,  Vec2.weak(209,146)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(55,3)   ,  Vec2.weak(51,0)   ,  Vec2.weak(43,18)   ,  Vec2.weak(49,17)   ,  Vec2.weak(56,6)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(14,59)   ,  Vec2.weak(17,61)   ,  Vec2.weak(12,55)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(37,62)   ,  Vec2.weak(48,69)   ,  Vec2.weak(38,37)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(0,174)   ,  Vec2.weak(3,180)   ,  Vec2.weak(9,186)   ,  Vec2.weak(0,167)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(175,105)   ,  Vec2.weak(166,103)   ,  Vec2.weak(115,104)   ,  Vec2.weak(190,151)   ,  Vec2.weak(190,122)   ,  Vec2.weak(182,110)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(109,72)   ,  Vec2.weak(111,68)   ,  Vec2.weak(111,56)   ,  Vec2.weak(108,49)   ,  Vec2.weak(96,33)   ,  Vec2.weak(61,6)   ,  Vec2.weak(55,22)   ,  Vec2.weak(104,76)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(48,32)   ,  Vec2.weak(54,69)   ,  Vec2.weak(55,25)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(30,166)   ,  Vec2.weak(20,192)   ,  Vec2.weak(21,194)   ,  Vec2.weak(77,214)   ,  Vec2.weak(201,174)   ,  Vec2.weak(41,163)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(109,93)   ,  Vec2.weak(104,76)   ,  Vec2.weak(55,22)   ,  Vec2.weak(55,25)   ,  Vec2.weak(108,102)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(202,109)   ,  Vec2.weak(216,96)   ,  Vec2.weak(200,106)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(186,114)   ,  Vec2.weak(184,113)   ,  Vec2.weak(190,122)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(235,186)   ,  Vec2.weak(235,183)   ,  Vec2.weak(222,197)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(208,176)   ,  Vec2.weak(201,174)   ,  Vec2.weak(195,207)   ,  Vec2.weak(199,207)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(195,207)   ,  Vec2.weak(201,174)   ,  Vec2.weak(77,214)   ,  Vec2.weak(109,217)   ,  Vec2.weak(140,217)   ,  Vec2.weak(172,214)   ,  Vec2.weak(186,211)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(49,17)   ,  Vec2.weak(55,22)   ,  Vec2.weak(61,6)   ,  Vec2.weak(56,6)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(200,106)   ,  Vec2.weak(216,96)   ,  Vec2.weak(196,106)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(51,208)   ,  Vec2.weak(77,214)   ,  Vec2.weak(21,194)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(196,106)   ,  Vec2.weak(182,110)   ,  Vec2.weak(187,110)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(187,110)   ,  Vec2.weak(182,110)   ,  Vec2.weak(184,113)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(55,96)   ,  Vec2.weak(55,142)   ,  Vec2.weak(201,174)   ,  Vec2.weak(58,85)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(41,163)   ,  Vec2.weak(201,174)   ,  Vec2.weak(48,157)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(48,157)   ,  Vec2.weak(201,174)   ,  Vec2.weak(55,142)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(58,85)   ,  Vec2.weak(201,174)   ,  Vec2.weak(197,170)   ,  Vec2.weak(108,102)   ,  Vec2.weak(57,74)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(190,151)   ,  Vec2.weak(115,104)   ,  Vec2.weak(108,102)   ,  Vec2.weak(197,170)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
				
			

			anchor = (true) ? body.localCOM.copy() : Vec2.get(0,217);
			body.translateShapes(Vec2.weak(-anchor.x,-anchor.y));
			body.position.setxy(0,0);

			bodies["horse"] = new BodyPair(body,anchor);
		
	}
}
}

import nape.phys.Body;
import nape.geom.Vec2;

class BodyPair {
	public var body:Body;
	public var anchor:Vec2;
	public function BodyPair(body:Body,anchor:Vec2):void {
		this.body = body;
		this.anchor = anchor;
	}
}
