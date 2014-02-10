package com.view.playRoom
{
	import nape.callbacks.CbType;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Circle;
	import nape.shape.Polygon;
	import nape.space.Space;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class Book extends PlayItem
	{
		[Embed(source="../../../assets/playroom/book.png")]
		private var book : Class;
		
		
		public function Book(space:Space,cbType:CbType,xx:int,yy:int)
		{
			super(space,cbType,xx,yy);
			
		}
		
		override protected function createBody(cbType:CbType,xx:int,yy:int):void{
			_body = new Body( BodyType.DYNAMIC, new Vec2( xx, yy ) );
			_body.shapes.add(new Polygon( Polygon.rect(0,0,_material.width,_material.height), Material.wood() ) );
			_body.allowRotation = false;
			super.createBody(cbType,xx,yy);
			
		}
		
		override protected function createMaterial():void{
			_material = new Sprite();
			_material.addChild( Image.fromBitmap( new book() ) ) as Sprite;
		}
		
		override protected function updateGraphics( body : Body ) : void
		{
			body.userData.graphic.x = body.position.x;
			body.userData.graphic.y = body.position.y;
			if(body.position.x>800 && body.position.x <1200 && body.position.y > 400 && body.position.y < 600){
				_material.rotation = -90;
				body.rotation = -90;
			}
			//trace(body.userData.graphic.x,body.userData.graphic.y)
		}
		
	}
}