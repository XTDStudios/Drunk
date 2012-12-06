package
{
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2World;
	import Box2D.Dynamics.Joints.b2MouseJoint;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.extensions.krecha.ScrollImage;
	import starling.extensions.krecha.ScrollTile;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	public class Game extends starling.display.Sprite
	{
		private var m_astroidsGenerator	: AstroidsGenerator;
		private var m_world				: b2World;
		private var mouseJoint			: b2MouseJoint;
		private var m_dmtManager		: DMTManager;
		private var m_isActive			: Boolean;
		private var m_skyAndStars		: DisplayObject;
		
		public var m_velocityIterations	: int = 10;
		public var m_positionIterations	: int = 10;
		public var m_timeStep			: Number = 1.0/60.0;
		private var m_clouds			: ScrollImage;
		private var m_cloudsTile1		: ScrollTile;
		private var m_cloudsTile2		: ScrollTile;

		private var spaceShip:SpaceShip
		
		public function Game()
		{
			m_isActive = false;
			mouseJoint = null;
			super();
			addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		/**
		 * On Game class added to stage. 
		 * @param event
		 * 
		 */
		private function onAddedToStage(event:starling.events.Event):void
		{
			removeEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
			initDMT();
		}
		
		private function initDMT():void
		{
			m_dmtManager = new DMTManager(stage.stageWidth, stage.stageHeight);
			m_dmtManager.addEventListener(flash.events.Event.COMPLETE, onDMTComplete);
			m_dmtManager.initialize();
		}
		
		protected function onDMTComplete(event:flash.events.Event):void
		{
			initGame();
		}
		
		private function initGame():void
		{
			m_skyAndStars = m_dmtManager.getStarlingDisplayObject("skyAndStars");
			m_skyAndStars.x = 0; 
			m_skyAndStars.y = 0; 
			addChild(m_skyAndStars);
			
			var stars : DisplayObject = m_dmtManager.getStarlingDisplayObject("clouds");
			var starsTexture : Texture = (stars as Image).texture;
			m_clouds = new ScrollImage(stage.stageWidth, stage.stageHeight);
			m_clouds = new ScrollImage(stage.stageWidth, stage.stageHeight);
			m_cloudsTile1 = m_clouds.addLayer( new ScrollTile(starsTexture, true ) );
			m_cloudsTile1.paralax = 1.3;
			m_cloudsTile1.alpha = 0.6;
			
			m_cloudsTile2 = m_clouds.addLayer( new ScrollTile(starsTexture, true ) );
			m_cloudsTile2.alpha = 1;
			m_cloudsTile2.color = 0x4444ff;
			m_cloudsTile2.paralax = 1.8;
			m_cloudsTile2.scaleX = 1.3;
			m_cloudsTile2.scaleY = 1.3;
			
			addChild(m_clouds);

			var gravity:b2Vec2 = new b2Vec2(0.0, 0.0);
			m_world = new b2World(gravity, false);
			
			var astroidContactListener : AstroidContactListener = new AstroidContactListener();
			m_world.SetContactListener(astroidContactListener);
			astroidContactListener.eventDispatcher.addEventListener(AstroidContactListener.HIT_EVENT, onHitShip);
			
			// astroidsGenerator
			m_astroidsGenerator = new AstroidsGenerator(m_world, m_dmtManager);
			addChild(m_astroidsGenerator);
			m_astroidsGenerator.start();
			
			spaceShip = new SpaceShip(m_world, m_dmtManager.getStarlingDisplayObject("spaceShip") as DisplayObject,new b2Vec2(10,35));
			
			addChild(spaceShip);
			makeDebugDraw();
			
			m_isActive = true;
			addEventListener(starling.events.Event.ENTER_FRAME, Update);
		}
		
		protected function onHitShip(event:flash.events.Event):void
		{
			m_isActive = false;
			var textfield : TextField = new TextField(Consts.screenSize_X, Consts.screenSize_Y, "Don't drink and Fly^%@!", "Arial", Consts.screenSize_Y/20, 0xffffff);
//			textfield.x = (Consts.screenSize_X-textfield.width)/2;
//			textfield.y = Consts.screenSize_Y/2;
			addChild(textfield);
			
			var myTimer : Timer = new Timer(3500,0);
			myTimer.addEventListener(TimerEvent.TIMER, CloseGame)
			myTimer.start()
		}
		
		protected function CloseGame(event:TimerEvent):void
		{
			NativeApplication.nativeApplication.exit();
		}
		
		public function Update(e:starling.events.Event):void
		{
			if (m_isActive==false)
				return;
			
			m_cloudsTile1.offsetY = m_cloudsTile1.offsetY + 0.5;
			m_cloudsTile2.offsetY = m_cloudsTile1.offsetY + 0.5;
			
			// we make the world run
			m_world.Step(m_timeStep, m_velocityIterations, m_positionIterations);
			m_world.ClearForces();
			
			// Go through body list and update sprite positions/rotations
			for (var bb:b2Body = m_world.GetBodyList(); bb; bb = bb.GetNext())
			{
				if (bb.GetUserData() is DisplayObject)
				{
					// we cast as a Starling DisplayObject, not the native one !
					var sprite:DisplayObject = bb.GetUserData() as DisplayObject;
					sprite.x = bb.GetPosition().x * Consts.pixels_in_a_meter;
					sprite.y = bb.GetPosition().y * Consts.pixels_in_a_meter;
					sprite.rotation = bb.GetAngle();
					
					if (sprite is Astroid)
					{
						if (sprite.y>stage.stageHeight)
						{
							// remove the astroid
						}
					}
				}
			}
			//m_world.DrawDebugData();
		}
		
		private function makeDebugDraw():void
		{
			// set debug draw
			var debugDraw:b2DebugDraw = new b2DebugDraw();
			var debugSprite:flash.display.Sprite = new flash.display.Sprite();
			Starling.current.nativeStage.addChild(debugSprite);
			debugDraw.SetSprite(debugSprite);
			debugDraw.SetDrawScale(30.0);
			debugDraw.SetFillAlpha(0.3);
			debugDraw.SetLineThickness(2.0);
			debugDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);
			m_world.SetDebugDraw(debugDraw);
		}
		
	}
}