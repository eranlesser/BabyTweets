package com.model
{
	import flash.geom.Rectangle;
	
	import nape.geom.Vec2;

	public class Item
	{
		private var _image:String;
		private var _qSound:String;
		private var _aSound:String;
		private var _hSound:String;
		private var _groupId:String;
		private var _rects:Vector.<Rectangle>;
		private var _wasWho:Boolean=false;
		
		public function Item(data:XML,folder:String){
			_image = data.@image;
			_qSound = folder+"/"+data.@qsound;
			_aSound = folder+"/"+data.@asound;
			_hSound = data.@hsound;
			_groupId = data.@groupId;
			_rects = new Vector.<Rectangle>();
			for each(var rectXml:XML in data.rect){
				var rectInfo:Array = String(rectXml.@vector).split(",");
				_rects.push(new Rectangle(rectInfo[0],rectInfo[1],rectInfo[2],rectInfo[3]));
			}
		}

		public function get groupId():String
		{
			return _groupId;
		}

		public function get wasWho():Boolean
		{
			return _wasWho;
		}

		public function set wasWho(value:Boolean):void
		{
			_wasWho = value;
		}

		public function get qSound():String
		{
			return _qSound;
		}
		public function get aSound():String
		{
			return _aSound;
		}
		public function get hSound():String
		{
			return _hSound;
		}

		public function get image():String
		{
			return _image;
		}
		
		public function get rects():Vector.<Rectangle>{
			return _rects;
		}

	}
}