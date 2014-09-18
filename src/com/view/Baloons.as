package com.view
{
	import com.Dimentions;
	import com.model.ScreenModel;
	import com.view.utils.SoundPlayer;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.media.SoundChannel;
	
	import nape.callbacks.CbType;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.Polygon;
	import nape.space.Space;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class Baloons extends AbstractScreen
	{
		private var _ballons:Vector.<ColoredBaloon>;
		private var _playIndex:int=-1;
		private var _space:Space;
		private static const GRAVITY_X : Number = 0;
		private static const GRAVITY_Y : Number = 3000;
		private static const STEP_TIME : Number = 0.01;
		[Embed(source="../../assets/balloons/baloonsBg.jpg")]
		private var bg : Class;
		
		[Embed(source="../../assets/whereBird.png")]
		private var wBird : 				Class;
		[Embed(source="../../assets/whereBird_note.png")]
		private var wBirdNote : 			Class;
		
		private var _wBirdNote : 			Button;
		private var _whereBird:				Button;
		
		[Embed(source="../../assets/balloons/blu.png")]
		private var bluBln : Class;
		[Embed(source="../../assets/balloons/green.png")]
		private var greenBln : Class;
		[Embed(source="../../assets/balloons/orangeBln.png")]
		private var orangeBln : Class;
		[Embed(source="../../assets/balloons/red.png")]
		private var redBln : Class;
		[Embed(source="../../assets/balloons/turkuizeBln.png")]
		private var turkuizeBln : Class;
		[Embed(source="../../assets/balloons/yellow.png")]
		private var yellowBln : Class;
		
		private var _whoIsBaloon:ColoredBaloon;
		
		public function Baloons(model:ScreenModel)
		{
			super(model);
			
			
		}
		
		private function getBaloon(clr:String):BaloonModel{
			var soundManager:SoundPlayer = new SoundPlayer();
			var model:BaloonModel = new BaloonModel();
			switch(clr){
				case "blu":
					model.image = new Image(Texture.fromBitmap(new bluBln()));
					model.qSound = soundManager.getSound("../../../assets/narration/","/colors/4.mp3");  
					model.aSound = soundManager.getSound("../../../assets/narration/","/colors/5.mp3");  
					break;
				case "green":
					model.image = new Image(Texture.fromBitmap(new greenBln()));
					model.qSound = soundManager.getSound("../../../assets/narration/","/colors/6.mp3");  
					model.aSound = soundManager.getSound("../../../assets/narration/","/colors/7.mp3");  
					break;
				case "red":
					model.image = new Image(Texture.fromBitmap(new redBln()));
					model.qSound = soundManager.getSound("../../../assets/narration/","/colors/2.mp3");  
					model.aSound = soundManager.getSound("../../../assets/narration/","/colors/3.mp3");  
					break;
				case "yellow":
					model.image = new Image(Texture.fromBitmap(new yellowBln()));
					model.qSound = soundManager.getSound("../../../assets/narration/","/colors/8.mp3");  
					model.aSound = soundManager.getSound("../../../assets/narration/","/colors/9.mp3");  
					break;
			}
			return model;
			
		}

		
		override protected function onCatSoundDone(e:flash.events.Event):void{
			setWhoIs();
		}
		
		private function createSpace():void
		{
			_space = new Space( new Vec2( GRAVITY_X, GRAVITY_Y ) );
			listenForEnterFrame();
		}
		
		public static const WALL_WIDTH:uint=22;
		private function createFloor():void
		{
			const floor:Body = new Body( BodyType.STATIC );
			
			// what are all these things?
			floor.shapes.add( new Polygon( Polygon.rect( 0, 0, 1024, 22 ) ) );
			floor.shapes.add( new Polygon( Polygon.rect( 0, 0, 60, 768 ) ) );
			floor.shapes.add( new Polygon( Polygon.rect( 708, 0, 22, 768 ) ) );
			
			floor.space = _space;
		}
		
		
		
		private function listenForEnterFrame() : void
		{
			var _nativeStage:Stage = Starling.current.nativeStage;
			addEventListener( starling.events.Event.ENTER_FRAME, onEnterFrame);
			
		}
		
		private function onEnterFrame(e:starling.events.Event):void{
			//_hand.anchor1.setxy( _nativeStage.mouseX, _nativeStage.mouseY );
			_space.step( STEP_TIME );
			for (var i:int = 0; i < _space.liveBodies.length; i++) {
				var body:Body = _space.liveBodies.at(i);
				if (body.userData.graphicUpdate) {
					body.userData.graphicUpdate(body);
				}
			}
		}
		
		override public function destroy():void{
			_whereBird.removeEventListener(starling.events.Event.TRIGGERED,onWhereBird);
			removeEventListener( starling.events.Event.ENTER_FRAME, onEnterFrame);
			super.destroy();
		}
		
		override protected function init():void{
			super.init();
			_screenLayer.addChild(new Image(Texture.fromBitmap(new bg())));
			_ballons = new Vector.<ColoredBaloon>();
			createSpace();
			createFloor();
			var baloon:ColoredBaloon = new ColoredBaloon(getBaloon("red"),_space,new CbType(),300,300);
			addChild(baloon.material);
			var blubaloon:ColoredBaloon = new ColoredBaloon(getBaloon("blu"),_space,new CbType(),600,300);
			addChild(blubaloon.material);
			var greenbaloon:ColoredBaloon = new ColoredBaloon(getBaloon("green"),_space,new CbType(),450,300);
			addChild(greenbaloon.material);
			var yellowbaloon:ColoredBaloon = new ColoredBaloon(getBaloon("yellow"),_space,new CbType(),750,300);
			addChild(yellowbaloon.material);
			
			baloon.poped.addOnce(setWhoIs);
			blubaloon.poped.addOnce(setWhoIs);
			greenbaloon.poped.addOnce(setWhoIs);
			yellowbaloon.poped.addOnce(onLast);
			
			baloon.touched.add(onBaloonTouch);
			blubaloon.touched.add(onBaloonTouch);
			greenbaloon.touched.add(onBaloonTouch);
			yellowbaloon.touched.add(onBaloonTouch);
			
			_ballons.push(baloon);
			_ballons.push(blubaloon);
			_ballons.push(greenbaloon);
			_ballons.push(yellowbaloon);
			
			_whereBird = new Button(Texture.fromBitmap(new wBird()));
			addChild(_whereBird);
			_wBirdNote = new Button(Texture.fromBitmap(new wBirdNote()));
			addChild(_wBirdNote);
			_wBirdNote.visible = false;
			_whereBird.x = Dimentions.WIDTH - _whereBird.width//-2;
			_wBirdNote.x = Dimentions.WIDTH - _wBirdNote.width//-2;
			_whereBird.addEventListener(starling.events.Event.TRIGGERED,onWhereBird);
			if(_model.categorySound!=""){
				_categorySound = _soundManager.getSound("../assets/narration/",_model.folder +"/"+ _model.categorySound);
				var chnl:SoundChannel = _categorySound.play();
				_categorySoundPlaying=true;
				chnl.addEventListener(flash.events.Event.SOUND_COMPLETE,onCatSoundDone);
			}
			
			//_ballons[0].isWho = true;		
		}
		
		private function onWhereBird(e:starling.events.Event):void
		{
			playWhoIsSound();
		}		
		
		private function onBaloonTouch(baloon:ColoredBaloon):void{
			if(baloon==_whoIsBaloon){
				baloon.touched.remove(onBaloonTouch);
				baloon.pop();
			}else{
				baloon.model.aSound.play();
			}
		}
		
		private function onLast():void{
			//closeCurtains();
			Starling.juggler.delayCall(super.dispatchDone,2);
		}
		
		private function playWhoIsSound():void{
			_wBirdNote.visible=true;
			var chnl:SoundChannel = _ballons[_playIndex].model.qSound.play();
			chnl.addEventListener(flash.events.Event.SOUND_COMPLETE,onSoundComplete);
			isEnabled = false;
		}
		
		protected function onSoundComplete(event:flash.events.Event):void
		{
			// TODO Auto-generated method stub
			isEnabled = true;
			_wBirdNote.visible=false;
			SoundChannel(event.target).removeEventListener(flash.events.Event.SOUND_COMPLETE,onSoundComplete);
		}		
		
		private function onEnabled(val:Boolean):void{
			_wBirdNote.visible = !val;
		}
		
		private function setWhoIs():void{
			_playIndex++;
			_whoIsBaloon = _ballons[_playIndex];
			playWhoIsSound();
		}
		
	}
}
import com.view.Baloons;
import com.view.components.ParticlesEffect;
import com.view.playRoom.PlayItem;

import flash.media.Sound;
import flash.net.URLRequest;

import nape.callbacks.CbType;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.phys.Material;
import nape.shape.Polygon;
import nape.space.Space;

import org.osflash.signals.Signal;

import starling.core.Starling;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.TouchEvent;
import starling.events.TouchPhase;


class ColoredBaloon extends PlayItem{
	
	
	
	private var _popSound:Sound;
	private var _model:BaloonModel;
	public var poped:Signal = new Signal();
	public var touched:Signal=new Signal();;
	
	function ColoredBaloon(model:BaloonModel,space:Space, cbType:CbType, xx:int, yy:int){
		_model = model;
		super(space, cbType, xx, yy);
		//_clrSound = new Sound(new URLRequest("../../assets/sounds/colors/"+clr+"_baloon.mp3"));
	}
	
	

		
	override protected function createBody(cbType:CbType,xx:int,yy:int):void{
		_body = new Body( BodyType.DYNAMIC, new Vec2( xx, yy ) );
		_body.shapes.add( new Polygon( Polygon.rect(0,0,_material.width,_material.height), Material.rubber() ) );
		_body.gravMass = -(0.3)+0.2*Math.random();
		super.createBody(cbType,xx,yy);
		
	}
	
	
	public function get body():Body{
		return _body;
	}
	
	override protected function createMaterial():void{
		_material = new Sprite();
		
		_material.addChild( ( _model.image ) ) as Sprite;
		_popSound = new Sound(new URLRequest("../../../assets/sounds/playroom/pop.mp3"));
		_material.addEventListener(TouchEvent.TOUCH,onTouch);
	}
	public function get model():BaloonModel{
		return _model;
	}
	
	public function pop():void{
		_material.removeEventListener(TouchEvent.TOUCH,onTouch);
		var particlesEffect:ParticlesEffect;
		particlesEffect = new ParticlesEffect();
		particlesEffect.width=_material.width/10;
		particlesEffect.height=_material.height/10;
		particlesEffect.x=_material.x+_material.width/2;
		particlesEffect.y=_material.y+_material.height/2;
		_material.parent.addChild(particlesEffect);
		particlesEffect.start("jfish");
		_popSound.play();
		Starling.juggler.delayCall(removeParticles,0.3,particlesEffect);
		_material.removeFromParent(true);
		_space.bodies.remove(_body);
	}
	
	private function removeParticles(particlesEffect:ParticlesEffect):void{
		particlesEffect.stop();
		//particlesEffect.dispose();
		particlesEffect.parent.removeChild(particlesEffect);
		poped.dispatch();
	}
	
	private function onTouch(e:TouchEvent):void{
		if(e.getTouch(_material.stage) && e.getTouch(_material.stage).phase == TouchPhase.BEGAN){
			if(_material.parent is Baloons && Baloons(_material.parent).isEnabled){
				touched.dispatch(this);
			}
		}
	}
}

class BaloonModel{
	public var image:Image;
	public var qSound:Sound;
	public var aSound:Sound;
	
}