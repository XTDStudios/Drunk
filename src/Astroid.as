package
{
	import assets.Assets;
	
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class Astroid extends Image
	{
		public function Astroid()
		{
			super(Texture.fromBitmap(new Assets.AstroidGFX()));			
		}
	}
}