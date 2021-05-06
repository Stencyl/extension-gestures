package com.stencyl.gestures;

import com.stencyl.Engine;

import openfl.geom.Point;

using com.stencyl.event.EventDispatcher;

class GesturesInput
{
	public static var swipedUp:Bool;
	public static var swipedDown:Bool;
	public static var swipedLeft:Bool;
	public static var swipedRight:Bool;
	
	//private
	private static var _enabled:Bool = false;

	private static var _roxAgent:RoxGestureAgent;
	private static var _swipeDirection:Int;

	public static function resetStatics():Void
	{
		_roxAgent.detach();
		Engine.engine.root.removeEventListener(RoxGestureEvent.GESTURE_SWIPE, onSwipe);

		swipedUp = swipedDown = swipedRight = swipedLeft = false;
		_swipeDirection = 0;
		_roxAgent = null;
	}

	public static function enable()
	{
		if(!_enabled && Engine.stage != null)
		{
			_roxAgent = new RoxGestureAgent(Engine.engine.root, RoxGestureAgent.GESTURE);
			Engine.engine.root.addEventListener(RoxGestureEvent.GESTURE_SWIPE, onSwipe);

			_swipeDirection = -1;
			swipedLeft = false;
			swipedRight = false;
			swipedUp = false;
			swipedDown = false;
	        
	        _enabled = true;
		}
	}

	public static function update()
	{
		swipedLeft = false;
		swipedRight = false;
		swipedUp = false;
		swipedDown = false;
		
		if(_swipeDirection > -1)
		{
			switch(_swipeDirection)
			{
				case 0:
					swipedLeft = true;
				case 1:
					swipedRight = true;
				case 2:
					swipedUp = true;
				case 3:
					swipedDown = true;
			}
			
			if(Engine.engine.whenSwiped != null)
			{
				Engine.engine.whenSwiped.dispatch();
			}
			
			_swipeDirection = -1;
		}
	}

	private static function onSwipe(e:RoxGestureEvent):Void
	{
		var pt = cast(e.extra, Point);
        
        if(Math.abs(pt.x) <= Math.abs(pt.y))
        {
        	//Up
        	if(pt.y <= 0)
        	{
        		_swipeDirection = 2;
        	}
        	
        	//Down
        	else
        	{
        		_swipeDirection = 3;
        	}
        }
        
        else if(Math.abs(pt.x) > Math.abs(pt.y))
        {
        	//Left
        	if(pt.x <= 0)
        	{
        		_swipeDirection = 0;
        	}
        	
        	//Right
        	else
        	{
        		_swipeDirection = 1;
        	}
        }
	}
}
