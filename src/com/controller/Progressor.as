package com.controller
{
	import com.model.ScreenModel;
	import com.model.ScreensModel;
	import com.model.Session;
	import com.model.rawData.WhereIsData;
	import com.sticksports.nativeExtensions.flurry.Flurry;
	import com.view.AbstractScreen;
	import com.view.Baloons;
	import com.view.Egg;
	import com.view.HomeScreen;
	import com.view.IScreen;
	import com.view.IsScreen;
	import com.view.PlayRoom;
	import com.view.Rain;
	import com.view.WhereIsScene;
	import com.view.WhereIsScreen;
	import com.view.menu.ConfigurationScreen;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;

	public class Progressor
	{
		
		private var _app:					Sprite;
		private var _screens:				ScreensModel;
		private var _homeScreen:			HomeScreen;
		private var _currentScreen:		    AbstractScreen;
		private var _playRoom:				PlayRoom;
		private var _configScr:ConfigurationScreen;
		public function Progressor(app:Sprite)
		{
			_app = app;
			_screens = new ScreensModel(WhereIsData.data);
			_homeScreen = new HomeScreen(_screens);
			_homeScreen.ready.add(initConfigScreen);
		}
		
		private function initConfigScreen():void{
			_configScr = new ConfigurationScreen(_screens);
			_configScr.goHome.add(function():void{
				_app.removeChild(_configScr);
				goHome();
			});
			_configScr.menu.gotoSignal.add(onGoTo);
		}
		
		private function onGoTo(indx:int):void{
			if(indx>-2){
				_app.removeChild(_configScr);
			}
			goTo(indx);
		}
		
		private function goNext():void{
			var nextScreen:ScreenModel = _screens.getNext();
			if(!Session.fullVersionEnabled && !nextScreen.isFree){
					goTo(-1)
					return;
			}
			
			removeScreen(_currentScreen);;
			_currentScreen = addScreen(nextScreen);
			Flurry.logEvent("gonext",{screen:nextScreen.folder});
		}
		
		public function goTo(screenIndex:int):void{
			if(screenIndex==-1){
				_app.addChild(_configScr);
				_configScr.menu.setSelectedScreen();
				_configScr.onAdded();
			}else if(screenIndex==-2){
//				if(!Session.playRoomEnabled){
//					var rateThisApp:RateThisApp = new RateThisApp();
//					_app.addChild(rateThisApp);
//				}else{
					_app.removeChild(_configScr);
					_currentScreen = addScreen(_screens.getScreen(_screens.playRoomIndex));
					_playRoom.noTimer=true;
					Session.currentScreen=0;
				//}
			}else{
				var nextScreen:ScreenModel = _screens.getScreen(screenIndex)
				if(!Session.fullVersionEnabled && !nextScreen.isFree){
					goTo(0)
					return;
				}
				removeScreen(_currentScreen);
				_currentScreen = addScreen(nextScreen);
			}
			Flurry.logEvent("goto",{ screen : screenIndex});
			//if(_currentScreen && _currentScreen.model)
				//Flurry.getInstance().logEvent("Nav GoTo ",_currentScreen.model.groupName);
		}
		
		public function goHome():void{
			if(_currentScreen){
				removeScreen(_currentScreen);
			}
			_app.addChild(_homeScreen);
			_currentScreen = _homeScreen;
			_homeScreen.gotoSignal.add(goTo);
			//Flurry.getInstance().logEvent("navigate home");
		}
		
		private function removeScreen(screen:AbstractScreen):void{
			screen.done.remove(goNext);
			screen.goHome.remove(goHome);
			screen.destroy();
			if(screen == _playRoom){
				_playRoom.visible = false;			
			}else{
				_app.removeChild(screen as DisplayObject);
			}
		}
		
		private function addScreen(model:ScreenModel):AbstractScreen{
			var screen:AbstractScreen;
			switch(model.type){
				case "whereIsScreen":
					screen = new WhereIsScreen(model);
					break;
				case "whereScene":
					screen = new WhereIsScene(model);
					break;
				case "egg":
					screen = new Egg();
					break;
				case "rain":
					screen = new Rain();
					break;
				case "baloons":
					screen = new Baloons(model);
					break;
				case "playRoom":
					if(!_playRoom){
						_playRoom = new PlayRoom();
						_playRoom.model=model;
					}
					_playRoom.visible = true;
					screen = _playRoom;
					break;
			}
			screen.done.add(goNext);
			screen.goHome.add(goHome);
			_app.addChild(screen as DisplayObject);
			if(screen == _playRoom){
				_playRoom.visible = true;
			}
			return screen;
		}
		
	}
}