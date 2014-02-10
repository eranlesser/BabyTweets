package com.view.layouts
{
	import com.view.components.ImageItem;
	
	import starling.display.Image;
	import starling.display.Sprite;

	public class Layout
	{
		protected var _placeHolders:Vector.<PlaceHolder>;
		private var _view:Sprite;
		public function Layout(view:Sprite)
		{
			_placeHolders = new Vector.<PlaceHolder>();
			_view = view;
		}
		
		protected function addPlaceHolder(x:int,y:int,width:int,height:int):void{
			_placeHolders.push(new PlaceHolder(x,y,width,height));
		}
		
		public function layout(images:Vector.<ImageItem>):void{
			var placeHolder:PlaceHolder;
			for each(var image:ImageItem in images){
				placeHolder = getRandomPlaceHolder();
				image.bg = placeHolder.backGround;
				placeHolder.image = image;
				_view.addChild(image.bg);
				_view.addChild(image.border);
				_view.addChild(image);
			}
		}
		
		public function clear():void{
			for each(var placeHolder:PlaceHolder in _placeHolders){
				placeHolder.clear();
			}
		}
		
		private function getRandomPlaceHolder():PlaceHolder{
			var placeHolder:PlaceHolder=randomItem;
			while(!placeHolder.empty){
				placeHolder = randomItem;
			}
			
			return placeHolder;
		}
		
		private function get randomItem():PlaceHolder{
			var rand:Number = Math.random();
			if(rand<0.33){
				return _placeHolders[0]
			}else if(rand<0.66){
				return _placeHolders[1]
				
			}else{
				return _placeHolders[2]
				
			}
		}
		
	}
}
import com.view.components.ImageItem;

import flash.display.BitmapData;
import flash.display.Shape;

import starling.display.Image;
import starling.textures.Texture;

class PlaceHolder{
	private var _x:int;
	private var _y:int;
	private var _width:int;
	private var _height:int;
	private var _image:ImageItem;
	function PlaceHolder(xx:int,yy:int,width:int,height:int){
		_x=xx;
		_y=yy;
		_width=width;
		_height=height;
	}

	public function get empty():Boolean
	{
		return _image==null;
	}

	
	public function set image(img:ImageItem):void{
		_image = img;
		img.bg.x=_x+6;
		img.bg.y=_y+6;
		img.border.x=_x;
		img.border.y=_y;
		_image.x = _x+16;
		_image.y = _y+16;
		if(_image.width>(_width-32)){
			var ratio:Number = (_width-32)/_image.width;
			_image.width = (_width-32);
			_image.height = _image.height*ratio;
			
		}else if(_width>_image.width){
			_image.x = _x+(_width-_image.width)/2;
		}

		if(_image.height>(_height-32)){
			var yratio:Number = (_height-32)/_image.height;
			_image.height = (_height-32);
			_image.width = _image.width*yratio;
			if(_width>_image.width){
				_image.x = _x+(_width-_image.width)/2;
			}
			
		}else if((_height)>_image.height){
			_image.y = _y+(_height-_image.height)/2;
		}
	}
	
	public function clear():void{
		if(_image){
			_image.touched.removeAll();
			_image.removeFromParent(true);
			_image.bg.removeFromParent(true);
			_image.border.removeFromParent(true);
			if(_image.borderGood.parent){
				_image.borderGood.removeFromParent(true);
			}
			_image=null;
		}
	}
	
	public function get backGround():Image{
		var shp:Shape = new Shape();
		//shp.graphics.lineStyle(3,0x593407);
		shp.graphics.beginFill(0xFEFEFA);
		shp.graphics.drawRect(0,0,_width-12,_height-12);
		shp.graphics.endFill();
		var bmd:BitmapData = new BitmapData(shp.width,shp.height);
		bmd.draw(shp);
		var txture:Texture = Texture.fromBitmapData(bmd);
		var bg:Image= new Image(txture);
		return bg;
	}
	
}