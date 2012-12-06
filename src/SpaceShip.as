package
{
	import flash.utils.Timer;
	
	import assets.Assets;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;
		
	public class SpaceShip extends Sprite
	{
		
		private var ps:PDParticleSystem
		private var spaceshipImage:Image
		private var myTimer:Timer;
		public function SpaceShip()
		{

			
				
			super();
			createire()
			// instantiate embedded objects
			var psConfig:XML = XML(new Assets.FireConfig());
			var psTexture:Texture = Texture.fromBitmap(new Assets.FireParticle());
			
			// create particle system
			ps = new PDParticleSystem(psConfig, psTexture);
			addChild(ps);
			Starling.juggler.add(ps);
			
			// change position where particles are emitted
			ps.emitterX = 20;
			ps.emitterY = 40;
			
			ps.emitAngle = 90 *Math.PI/180
			ps.gravityY = 100
			ps.start();
			
			spaceshipImage = Image.fromBitmap(new Assets.SpaceShipGFX())
			addChild(spaceshipImage)
		}
		
		private function createire():void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function fly():void
		{
			
		}
		
		public function explode():void
		{
			
		}
		
		
		
		
		public function setPosition(_x:Number,_y:Number):void
		{
			spaceshipImage.x = _x;
			spaceshipImage.y= _y;
			ps.emitterX = _x+40;
			ps.emitterY = _y+40;
			
		}
		
		
		

		
	}
}