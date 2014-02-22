package com.controller
{
	import com.model.ScreenModel;
	import com.model.ScreensModel;
	import com.model.Session;
	import com.model.rawData.WhereIsData;
	import com.utils.Monotorizer;
	import com.view.AbstractScreen;
	import com.view.Baloons;
	import com.view.Egg;
	import com.view.HomeScreen;
	import com.view.Navigator;
	import com.view.PlayRoom;
	import com.view.Rain;
	import com.view.WhereIsScene;
	import com.view.WhereIsScreen;
	import com.view.menu.ConfigurationScreen;
	
	import starling.display.DisplayObject;

	public class Progressor
	{
		
		private var _app:					FirstWordsApp;
		private var _screens:				ScreensModel;
		private var _homeScreen:			HomeScreen;
		private var _currentScreen:		    AbstractScreen;
		private var _playRoom:				PlayRoom;
		private var _configScr:				ConfigurationScreen;
		private var _navigator:				Navigator;
		
		public function Progressor(app:FirstWordsApp)
		{
			_app = app;
			_screens = new ScreensModel(WhereIsData.data);
			_homeScreen = new HomeScreen(_screens);
			_homeScreen.ready.add(initConfigScreen);
			_homeScreen.goToSignal.add(goTo);
			_navigator = new Navigator();
			_navigator.openMenuSignal.add(openMenu);
			_app.navLayer.addChild(_navigator);
			goHome();
			
		}
		
		private function initConfigScreen():void{
			
			_homeScreen.ready.remove(initConfigScreen);
			_configScr = new ConfigurationScreen(_screens);
			_configScr.goHome.add(goHome);
			_configScr.menu.gotoSignal.add(goTo);
		}
		
		
		private function goNext():void{
			var nextScreen:ScreenModel = _screens.getNext();
			if(!Session.fullVersionEnabled && !nextScreen.isFree){
					goTo(-1)
					return;
			}
			
			removeScreen(_currentScreen);;
			_currentScreen = addScreen(nextScreen);
			Monotorizer.logEvent("gonext",nextScreen.folder);
		}
		
		public function goTo(screenIndex:int):void{
			_app.screensLayer.removeChild(_configScr);
			_navigator.visible=true;
			var nextScreen:ScreenModel = _screens.getScreen(screenIndex)
			if(!Session.fullVersionEnabled && !nextScreen.isFree){
				goTo(0)
			}else{
				removeScreen(_currentScreen);
				_currentScreen = addScreen(nextScreen);
			}
			Monotorizer.logEvent("goto",_screens.getScreenFolder(screenIndex));
		}
		
		private function goHome():void{
			_navigator.visible=true;
			_app.screensLayer.removeChild(_configScr);
			_app.screensLayer.addChild(_homeScreen);
			_currentScreen = _homeScreen;
		}
		
		
		private function openMenu():void{
			_app.screensLayer.addChild(_configScr);
			_configScr.menu.setSelectedScreen();
			_navigator.visible=false;
			if(_currentScreen)
				removeScreen(_currentScreen);
		}
		
		private function removeScreen(screen:AbstractScreen):void{
			screen.done.remove(goNext);
			screen.destroy();
			if(screen == _playRoom){
				_playRoom.visible = false;			
			}else{
				_app.screensLayer.removeChild(screen as DisplayObject);
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
					screen = new Egg(model);
					break;
				case "rain":
					screen = new Rain(model);
					break;
				case "baloons":
					screen = new Baloons(model);
					break;
				case "playRoom":
					if(!_playRoom){
						_playRoom = new PlayRoom(model);
						_playRoom.model=model;
					}
					_playRoom.visible = true;
					screen = _playRoom;
					break;
			}
			screen.done.add(goNext);
			_app.screensLayer.addChild(screen as DisplayObject);
			return screen;
		}
		
	}
}