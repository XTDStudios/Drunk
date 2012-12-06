package
{
	import assets.Assets;
	
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class Astroid extends Sprite
	{
		private var m_astroidTexture 	: Texture;
		
		public function Astroid()
		{
			super();
			m_astroidTexture = Texture.fromBitmap(new Assets.AstroidGFX());
		}
	}
}