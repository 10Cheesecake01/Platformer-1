package scripts;

import com.stencyl.graphics.G;
import com.stencyl.graphics.BitmapWrapper;
import com.stencyl.graphics.ScaleMode;

import com.stencyl.behavior.Script;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.ActorScript;
import com.stencyl.behavior.SceneScript;
import com.stencyl.behavior.TimedTask;

import com.stencyl.models.Actor;
import com.stencyl.models.GameModel;
import com.stencyl.models.actor.Animation;
import com.stencyl.models.actor.ActorType;
import com.stencyl.models.actor.Collision;
import com.stencyl.models.actor.Group;
import com.stencyl.models.Scene;
import com.stencyl.models.Sound;
import com.stencyl.models.Region;
import com.stencyl.models.Font;
import com.stencyl.models.Joystick;

import com.stencyl.Config;
import com.stencyl.Engine;
import com.stencyl.Input;
import com.stencyl.Key;
import com.stencyl.utils.motion.*;
import com.stencyl.utils.Utils;

import openfl.ui.Mouse;
import openfl.display.Graphics;
import openfl.display.BlendMode;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.events.TouchEvent;
import openfl.net.URLLoader;

import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2Fixture;
import box2D.dynamics.joints.B2Joint;

import com.stencyl.graphics.shaders.BasicShader;
import com.stencyl.graphics.shaders.GrayscaleShader;
import com.stencyl.graphics.shaders.SepiaShader;
import com.stencyl.graphics.shaders.InvertShader;
import com.stencyl.graphics.shaders.GrainShader;
import com.stencyl.graphics.shaders.ExternalShader;
import com.stencyl.graphics.shaders.InlineShader;
import com.stencyl.graphics.shaders.BlurShader;
import com.stencyl.graphics.shaders.SharpenShader;
import com.stencyl.graphics.shaders.ScanlineShader;
import com.stencyl.graphics.shaders.CSBShader;
import com.stencyl.graphics.shaders.HueShader;
import com.stencyl.graphics.shaders.TintShader;
import com.stencyl.graphics.shaders.BloomShader;



class Design_6_6_EnemyBehavior extends ActorScript
{
	public var _StartX:Float;
	public var _StartY:Float;
	public var _StopX:Float;
	public var _StopY:Float;
	public var _MovingSpeed:Float;
	public var _GoingToStopPoint:Bool;
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_ChangeTarget():Void
	{
		if(_GoingToStopPoint)
		{
			/* Back to Start point */
			_GoingToStopPoint = false;
			actor.moveTo(_StartX, _StartY, (Math.sqrt((Math.pow((_StartX - _StopX), 2) + Math.pow((_StartY - _StopY), 2))) / _MovingSpeed), Easing.linear);
		}
		else
		{
			/* Back to Stop point */
			_GoingToStopPoint = true;
			actor.moveTo(_StopX, _StopY, (Math.sqrt((Math.pow((_StartX - _StopX), 2) + Math.pow((_StartY - _StopY), 2))) / _MovingSpeed), Easing.linear);
		}
	}
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("Actor", "actor");
		nameMap.set("Start X", "_StartX");
		_StartX = 0.0;
		nameMap.set("Start Y", "_StartY");
		_StartY = 0.0;
		nameMap.set("Stop X", "_StopX");
		_StopX = 0.0;
		nameMap.set("Stop Y", "_StopY");
		_StopY = 0.0;
		nameMap.set("Moving Speed", "_MovingSpeed");
		_MovingSpeed = 0.0;
		nameMap.set("GoingToStopPoint", "_GoingToStopPoint");
		_GoingToStopPoint = false;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		actor.makeAlwaysSimulate();
		_StartX = actor.getX();
		_StartY = actor.getY();
		_customEvent_ChangeTarget();
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if(((actor.getX() == _StartX) && (actor.getY() == _StartY)))
				{
					_customEvent_ChangeTarget();
				}
				else if(((actor.getX() == _StopX) && (actor.getY() == _StopY)))
				{
					_customEvent_ChangeTarget();
				}
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}