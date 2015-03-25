package com.model
{
	import com.model.rawData.Transportation;
	import com.view.components.FlagsMenu;
	
	import org.osflash.signals.Signal;

	public class ScreensModel
	{
		private var _screens:Vector.<ScreenModel>;
		private var _index:int=0;
		private var _playRoomIndex:int=0;
		public var changed:Signal = new Signal();
		public function ScreensModel(data:XML)
		{
			_screens = new Vector.<ScreenModel>();
			var model:ScreenModel;
			for each(var screen:XML in data.screens.data){
				model = new ScreenModel(screen);
				_screens.push(model);
//				if(model.type == "playRoom" && _playRoomIndex==0){
//					_playRoomIndex = _screens.indexOf(model);
//				}
			}
			Session.langChanged.add(onLanguageChanged);
		}
		
		private function onLanguageChanged():void
		{
			var i:int=0;
			if(Session.lang == FlagsMenu.SWEDEN)
			{
				for(i; i<_screens.length; i++)
				{
					if(_screens[i].thumbNail == "transportationTmb")
					{
						_screens.splice(i,1);
						changed.dispatch(this);
						break;
					}
				}
			}
			else
			{
				for(i; i<_screens.length; i++)
				{
					var hasTransportation:Boolean = false;
					if(_screens[i].thumbNail == "transportationTmb")
					{
						
						hasTransportation = true;
						break;
					}
					
				}
				if(!hasTransportation)
				{
					_screens.splice(_screens.length-1,0,new ScreenModel(Transportation.data));
					changed.dispatch(this);
				}
			}
		}
		
//		public function get playRoomIndex():int
//		{
//			return _playRoomIndex;
//		}

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
			if(indx >= _screens.length)
			{
				indx = _screens.length - 1 // case playroom , swap to swedish and play scenario
			}
			_index = indx;
			Session.currentScreen = indx;
			return _screens[indx];
		}
		
		public function getScreenFolder(indx:int):String{
			if(indx >= _screens.length)
			{
				indx = _screens.length - 1 // case playroom , swap to swedish and play scenario
			}
			if(!_screens[indx]){
				return "";
			}
			return _screens[indx].folder;
		}
		
		public function get screens():Vector.<ScreenModel>{
			return _screens;
		}
		
	}
}