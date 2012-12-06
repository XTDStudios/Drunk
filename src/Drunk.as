package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import starling.core.Starling;
	
	[SWF(frameRate="60", width="480", height="780", backgroundColor="0x333333")]
	public class Drunk extends Sprite
	{
		private var myStarling:Starling;

		public function Drunk()
		{
			super();
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			stage.addEventListener(Event.RESIZE, onStageResize);
		}

		protected function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);			
		}
		
		private var t: Timer = new Timer(100);
		
		protected function onStageResize(event:Event):void
		{
			t.addEventListener(TimerEvent.TIMER,initGame);
			t.start();
		}
		
		protected function initGame(event:TimerEvent):void
		{
			t.removeEventListener(TimerEvent.TIMER,initGame);
			t.stop();
			stage.removeEventListener(Event.RESIZE, onStageResize);
			// Initialize Starling object.
			myStarling = new Starling(Game, stage);
			
			// Define basic anti aliasing.
			myStarling.antiAliasing = 1;
			
			// Show statistics for memory usage and fps.
			myStarling.showStats = true;
			
			// Start Starling Framework.
			myStarling.start();			
		}
	}
}