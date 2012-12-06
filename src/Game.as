package
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2World;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Game extends Sprite
	{
		private var m_astroidsGenerator	: AstroidsGenerator;
		private var m_world				: b2World;
		public var m_velocityIterations	: int = 10;
		public var m_positionIterations	: int = 10;
		public var m_timeStep			: Number = 1.0/60.0;
		
		public function Game()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		/**
		 * On Game class added to stage. 
		 * @param event
		 * 
		 */
		private function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			initGame();
		}
		
		private function initGame():void
		{
			var gravity:b2Vec2 = new b2Vec2(0.0, 10.0);
			m_world = new b2World( gravity, false);
			
			// astroidsGenerator
			m_astroidsGenerator = new AstroidsGenerator(m_world);
			addChild(m_astroidsGenerator);
			m_astroidsGenerator.start();
			
			addEventListener(Event.ENTER_FRAME, Update);
		}
		
		public function Update(e:Event):void
		{
			// we make the world run
			m_world.Step(m_timeStep, m_velocityIterations, m_positionIterations);
			m_world.ClearForces() ;
			
			// Go through body list and update sprite positions/rotations
			for (var bb:b2Body = m_world.GetBodyList(); bb; bb = bb.GetNext())
			{
				if (bb.GetUserData() is DisplayObject)
				{
					// we cast as a Starling DisplayObject, not the native one !
					var sprite:DisplayObject = bb.GetUserData() as DisplayObject;
					sprite.x = bb.GetPosition().x * 30;
					sprite.y = bb.GetPosition().y * 30;
					sprite.rotation = bb.GetAngle();
				}
			}
		}
	}
}