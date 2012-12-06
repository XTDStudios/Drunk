package
{
	import assets.Assets;
	
	import starling.display.MovieClip;
	import starling.textures.Texture;
	
	public class SpaceShip extends MovieClip
	{
		public function SpaceShip()
		{
			var textures:Vector.<Texture> = new Vector.<Texture> 
			textures.push (Texture.fromBitmap(new Assets.SpaceShipGFX()));
			
				
			super(textures);
			
			
		}
		
		public function fly():void
		{
			
		}
		
		public function explode():void
		{
			
		}
		

		
	}
}