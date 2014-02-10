package com.model
{
	public class ScreensModel
	{
		private var _screens:Vector.<ScreenModel>;
		private var _index:int=0;
		private var _playRoomIndex:int=0;
		public function ScreensModel(data:XML)
		{
			_screens = new Vector.<ScreenModel>();
			var model:ScreenModel;
			for each(var screen:XML in data.screens.data){
				model = new ScreenModel(screen);
				_screens.push(model);
				if(model.type == "playRoom" && _playRoomIndex==0){
					_playRoomIndex = _screens.indexOf(model);
				}
			}
		}
		
		public function get playRoomIndex():int
		{
			return _playRoomIndex;
		}

		public function get index():int{
			return _index;
		}
		
		public function getNext():ScreenModel{
			_index++;
			if(_index==_screens.length){
				_index=0;
			}
			var  scr:ScreenModel = _screens[_index];
			Session.currentScreen = _index;
			return scr;
		}
		
		public function getScreen(indx:int):ScreenModel{
			_index = indx;
			Session.currentScreen = indx;
			return _screens[indx];
		}
		
		public function get screens():Vector.<ScreenModel>{
			return _screens;
		}
		
	}
}