package
{
	import Box2D.Dynamics.b2World;
	
	import starling.core.Starling;
	import starling.display.Sprite;

	public class AstroidsGenerator extends Sprite
	{
		private var m_world:b2World;

		public function AstroidsGenerator(b2dWorld:b2World)
		{
			m_world = b2dWorld;
		}
		
		public function start():void
		{
			var tempAstroid : Astroid = new Astroid(m_world);
			tempAstroid.x = 300;
			tempAstroid.y = 300;
			addChild(tempAstroid);	
		}
	}
}