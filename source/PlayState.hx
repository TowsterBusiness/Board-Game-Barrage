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

	var pauseMenu:PauseSubState;

	var mainChar:FlxSprite;

	var bossMan:FlxSprite;
	var bossHealth:Int = 1000;
	var playerHealth:Int = 1000;

	// 0 = basic Bullet
	// 1 = spread shot
	var bulletType:Int = 0;
	var bulletTimer:towsterFlxUtil.Timer;
	var bullets:FlxTypedSpriteGroup<Bullet>;

	var playerBulletType:Int = 0;
	var playerBulletTimer:towsterFlxUtil.Timer;
	var playerBullets:FlxTypedSpriteGroup<Bullet>;

	var cashOffset:Int = 0;

	override public function create()
	{
		backgroundCreate();

		destroySubStates = false;
		pauseMenu = new PauseSubState(0xB7676767);

		playerBullets = new FlxTypedSpriteGroup(0, 0, 9999);
		add(playerBullets);

		mainChar = new FlxSprite(0, 0).loadGraphic(Paths.getFilePath('images/white-circle.png'));
		mainChar.setGraphicSize(50, 50);
		mainChar.updateHitbox();
		add(mainChar);

		bullets = new FlxTypedSpriteGroup(0, 0, 9999);
		add(bullets);

		bossMan = new FlxSprite(1000, 300).loadGraphic(Paths.getFilePath('images/white-circle.png'));
		bossMan.setGraphicSize(100, 100);
		bossMan.updateHitbox();
		bossMan.screenCenter(Y);
		add(bossMan);

		bulletTimer = new towsterFlxUtil.Timer(400);
		playerBulletTimer = new towsterFlxUtil.Timer(100);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		movement();

		backgroundUpdate();

		if (FlxG.keys.justPressed.P)
			openSubState(pauseMenu);

		if (bulletTimer.justPassed())
		{
			if (bulletType < 3)
			{
				cashOffset += 3;
				for (i in 0...11)
				{
					bullets.add(new Bullet(bossMan.x + 25, bossMan.y + 25, 0, i * 36 + cashOffset));
				}

				bullets.add(new Bullet(1400, Math.random() * 850 + 25, 1, Math.random() * 10 + 5));
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
				damageBoss(1);
			}
		});

		playerBullets.forEachDead(function(bullet)
		{
			playerBullets.remove(bullet);
		});

		super.update(elapsed);
	}

	function backgroundCreate()
	{
		BG1 = new FlxSprite(0, 0).loadGraphic(Paths.getFilePath('images/background/bg7', PNG));
		BG1.setGraphicSize(1300, 1000);
		BG1.screenCenter(XY);
		add(BG1);
		BG2 = new FlxSprite(0, 0).loadGraphic(Paths.getFilePath('images/background/bg2', PNG));
		add(BG2);
		BG22 = new FlxSprite(3200, 0).loadGraphic(Paths.getFilePath('images/background/bg2', PNG));
		add(BG22);
		BG3 = new FlxSprite(0, 0).loadGraphic(Paths.getFilePath('images/background/bg1', PNG));
		add(BG3);
		BG32 = new FlxSprite(3200, 60).loadGraphic(Paths.getFilePath('images/background/bg1', PNG));
		add(BG32);
		BG4 = new FlxSprite(0, 60).loadGraphic(Paths.getFilePath('images/background/bg6', PNG));
		add(BG4);
		BG42 = new FlxSprite(3200, 60).loadGraphic(Paths.getFilePath('images/background/bg6', PNG));
		add(BG42);
		BG5 = new FlxSprite(0, 60).loadGraphic(Paths.getFilePath('images/background/bg5', PNG));
		add(BG5);
		BG52 = new FlxSprite(3200, 60).loadGraphic(Paths.getFilePath('images/background/bg5', PNG));
		add(BG52);
		BG6 = new FlxSprite(0, 60).loadGraphic(Paths.getFilePath('images/background/bg4', PNG));
		add(BG6);
		BG62 = new FlxSprite(3200, 60).loadGraphic(Paths.getFilePath('images/background/bg4', PNG));
		add(BG62);
		BG7 = new FlxSprite(0, 60).loadGraphic(Paths.getFilePath('images/background/bg3', PNG));
		add(BG7);
		BG72 = new FlxSprite(3200, 60).loadGraphic(Paths.getFilePath('images/background/bg3', PNG));
		add(BG72);
	}

	function backgroundUpdate()
	{
		BG2.x -= 1;
		BG3.x -= 2;
		BG4.x -= 5;
		BG5.x -= 10;
		BG6.x -= 15;
		BG7.x -= 20;
		BG22.x -= 1;
		BG32.x -= 2;
		BG42.x -= 5;
		BG52.x -= 10;
		BG62.x -= 15;
		BG72.x -= 20;

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
		FlxTween.tween(mainChar, {alpha: 0.5}, 0.5, {
			ease: FlxEase.quadIn,
			onComplete: (x) ->
			{
				FlxTween.tween(mainChar, {alpha: 1}, 0.5, {
					ease: FlxEase.quadOut
				});
			}
		});
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
			if ((FlxG.keys.pressed.D || FlxG.keys.pressed.RIGHT) && mainChar.x < 1240)
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
			if ((FlxG.keys.pressed.D || FlxG.keys.pressed.RIGHT) && mainChar.x < 1240)
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
		else if ((FlxG.keys.pressed.D || FlxG.keys.pressed.RIGHT) && mainChar.x < 1240)
		{
			mainChar.x += walkSpeed;
		}
		else if ((FlxG.keys.pressed.A || FlxG.keys.pressed.LEFT) && mainChar.x > -20)
		{
			mainChar.x -= walkSpeed;
		}
	}
}
