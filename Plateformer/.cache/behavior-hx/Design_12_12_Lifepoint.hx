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
import box2D.collision.shapes.B2Shape;

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



class Design_12_12_Lifepoint extends SceneScript
{
	public var _Lifepoint:Float;
	public var _HeartActor:ActorType;
	public var _ListofHealth:Array<Dynamic>;
	public var _DamageDelay:Bool;
	public var _Maxlifepoints:Float;
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_Increase_lifepoints():Void
	{
		if((_Lifepoint < _Maxlifepoints))
		{
			_Lifepoint += 1;
			createRecycledActor(_HeartActor, ((getScreenXCenter() - (getScreenWidth() / 2)) + (_ListofHealth.length * 32)), (getScreenYCenter() - (getScreenHeight() / 2)), Script.FRONT);
			getLastCreatedActor().anchorToScreen();
			_ListofHealth.push(getLastCreatedActor());
		}
	}
	
	
	public function new(dummy:Int, dummy2:Engine)
	{
		super();
		nameMap.set("Lifepoint", "_Lifepoint");
		_Lifepoint = 0.0;
		nameMap.set("Heart Actor", "_HeartActor");
		nameMap.set("List of Health", "_ListofHealth");
		nameMap.set("Damage Delay", "_DamageDelay");
		_DamageDelay = false;
		nameMap.set("Max lifepoints", "_Maxlifepoints");
		_Maxlifepoints = 0.0;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		_ListofHealth = new Array<Dynamic>();
		_Maxlifepoints = _Lifepoint;
		for(index0 in 0...Std.int(_Lifepoint))
		{
			createRecycledActor(_HeartActor, ((getScreenXCenter() - (getScreenWidth() / 2)) + (index0 * 32)), (getScreenYCenter() - (getScreenHeight() / 2)), Script.FRONT);
			getLastCreatedActor().anchorToScreen();
			_ListofHealth.push(getLastCreatedActor());
		}
		
		/* ========================= Type & Type ========================== */
		addSceneCollisionListener(getActorType(0).ID, getActorType(7).ID, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if(!(_DamageDelay))
				{
					_DamageDelay = true;
					runLater(1000 * 2, function(timeTask:TimedTask):Void
					{
						_DamageDelay = false;
					}, null);
					_Lifepoint -= 1;
					recycleActor((_ListofHealth[(_ListofHealth.length - 1)] : Actor));
					_ListofHealth.splice((_ListofHealth.length - 1), 1);
					if((_Lifepoint == 0))
					{
						event.thisActor.setAnimation("Hit");
						reloadCurrentScene(createFadeOut(1, Utils.getColorRGB(0,0,0)), createFadeIn(1, Utils.getColorRGB(0,0,0)));
					}
				}
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}