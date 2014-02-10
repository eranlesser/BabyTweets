package com.model
{
	

	public class ScreenModel
	{
		private var _items:				Vector.<Item>;
		private var _groupName:			String;
		private var _groupsInScreen:	Vector.<String>;
		private var _thumbNail:			String;
		private var _type:				String;
		private var _backGround:		String;
		private var _menu:				XMLList;
		private var _folder:			String;
		private var _categorySound:String="";
		private var _distractorType:String="";
		private var _isFree:Boolean = false;
		public function ScreenModel(data:XML){
			_folder = "/"+data.@folder;
			_items = new Vector.<Item>();
			for each(var itemData:XML in data.item){
				_items.push(new Item(itemData,_folder));
			}
			_groupName = data.@groupName;
			_thumbNail = data.@thumbNail;
			_categorySound = data.@categorySound;
			_type = data.@type;
			_backGround = data.@backGround;
			_distractorType = data.@distractorType;
			if(XMLList(data.menu).length()>0){
				_menu = data.menu;
			}
			if(data.@isFree=="true"){
				_isFree = true;
			}
			_groupsInScreen = new Vector.<String>();
		}
		
		public function get folder():String
		{
			return _folder;
		}

		public function get isFree():Boolean
		{
			return _isFree;
		}

		public function get distractorType():String
		{
			return _distractorType;
		}

		public function get categorySound():String
		{
			return _categorySound;
		}
		
		public function get backGround():String
		{
			return _backGround;
		}

		public function get type():String
		{
			return _type;
		}

		public function get thumbNail():String
		{
			return _thumbNail;
		}
		
		public function get menu():XMLList{
			return _menu;
		}

		public function get whoIsItem():Item{
			var item:Item = _items[Math.floor(Math.random()*(_items.length))];
			if(item.wasWho==true){
				item = whoIsItem;
			}
			item.wasWho=true;
			_groupsInScreen.push(item.groupId);
			return item;
		}
		
		public function get distractor():Item{
			var item:Item = _items[Math.floor(Math.random()*(_items.length))];
			if(_groupsInScreen.indexOf(item.groupId)==-1){
				_groupsInScreen.push(item.groupId);
				return item;
			}else{
				return distractor;
			}
			
		}
		
		public function get groupName():String{
			return _groupName;
		}
		
		public function resetDistractors():void{
			_groupsInScreen = new Vector.<String>();
		}
		
		public function reset():void{
			_groupsInScreen = new Vector.<String>();
			for each(var item:Item in _items){
				item.wasWho = false;
			}
		}
		
		public function get numItems():int{
			return _items.length;
		}
	}
}