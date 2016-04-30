package gameworld 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	public class Enemy extends Entity
	{
		
		
		public var sprite:Spritemap = new Spritemap(Assets.SOLDIER_W_WEAPON_FIRING, 24, 24);
		
		public var jumpPower:Number = 3;
		public var jumpPressed:Boolean = false;
		public var jumpCounter:int = 0;
		public var jumpFrames:int = 2;
		public var jumpAcceleration:Number = 1;
		
		public var speed:Point = new Point();
		public var maxspeed:Point = new Point(2, 6);
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
		
		public var aiMode:int = 0;
		public var aiMemory:Object = { };
		public static const IDLE:int = 0;
		public static const WANDER:int = 1;
		public static const ALERT:int = 2;
		
		
		//states
		public var jumping:Boolean = false;
		public var firing:Boolean = false;
		public var walking:Boolean = false;
		public var staggering:Boolean = false;
		public var dying:Boolean = false;
		
		public var papa:Game;
		public var scene1Mode:Boolean = false;
		
		
		public function Enemy(x:int, y:int) 
		{
			super(x+12, y+12,sprite);
			
			sprite.centerOO();
			sprite.add("stand", [0], 0, false);
			sprite.add("walk", [0,5], 5, true);
			sprite.add("jump", [0], 0, false);
			sprite.add("stagger", [0], 5, false);
			sprite.add("die", [0], 0, false);
			sprite.add("fire", [0,1,0,1,0,1,0,1,2,3,4,0,0,0,0,0,0,0,0,0,0], 10, true);
			
			sprite.play("stand");
			
			
			setHitbox(8, 17,4,8);
			type = "enemy";
			
			aiMode = WANDER;
		}
		
		override public function added():void 
		{
			super.added();
			papa = world as Game;
			
			scene1Mode = papa.scene1Mode;
		}
		
		override public function update():void 
		{
			if (papa.paused) return;
			
			onGround = isOnGround();
			
			if (alive)
			{
				GetInput();
				ApplyInput();
			}
			
			applyPhysics();
			Move();
			ChangeAnimation();
			
			if (firing)
			{
				if (sprite.frame == 0)
				{
					if (direction == 1 && papa.hero.collideRect(papa.hero.x, papa.hero.y, x, y, 1000, 1) ||
						direction == -1 && papa.hero.collideRect(papa.hero.x, papa.hero.y, x - 1000, y, 1000, 1))
						{
							papa.hero.Hit(1, false);
						}
				}
			}
			
			if (collideWith(papa.hero, x, y))
			{
				if (papa.scene1Mode)
				{
					papa.hero.Slap();
				} else
				{
					papa.hero.Hit(1, true);
					aiMode = IDLE;
					direction = (x < papa.hero.x)?1: -1;
				}
			}
			
			
		}
		
		private function ChangeAnimation():void 
		{
			sprite.flipped = (direction == -1);
			
			if (firing)
			{
				sprite.play("fire");
			} else
			if (walking)
			{
				sprite.play("walk");
			} else
			if (jumping)
			{
				sprite.play("jump");
			} else
			{
				sprite.play("stand");
			}
			
			if (staggering)
			{
				sprite.play("stagger");
			} else
			if (dying)
			{
				sprite.play("die");
			} 
			
		}
		
		private function GetInput():void
		{
			
			
			
			inputLeft = false;
			inputRight = false;
			inputUp = false;
			
			if (scene1Mode)
			{
				
				
				if (papa.gazenWagen.scene0HeroAproaches)
				{
					maxspeed.x = 0.5;
					inputRight = true;
				}
				
				if (papa.hero.x+20  < x || papa.hero.x-50>papa.gazenWagen.x)
				{
					scene1Mode = false;
					
					if (papa.hero.x+20  < x)
					aiMemory.goingLeft = true;
				}
				
			} else
			{
			
				maxspeed.x = 2.0;
				
				if (aiMode == WANDER)
				{
					var goingLeft:Boolean = Boolean(aiMemory.goingLeft);
					var checkHeroCounter:int = int(aiMemory.checkHeroCounter);
					
					if (isFallLeft() || isHitWallLeft())
						goingLeft = false;
					if (isFallRight() || isHitWallRight())
						goingLeft = true;
						
					//раз в 5 кадров чекаем видно ли героя
					if (checkHeroCounter++>=5)
					{
						checkHeroCounter = 0;
						if (direction == 1 && papa.hero.collideRect(papa.hero.x, papa.hero.y, x, y, 1000, 1) ||
							direction == -1 && papa.hero.collideRect(papa.hero.x, papa.hero.y, x-1000, y, 1000, 1))
						{
							aiMode = ALERT;
						}
					}
					
					inputLeft = goingLeft;
					inputRight = !goingLeft;
					inputUp = false;
					
					aiMemory.goingLeft = goingLeft;
					aiMemory.checkHeroCounter = checkHeroCounter;
				} else
				if (aiMode == ALERT)
				{
					checkHeroCounter = int(aiMemory.checkHeroCounter);
					
					firing = true;
					//sprite.play("fire");
					//раз в 5 кадров чекаем видно ли героя
					if (checkHeroCounter++>=12)
					{
						checkHeroCounter = 0;
						if (direction == 1 && papa.hero.collideRect(papa.hero.x, papa.hero.y, x, y, 1000, 1) ||
							direction == -1 && papa.hero.collideRect(papa.hero.x, papa.hero.y, x-1000, y, 1000, 1))
						{
							
						} else
						{
							firing = false;
							aiMode = WANDER;
						}
					}
					
					aiMemory.checkHeroCounter = checkHeroCounter;
					
				}
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
		
		private function isFallRight():Boolean
		{
			var dir:Object = {x:width,y:1};
			
			return !(collide("solid", x + dir.x, y + dir.y) != null);
		}
		
		private function isFallLeft():Boolean
		{
			var dir:Object = {x:-width,y:1};
			
			return !(collide("solid", x + dir.x, y + dir.y) != null);
		}		
		
		
		
		private function Move():void 
		{
			speed.x = horizontalSpeed;
			speed.y = verticalSpeed;
			moveBy(speed.x, speed.y, "solid", true);
			
			if (isOnGround() || isHitRoof())
			{
				jumping = false;
				verticalSpeed = 0;
				
			}
			if (isHitWallLeft() || isHitWallRight())
			{
				horizontalSpeed = 0;
			}
		}
		
		private function ApplyInput():void 
		{
			if (inputLeft)
			{
				horizontalSpeed -= acceleration;
				direction = - 1;
				sprite.flipped = true;
				
				if (onGround)
				{
					walking = true;
					//sprite.play("walk");
				}
			}
			else
			if (inputRight)
			{
				horizontalSpeed += acceleration;
				direction = 1;
				sprite.flipped = false;
				
				if (onGround)
				{
					walking = true;
					//sprite.play("walk");
				}
			}
			else
			{
				if (onGround)
				{
					walking = false;
					//sprite.play("stand");
				}
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
						
						jumping = true;
						//sprite.play("jump");
					} 
				}
				else
				{
					jumping = true;
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
		
		public function Hit(dmg:int,nonLethal:Boolean=false):void
		{
			if (!alive) return;
			
			hp -= dmg;
			if (hp < 0)
			{
				hp = 0;
				alive = false;
				
				if (nonLethal)
				{
					staggering = true;
					//sprite.play("stagger");
				}
				else
				{
					dying = true;
					//sprite.play("die");
				}
				
				inputLeft = inputRight = inputUp = false;
			}
		}
		
		//memento
		
		public function GetMemento():EnemyMemento
		{
			var memo:EnemyMemento = new EnemyMemento();
			
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
			memo.maxspeed = this.maxspeed.clone();
			memo.verticalSpeed= this.verticalSpeed;
			memo.horizontalSpeed = this.horizontalSpeed;
			
			memo.sprite_flipped = this.sprite.flipped;
			memo.sprite_anim = this.sprite.currentAnim;
			memo.sprite_frame = this.sprite.frame;
			
			memo.aiMode = this.aiMode;
			memo.aiMemory = CloneObject(this.aiMemory);
			
			
			memo.aiMode = this.aiMode;
			memo.aiMode = this.aiMode;
			memo.aiMode = this.aiMode;
			
			
			memo.jumping = this.jumping;
			memo.firing = this.firing;
			memo.walking = this.walking;
			memo.staggering = this.staggering;
			memo.dying = this.dying;			
			
			
			memo.scene1Mode= this.scene1Mode;
			
			return memo;
		}

		
		
		public function SetMemento(memo:EnemyMemento):void
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
			
			this.maxspeed= memo.maxspeed.clone();
			this.speed = memo.speed.clone();
			this.verticalSpeed= memo.verticalSpeed;
			this.horizontalSpeed = memo.horizontalSpeed;
			
			this.sprite.flipped = memo.sprite_flipped;
			this.sprite.play(memo.sprite_anim, true, memo.sprite_frame);
			
			this.aiMode = memo.aiMode;
			this.aiMemory = CloneObject(memo.aiMemory);
			
			this.jumping = memo.jumping;
			this.firing = memo.firing;
			this.walking = memo.walking;
			this.staggering = memo.staggering;
			this.dying = memo.dying;
			
			this.scene1Mode= memo.scene1Mode;
			
			
		}	
		
		
		
		
		public static function CloneObject(obj:Object):Object
		{
			if (obj is String || obj is int || obj is Number || obj is Boolean)
				return obj;
				
			if (obj is Array)
				(obj as Array).slice();
			
			var result:Object = { };
			for (var name:String in obj) 
			{
				result[name] = CloneObject(obj[name]);
			}
			return result;
		}		
	}

}