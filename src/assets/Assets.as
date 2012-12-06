package assets
{
	public class Assets
	{
		[Embed(source="astroid.jpg")]
		public static const AstroidGFX:Class;
		
		[Embed (source = "spacecraft.png")]
		public static const SpaceShipGFX:Class;
		
		[Embed(source="fire/particle.pex", mimeType="application/octet-stream")]
		public static const FireConfig:Class;
		
		// embed particle texture
		[Embed(source = "fire/texture.png")]
		public static const FireParticle:Class;
		
		[Embed(source="DrunkSpaceShip.swf", mimeType="application/octet-stream")] 
		public static const AssetsSwf:Class;
	}
}