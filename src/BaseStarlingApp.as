/*
Copyright 2012 XTD Studios Ltd.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/
package com.xtdstudios.gameEngine.base
{
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import starling.core.Starling;
	import starling.events.Event;
	
	public class BaseStarlingApp extends Sprite 
	{
		private var m_splash				: Sprite;
		
		protected static const SOFTWARE_TARGET_FRAMERATE : int = 30; 
		protected static const HARDWARE_TARGET_FRAMERATE : int = 60;  
		
		private var m_targetFramerate		: int;
		private var m_Starling				: Starling;
		private var m_countFrames			: int;
		private var m_waitingForContext		: Boolean;
		private var m_gameManager			: GameManager; 	
		private var m_resizeTimeoutTimer 	: Timer;
		private var m_deactivationTime	 	: Number;
		
		public function BaseStarlingApp(gameManager:GameManager, stageColor:uint = 0x000000, spalshClass:Class = null)
		{
			m_gameManager = gameManager;

			addEvents();
			
			stage.color = stageColor;  
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			CONFIG::isApple
			{
				SilentSwitch.apply();
			}
			
			// splash screen
			if (spalshClass)
			{
				m_splash = new spalshClass();
				m_splash.name = "splashScreen";
				m_splash.width = stage.stageWidth;
				m_splash.height = stage.stageHeight;
				stage.addChild(m_splash);
			}
			
			m_targetFramerate = HARDWARE_TARGET_FRAMERATE;
			
			m_deactivationTime = 0;
			m_waitingForContext = false;
			
			
			// timeout for stage resize
			m_resizeTimeoutTimer = new Timer(1000, 1);
			m_resizeTimeoutTimer.addEventListener(TimerEvent.TIMER, onStageResized);
			m_resizeTimeoutTimer.start();
		}
		
		private function addEvents():void
		{
			CONFIG::mobileApp
			{
				import flash.desktop.NativeApplication;
				
				NativeApplication.nativeApplication.addEventListener(flash.events.Event.DEACTIVATE , onDeactivate);
				NativeApplication.nativeApplication.addEventListener(flash.events.Event.ACTIVATE , onActivate);
			}
			
			stage.addEventListener(flash.events.Event.RESIZE, onStageResized);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		private function removeEvents():void
		{
			CONFIG::mobileApp
			{
				import flash.desktop.NativeApplication;
				
				NativeApplication.nativeApplication.removeEventListener(flash.events.Event.DEACTIVATE , onDeactivate);
				NativeApplication.nativeApplication.removeEventListener(flash.events.Event.ACTIVATE , onActivate);
			}
			
			stage.removeEventListener(flash.events.Event.RESIZE, onStageResized);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		protected function onKeyDown(event:KeyboardEvent):void
		{
			m_gameManager.processKeyDown(event);
		}
		
		protected function onStageResized(event:flash.events.Event=null):void
		{
			if (m_resizeTimeoutTimer)
			{
				m_resizeTimeoutTimer.removeEventListener(TimerEvent.TIMER, onStageResized);
				m_resizeTimeoutTimer.stop();
				m_resizeTimeoutTimer = null;
			}
			
			var sw : int = stage.stageWidth;
			var sh : int = stage.stageHeight;
			
			trace("onStageResized", sw, sh);
			
			// fit the splash screen to the new stage size
			if (m_splash)
			{
				m_splash.width = sw;
				m_splash.height = sh;
			}
			
			// fit starling stage to the new stage size
			if (Starling.current && Starling.current.stage)
			{
				Starling.current.stage.stageWidth = sw;
				Starling.current.stage.stageHeight  = sh;
				var viewPort:Rectangle = new Rectangle(0, 0, sw, sh);
				Starling.current.viewPort = viewPort;
			}
			
			if (m_waitingForContext==false)
				waitForContext();
		}
		
		private function waitForContext():void
		{
			trace("waitForContext");
			m_waitingForContext = true;
			stage.stage3Ds[0].addEventListener(flash.events.Event.CONTEXT3D_CREATE, onContextCreated, false, 0, true);
			stage.stage3Ds[0].requestContext3D("auto", "baselineConstrained");
		}
		
		private function onContextCreated(event:flash.events.Event):void
		{
			trace("onContextCreated");
			event.stopImmediatePropagation();
			
			// set framerate to 30 in software mode
			if (stage.stage3Ds[0].context3D.driverInfo.toLowerCase().indexOf("software") != -1)
				m_targetFramerate = SOFTWARE_TARGET_FRAMERATE;
			else
				m_targetFramerate = HARDWARE_TARGET_FRAMERATE;
			
			// updating the frame rate
			stage.frameRate = m_targetFramerate;
			
			if (m_Starling)
				disposeStarling();
			
			initStarling();
		}
		
		protected function initStarling():void
		{
			trace("initStarling");
			// we are quite sure that we have the right stage size, init the game manager
			if (m_gameManager.initialized==false)
				m_gameManager.initialize(stage);
			
			stage.stage3Ds[0].context3D.configureBackBuffer(stage.stageWidth, stage.stageHeight, 0, false);
			
			Starling.multitouchEnabled = true;
			Starling.handleLostContext = false; // we will handle it ourselves
			
			m_Starling = new Starling(StarlingRoot, stage);
			m_Starling.addEventListener(starling.events.Event.ROOT_CREATED, onStarlingRootCreated);
			m_Starling.stage.stageWidth  = stage.stageWidth;
			m_Starling.stage.stageHeight = stage.stageHeight;
			var viewPort:Rectangle = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			m_Starling.viewPort = viewPort;
			
			m_Starling.antiAliasing = 1;
			
			CONFIG::showStats
			{
				m_Starling.showStats = true;
			}
			
			CONFIG::debug
			{
				m_Starling.enableErrorChecking = true; 
			}
			
			m_Starling.start();
			
			stage.addEventListener(flash.events.Event.ENTER_FRAME, onStarlingEnterFrame, false, 0, true);
		}
		
		private function onStarlingRootCreated(event:starling.events.Event):void
		{
			trace("onStarlingRootCreated");
			if (m_splash && m_splash.parent)
				m_splash.parent.removeChild(m_splash);
			
			// add the game rootContainer to starling's root
			var starlingRoot : StarlingRoot = event.data as StarlingRoot;
			starlingRoot.addChild(m_gameManager.rootContainer);
			
			m_gameManager.startGame(); 
		}
		
		private function disposeStarling():void
		{
			trace("disposeStarling");
			stage.removeEventListener(flash.events.Event.ENTER_FRAME, onStarlingEnterFrame);
			
			// remove the rootContainer, so it wont get disposed by starling
			if (m_gameManager && m_gameManager.rootContainer && m_gameManager.rootContainer.parent)
				m_gameManager.rootContainer.parent.removeChild(m_gameManager.rootContainer);
			
			m_Starling.removeEventListener(starling.events.Event.ROOT_CREATED, onStarlingRootCreated);
			
			// Clear the old buffer contents
			m_Starling.context.clear();
			m_Starling.context.present();
			
			m_Starling.dispose();
			m_Starling = null;
			
			// return the splash screen
			if (m_splash)
				stage.addChild(m_splash);
		}
		
		private function onStarlingEnterFrame(event:flash.events.Event):void
		{
			if (m_Starling && m_Starling.context)
			{
				m_Starling.context.clear();
				m_Starling.nextFrame();
				m_Starling.context.present();
			}
		}
		
		
		protected function onActivate(event:flash.events.Event):void
		{
			trace("onActivate");
			stage.frameRate = m_targetFramerate;
			
			CONFIG::mobileApp
			{
				NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
			}
			
			// if more than 2 hours passed from the last deactivation
			// we count it as application started.
			var timePassedFromDeactivation : Number = getTimer()-m_deactivationTime;
			if (timePassedFromDeactivation>1000*60*2)
				m_gameManager.trackApplicationStarted();
		}
		
		protected function onDeactivate(event:flash.events.Event):void
		{
			trace("onDeactivate");
			
			CONFIG::mobileApp
			{
				NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.NORMAL;
			}
			
			m_deactivationTime = getTimer();
			CONFIG::slowFPSOnDeactivate
			{
				stage.frameRate = 2;
			}
		}
	}
}
