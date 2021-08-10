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



class Design_2_2_Movement extends ActorScript
{
	public var _WalkSpeed:Float;
	public var _OnGround:Bool;
	public var _WasHit:Bool;
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("Actor", "actor");
		nameMap.set("Walk Speed", "_WalkSpeed");
		_WalkSpeed = 0.0;
		nameMap.set("OnGround", "_OnGround");
		_OnGround = false;
		nameMap.set("WasHit", "_WasHit");
		_WasHit = false;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if(!(_WasHit))
				{
					if(isKeyDown("left"))
					{
						actor.setXVelocity(-(_WalkSpeed));
						if(_OnGround)
						{
							actor.setAnimation("Walk");
						}
						actor.growTo(-100/100, 100/100, 0, Easing.linear);
					}
					else if(isKeyDown("right"))
					{
						actor.setXVelocity(_WalkSpeed);
						if(_OnGround)
						{
							actor.setAnimation("Walk");
						}
						actor.growTo(100/100, 100/100, 0, Easing.linear);
					}
					else
					{
						actor.setXVelocity(0);
						if(_OnGround)
						{
							actor.setAnimation("Idle");
						}
					}
					if((isKeyPressed("up") && _OnGround))
					{
						actor.applyImpulse(0, -1, 60);
						actor.setAnimation("Jump");
						_OnGround = false;
					}
				}
			}
		});
		
		/* ======================== Something Else ======================== */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if((event.thisFromBottom && (actor.getYVelocity() == 0)))
				{
					_OnGround = true;
				}
				if((event.otherActor.getGroup() == getActorGroup(4)))
				{
					_WasHit = true;
					actor.setAnimation("Hit");
					actor.setXVelocity(0);
					actor.setYVelocity(0);
					actor.applyImpulse(0, -1, 20);
					reloadCurrentScene(createFadeOut(1, Utils.getColorRGB(0,0,0)), createFadeIn(1, Utils.getColorRGB(0,0,0)));
				}
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}