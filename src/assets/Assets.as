package assets
{
	public class Assets
	{
		[Embed(source="astroid.jpg")]
		public static const AstroidGFX:Class;
		
		[Embed(source="steroid.swf", mimeType="application/octet-stream")] 
		public static const AssetsSwf:Class;
		
	}
}