package gameworld 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	public class Hero extends Entity
	{
		private var slapped:Boolean=false;
		public var slapCounter:int=0;
		
		public var sprite:Spritemap = new Spritemap(Assets.PRISONER_ANIME, 13, 17);
		
		public var jumpPower:Number = 3;
		public var jumpPressed:Boolean = false;
		public var jumpCounter:int = 0;
		public var jumpFrames:int = 2;
		public var jumpAcceleration:Number = 1;
		
		public var speed:Point = new Point();
		public var maxspeed:Point = new Point(3, 6);
		public var friction:Number = 1;
		public var acceleration:Number = 1.0;
		public var gravity:Number = 0.5;
		
		public var direction:int = 1;
		public var onGround:Boolean = false;
		
		public var inputLeft:Boolean = false;
		public var inputRight:Boolean = false;
		public var inputUp:Boolean = false;
		
		public var horizontalSpeed:Number = 0;
		public var verticalSpeed:Number = 0;
		
		public var hp:int = 1;
		public var alive:Boolean = true;
		public var deadTimer:int = 0;
		
		public var controllable:Boolean = true;
		public static var immortal:Boolean = false;
		
		public var papa:Game;
		
		
		public function Hero(x:int, y:int) 
		{
			super(x+6, y+8,sprite);
			
			sprite.centerOO();
			sprite.add("stand", [0], 0, false);
			sprite.add("walk", [1, 2], 10, true);
			sprite.add("jump", [1], 0, false);
			sprite.add("stagger", [3], 5, false);
			sprite.add("die", [4], 5, false);
			sprite.play("walk");
			
			
			
			
			setHitbox(8, 17,4,8);
			type = "hero";
			
			//var img:Image = Image.createCircle(8, 0x808080);
			//img.centerOO();
			//graphic = img;
			
			
		}
		
		override public function added():void 
		{
			super.added();
			papa = world as Game;
		}
		
		override public function update():void 
		{
			if (papa.paused) return;
			
			onGround = isOnGround();
			
			inputLeft = inputRight = inputUp = false;
			
			if (alive && controllable)
				GetInput();
			
			if (slapped)
			{
				horizontalSpeed = FP.lerp(7, 0, slapCounter/10.0);;
				direction = 1;
				sprite.flipped = false;
				slapCounter++;
				if (slapCounter > 10)
				{
					slapped = false;
					controllable = true;
				}
			}
				
			applyPhysics();
			Move();
			
			if (!alive)
			{
				deadTimer++;
				if (deadTimer > 30)
				{
					deadTimer = 0;
					if (immortal)
						papa.timeMachine.RecordRewind();
					else
						papa.heroDiedWithoutImmortality = true;
				}
			}
		}
		
		private function GetInput():void
		{
			inputLeft = (Input.check(Key.LEFT) || Input.check(Key.A));
			inputRight = (Input.check(Key.RIGHT) || Input.check(Key.D));
			inputUp = (Input.check(Key.UP) || Input.check(Key.W));
			
			
			if (inputLeft)
			{
				horizontalSpeed -= acceleration;
				direction = - 1;
				sprite.flipped = true;
				
				if (onGround)
				sprite.play("walk");
			}
			else
			if (inputRight)
			{
				horizontalSpeed += acceleration;
				direction = 1;
				sprite.flipped = false;
				
				if (onGround)
				sprite.play("walk");
			}
			else
			{
				if (onGround)
				sprite.play("stand");
			}
			
			if (inputUp)
			{
				if (!jumpPressed)
				{
					if (onGround)
					{
						verticalSpeed = -jumpPower;
						jumpPressed = true;
						jumpCounter = 0;
						sprite.play("jump");
					} 
				}
				else
				{
					jumpCounter++;
					verticalSpeed -= jumpAcceleration;
					
					if (jumpCounter > jumpFrames)
						jumpPressed = false;
				}
			} else
			{
				jumpPressed = false;
			}
			
		}		
		
		private function applyPhysics():void
		{
			// gravity
			verticalSpeed += gravity;
			
			// friction
			if (!inputLeft && !inputRight)
			{
				var dir:int = FP.sign(horizontalSpeed);
				horizontalSpeed -= dir * friction;
				
				if (dir != FP.sign(horizontalSpeed))
					horizontalSpeed = 0.0;
			}
			
			// maxspeed
			var m:Point =  maxspeed;
			
			if (Math.abs(horizontalSpeed) > m.x)
				horizontalSpeed = FP.sign(horizontalSpeed)*m.x;
			if (Math.abs(verticalSpeed) > m.y)
				verticalSpeed = FP.sign(verticalSpeed)*m.y;
		}
		
		private function isOnGround():Boolean
		{
			var dir:Object = {x:0,y:1};
			
			return (collide("solid", x + dir.x, y + dir.y) != null);
		}		
		
		private function isHitRoof():Boolean
		{
			var dir:Object = {x:0,y:-1};
			
			return (collide("solid", x + dir.x, y + dir.y) != null);
		}		
		
		private function isHitWallLeft():Boolean
		{
			var dir:Object = {x:-1,y:0};
			
			return (collide("solid", x + dir.x, y + dir.y) != null);
		}		
		
		private function isHitWallRight():Boolean
		{
			var dir:Object = {x:1,y:0};
			
			return (collide("solid", x + dir.x, y + dir.y) != null);
		}
		
		private function Move():void 
		{
			speed.x = horizontalSpeed;
			speed.y = verticalSpeed;
			moveBy(speed.x, speed.y, "solid", true);
			
			if (isOnGround() || isHitRoof())
			{
				verticalSpeed = 0;
				
			}
			if (isHitWallLeft() || isHitWallRight())
			{
				horizontalSpeed = 0;
			}
		}
		
		public function Hit(dmg:int,nonLethal:Boolean=false):void
		{
			if (!alive) return;
			
			hp -= dmg;
			if (hp < 0)
			{
				hp = 0;
				alive = false;
				
				if (nonLethal)
				sprite.play("stagger");
				else
				sprite.play("die");
				
				Main.blink = true;
				
				inputLeft = inputRight = inputUp = false;
			}
		}
		
		public function Slap():void
		{
			controllable = false;
			sprite.play("stagger");
			
			slapCounter = 0;
			slapped = true;
		}
		
		//memento
		
		public function GetMemento():HeroMemento
		{
			var memo:HeroMemento = new HeroMemento();
			
			memo.x = this.x;
			memo.y = this.y;
			
			memo.hp = this.hp;
			memo.alive = this.alive;
			
			memo.direction = this.direction;
			
			memo.inputLeft = this.inputLeft;
			memo.inputRight = this.inputRight;
			memo.inputUp = this.inputUp;
			
			memo.jumpCounter = this.jumpCounter;
			memo.jumpPressed = this.jumpPressed;
			
			memo.onGround = this.onGround;
			
			memo.speed = this.speed.clone();
			memo.verticalSpeed= this.verticalSpeed;
			memo.horizontalSpeed = this.horizontalSpeed;
			
			memo.sprite_flipped = this.sprite.flipped;
			memo.sprite_anim = this.sprite.currentAnim;
			memo.sprite_frame = this.sprite.frame;
			
			memo.visible = this.visible;
			
			return memo;
		}
		
		
		public function SetMemento(memo:HeroMemento):void
		{
			this.x = memo.x;
			this.y = memo.y;
			
			this.hp = memo.hp;
			this.alive = memo.alive;
			
			this.direction = memo.direction;
			
			this.inputLeft = memo.inputLeft;
			this.inputRight = memo.inputRight;
			this.inputUp = memo.inputUp;
			
			this.jumpCounter = memo.jumpCounter;
			this.jumpPressed = memo.jumpPressed;
			
			this.onGround = memo.onGround;
			
			this.speed = memo.speed.clone();
			this.verticalSpeed= memo.verticalSpeed;
			this.horizontalSpeed = memo.horizontalSpeed;
			
			this.sprite.flipped = memo.sprite_flipped;
			this.sprite.play(memo.sprite_anim, true, memo.sprite_frame);
			
			this.visible = memo.visible;
			
		}		
	}

}