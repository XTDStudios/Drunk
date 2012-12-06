package
{
	import starling.display.Sprite;

	public class AstroidsGenerator extends Sprite
	{
		public function AstroidsGenerator()
		{
		}
		
		public function start():void
		{
			var tempAstroid : Astroid = new Astroid();
			addChild(tempAstroid);	
		}
	}
}