package;

import PauseSubState;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import towsterFlxUtil.Paths;
import towsterFlxUtil.Sprite;

class PlayState extends FlxState
{
	var BG1:FlxSprite;
	var BG2:FlxSprite;
	var BG3:FlxSprite;
	var BG4:FlxSprite;
	var BG5:FlxSprite;
	var BG6:FlxSprite;
	var BG7:FlxSprite;
	var BG22:FlxSprite;
	var BG32:FlxSprite;
	var BG42:FlxSprite;
	var BG52:FlxSprite;
	var BG62:FlxSprite;
	var BG72:FlxSprite;

	var maxPanning:Int = 40;

	var hardMode:Bool = false;

	var isShooting:Bool = false;

	var pauseMenu:PauseSubState;

	var mainChar:Sprite;

	var bossMan:Sprite;
	var bossHealth:Int = 1000;
	var playerHealth:Int = 1000;

	// 1001 = basic Bullet
	var bulletType:Int = 0;
	// 0 = cat & terry
	var playerType:Int = 0;
	var bulletTimer:towsterFlxUtil.Timer;
	var bullets:FlxTypedSpriteGroup<Bullet>;

	var playerBulletType:Int = 0;
	var playerBulletTimer:towsterFlxUtil.Timer;
	var playerBullets:FlxTypedSpriteGroup<Bullet>;

	var cashOffset:Int = 0;

	override public function create()
	{
		backgroundCreate();

		FlxG.autoPause = false;
		destroySubStates = false;
		pauseMenu = new PauseSubState(0xB7676767);

		playerType = FloatingVarables.characterType;

		playerBullets = new FlxTypedSpriteGroup(0, 0, 9999);
		add(playerBullets);

		switch (playerType)
		{
			case 0:
				mainChar = new Sprite(100, 0, 'characters/cat_and_terry');
				mainChar.animation.addByPrefix('idle', 'cat and terry idle0', 24);
				mainChar.animation.addByPrefix('hurt', 'cat and terry hurt0', 24, false);
				mainChar.animation.addByPrefix('dead', 'cat and terry dead0', 24);
				mainChar.animation.addByPrefix('attack', 'cat and terry attack0', 24, false);
				mainChar.addOffset('idle', 130, 65);
				mainChar.addOffset('hurt', 130, 65);
				mainChar.addOffset('dead', 130, 65);
				mainChar.addOffset('attack', 130, 65);
			case 1:
				mainChar = new Sprite(100, 0, 'characters/wilson_wildcard');
				mainChar.animation.addByPrefix('idle', 'wilson idle0', 24);
				mainChar.animation.addByPrefix('attack', 'wilson attack0', 24, false);
				mainChar.animation.addByPrefix('dead', 'wilson dead0', 24);
				mainChar.animation.addByPrefix('hurt', 'wilson hurt0', 24, false);
				mainChar.addOffset('idle', 80, 65);
				mainChar.addOffset('hurt', 80, 65);
				mainChar.addOffset('dead', 80, 65);
				mainChar.addOffset('attack', 80, 65);
		}
		mainChar.playAnim('idle');
		mainChar.scale.set(0.4, 0.4);
		mainChar.updateHitbox();
		mainChar.screenCenter(Y);
		add(mainChar);

		bullets = new FlxTypedSpriteGroup(0, 0, 9999);
		add(bullets);

		bossMan = new Sprite(1000, 300, 'characters/monopolyMan');
		bossMan.animation.addByPrefix('idle', 'monopoly man idle0', 24);
		bossMan.animation.addByPrefix('attack', 'monopoly man attack0', 24, false);
		bossMan.animation.addByPrefix('dead', 'monopoly man dead0', 24);
		bossMan.animation.addByPrefix('head', 'monopoly man hurt0', 24, false);

		bossMan.addOffset('idle', 200, 130);
		bossMan.addOffset('attack', 200, 130);
		bossMan.addOffset('dead', 200, 150);
		bossMan.addOffset('head', 200, 130);

		bossMan.scale.set(0.5, 0.5);
		bossMan.updateHitbox();
		bossMan.screenCenter(Y);
		add(bossMan);
		bossMan.playAnim('idle');

		bulletTimer = new towsterFlxUtil.Timer(400);
		playerBulletTimer = new towsterFlxUtil.Timer(100);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		movement();

		backgroundUpdate();
		if (FlxG.keys.justPressed.J)
			mainChar.playAnim('idle');
		if (FlxG.keys.justPressed.K)
			mainChar.playAnim('dead');
		if (FlxG.keys.justPressed.L)
			mainChar.playAnim('attack');
		if (FlxG.keys.justPressed.I)
			mainChar.playAnim('hurt');

		if (mainChar.animation.finished)
		{
			if (isShooting)
			{
				mainChar.playAnim('attack');
			}
			else
			{
				mainChar.playAnim('idle');
			}
		}

		bulletTimer.timer += elapsed;
		playerBulletTimer.timer += elapsed;

		if (bulletTimer.justPassed())
		{
			if (bulletType < 3)
			{
				cashOffset += 10;
				for (i in 0...10)
				{
					bullets.add(new Bullet(bossMan.x + 25, bossMan.y + 140, 0, i * 72 + cashOffset));
				}

				bullets.add(new Bullet(1400, Math.random() * 850 + 25, 1, Math.random() * 10 + 5));

				bullets.forEachAlive(function(bullet)
				{
					if (bullet.bulletType == 1 && Math.random() * 10 < 5)
					{
						if (hardMode)
						{
							for (i in 0...2)
							{
								bullets.add(new Bullet(bullet.x, bullet.y + 25, 2, i));
							}
						}
						else
						{
							bullets.add(new Bullet(bullet.x, bullet.y + 25, 2, 2));
						}
					}
				});
			}
		}

		bullets.forEachAlive(function(bullet)
		{
			bullet.move();
			if (bullet.overlaps(mainChar))
			{
				damagePlayer(1);
			}
		});

		bullets.forEachDead(function(bullet)
		{
			bullets.remove(bullet);
		});

		/**  ****************
		 *   *****PLAYER*****
		 * . ****************
		**/
		if (playerBulletTimer.justPassed())
		{
			switch (playerBulletType)
			{
				case 0:
					playerBullets.add(new Bullet(mainChar.x + 17, mainChar.y + 17, 1001));
			}
		}

		playerBullets.forEachAlive(function(bullet)
		{
			bullet.move();
			if (bullet.overlaps(bossMan))
			{
				bullet.kill();
				damageBoss(1);
			}
		});

		playerBullets.forEachDead(function(bullet)
		{
			playerBullets.remove(bullet);
		});

		super.update(elapsed);
	}

	override function onFocusLost()
	{
		pause();
	}

	function pause()
	{
		openSubState(pauseMenu);
	}

	function backgroundCreate()
	{
		BG1 = new FlxSprite(0, 0).loadGraphic(Paths.getFilePath('images/background/bg7', PNG));
		BG1.setGraphicSize(2000, 1000);
		BG1.screenCenter(XY);
		add(BG1);
		BG2 = new FlxSprite(0, 0).loadGraphic(Paths.getFilePath('images/background/bg2', PNG));
		add(BG2);
		BG22 = new FlxSprite(3200, 0).loadGraphic(Paths.getFilePath('images/background/bg2', PNG));
		add(BG22);
		BG3 = new FlxSprite(0, 120).loadGraphic(Paths.getFilePath('images/background/bg1', PNG));
		add(BG3);
		BG32 = new FlxSprite(3200, 120).loadGraphic(Paths.getFilePath('images/background/bg1', PNG));
		add(BG32);
		BG4 = new FlxSprite(0, 120).loadGraphic(Paths.getFilePath('images/background/bg6', PNG));
		add(BG4);
		BG42 = new FlxSprite(3200, 120).loadGraphic(Paths.getFilePath('images/background/bg6', PNG));
		add(BG42);
		BG5 = new FlxSprite(0, 120).loadGraphic(Paths.getFilePath('images/background/bg5', PNG));
		add(BG5);
		BG52 = new FlxSprite(3200, 120).loadGraphic(Paths.getFilePath('images/background/bg5', PNG));
		add(BG52);
		BG6 = new FlxSprite(0, 120).loadGraphic(Paths.getFilePath('images/background/bg4', PNG));
		add(BG6);
		BG62 = new FlxSprite(3200, 120).loadGraphic(Paths.getFilePath('images/background/bg4', PNG));
		add(BG62);
		BG7 = new FlxSprite(0, 120).loadGraphic(Paths.getFilePath('images/background/bg3', PNG));
		add(BG7);
		BG72 = new FlxSprite(3200, 120).loadGraphic(Paths.getFilePath('images/background/bg3', PNG));
		add(BG72);
	}

	function backgroundUpdate()
	{
		BG2.x -= maxPanning / 32;
		BG3.x -= maxPanning / 16;
		BG4.x -= maxPanning / 8;
		BG5.x -= maxPanning / 4;
		BG6.x -= maxPanning / 2.5;
		BG7.x -= maxPanning / 1.5;
		BG22.x -= maxPanning / 32;
		BG32.x -= maxPanning / 16;
		BG42.x -= maxPanning / 8;
		BG52.x -= maxPanning / 4;
		BG62.x -= maxPanning / 2.5;
		BG72.x -= maxPanning / 1.5;

		if (BG2.x < -3200)
			BG2.x = BG22.x + 3200;
		if (BG22.x < -3200)
			BG22.x = BG2.x + 3200;
		if (BG3.x < -3200)
			BG3.x = BG32.x + 3200;
		if (BG32.x < -3200)
			BG32.x = BG3.x + 3200;
		if (BG4.x < -3200)
			BG4.x = BG42.x + 3200;
		if (BG42.x < -3200)
			BG42.x = BG4.x + 3200;
		if (BG5.x < -3200)
			BG5.x = BG52.x + 3200;
		if (BG52.x < -3200)
			BG52.x = BG5.x + 3200;
		if (BG6.x < -3200)
			BG6.x = BG62.x + 3200;
		if (BG62.x < -3200)
			BG62.x = BG6.x + 3200;
		if (BG7.x < -3200)
			BG7.x = BG72.x + 3200;
		if (BG72.x < -3200)
			BG72.x = BG7.x + 3200;
	}

	function damagePlayer(amount:Int)
	{
		playerHealth -= amount;
		mainChar.playAnim('hurt');
	}

	function damageBoss(amount:Int)
	{
		bossHealth -= amount;
	}

	function movement()
	{
		var walkSpeed:Float = 6;
		var diagWS:Float = 4.24264;
		if (FlxG.keys.anyJustPressed([W, UP, A, S, D, DOWN, RIGHT, LEFT]))
		{
			walkSpeed = 5;
			diagWS = 3.53553;
		}

		walkSpeed += 0.1;
		diagWS += 0.0388909;

		if (walkSpeed > 6)
			walkSpeed = 6;
		if (diagWS > 4.24264)
			diagWS = 4.24264;

		if ((FlxG.keys.pressed.W || FlxG.keys.pressed.UP) && mainChar.y > 0)
		{
			if ((FlxG.keys.pressed.D || FlxG.keys.pressed.RIGHT) && mainChar.x < 1380)
			{
				mainChar.x += diagWS;
				mainChar.y -= diagWS;
			}
			else if ((FlxG.keys.pressed.A || FlxG.keys.pressed.LEFT) && mainChar.x > -20)
			{
				mainChar.x -= diagWS;
				mainChar.y -= diagWS;
			}
			else
			{
				mainChar.y -= walkSpeed;
			}
		}
		else if ((FlxG.keys.pressed.S || FlxG.keys.pressed.DOWN) && mainChar.y < 800)
		{
			if ((FlxG.keys.pressed.D || FlxG.keys.pressed.RIGHT) && mainChar.x < 1380)
			{
				mainChar.x += diagWS;
				mainChar.y += diagWS;
			}
			else if ((FlxG.keys.pressed.A || FlxG.keys.pressed.LEFT) && mainChar.x > -20)
			{
				mainChar.x -= diagWS;
				mainChar.y += diagWS;
			}
			else
			{
				mainChar.y += walkSpeed;
			}
		}
		else if ((FlxG.keys.pressed.D || FlxG.keys.pressed.RIGHT) && mainChar.x < 1380)
		{
			mainChar.x += walkSpeed;
		}
		else if ((FlxG.keys.pressed.A || FlxG.keys.pressed.LEFT) && mainChar.x > -20)
		{
			mainChar.x -= walkSpeed;
		}
	}
}
