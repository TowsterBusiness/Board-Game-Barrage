package;

import flixel.system.FlxSound;
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
	var bossHealth:Int = 100;
	var playerHealth:Int = 1000;
	var bulletTimer:towsterFlxUtil.Timer;
	var bullets:FlxTypedSpriteGroup<Bullet>;

	var dice:Sprite;
	var diceAnimation:Sprite;

	var bulletType:Int = 0;
	// 0 = cat & terry
	var playerType:Int = 2;
	var reverseCardDir:Float = 25;

	// 1001 = basic Bullet
	// 1001 = reverse Bullet
	var playerBulletType:Int = -1;
	var playerBulletTimer:towsterFlxUtil.Timer;
	var playerBullets:FlxTypedSpriteGroup<Bullet>;

	var cashOffset:Int = 0;
	var bulletOffset:Int = 0;
	var randomDiamondY:Float = 0;

	var onAttacks:Array<Bool> = [false, false, false, false, false];

	var winScreen:FlxSprite;

	var shootSound:FlxSound;
	var bigShootSound:FlxSound;

	var healthBar:FlxSprite;

	override public function create()
	{
		FlxG.camera.bgColor = 0xFFE382;
		backgroundCreate();

		FlxG.sound.playMusic('assets/music/BOARD_BLASTIN_-_BATTLE.ogg', 0.5, true);

		shootSound = FlxG.sound.load('assets/music/Basic_Shooter.ogg', 0.3, false);
		bigShootSound = FlxG.sound.load('assets/music/Power_Shooter.ogg', 0.3, false);
		FlxG.autoPause = false;
		destroySubStates = false;
		pauseMenu = new PauseSubState(0xB7676767);

		FlxG.camera.alpha = 0;
		FlxTween.tween(FlxG.camera, {alpha: 1}, 1, {
			ease: FlxEase.sineIn,
			onComplete: (x) -> {
				//
			}
		});

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
			case 2:
				mainChar = new Sprite(100, 0, 'characters/lolli');
				mainChar.animation.addByPrefix('idle', 'lolli idle0', 24);
				mainChar.animation.addByPrefix('attack', 'lolli attack0', 24, false);
				mainChar.animation.addByPrefix('dead', 'lolli dead0', 24);
				mainChar.animation.addByPrefix('hurt', 'lolli hurt0', 24, false);
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

		dice = new Sprite(700, 0, 'bullet/dice_particle');
		dice.animation.addByPrefix('idle', 'dice particle0', 24, true);
		dice.playAnim('idle');
		dice.screenCenter(Y);
		add(dice);

		bossMan = new Sprite(1000, 300, 'characters/monopolyMan');
		bossMan.animation.addByPrefix('idle', 'monopoly man idle0', 24);
		bossMan.animation.addByPrefix('attack', 'monopoly man attack0', 24, false);
		bossMan.animation.addByPrefix('dead', 'monopoly man dead0', 24);
		bossMan.animation.addByPrefix('hurt', 'monopoly man hurt0', 24, false);

		bossMan.addOffset('idle', 200, 130);
		bossMan.addOffset('attack', 200, 130);
		bossMan.addOffset('dead', 200, 150);
		bossMan.addOffset('hurt', 200, 130);

		bossMan.scale.set(0.5, 0.5);
		bossMan.updateHitbox();
		// bossMan.getHitbox = new Rect
		bossMan.screenCenter(Y);
		add(bossMan);
		bossMan.playAnim('idle');

		diceAnimation = new Sprite(1250, -60, 'bullet/dice');
		diceAnimation.scale.set(0.5, 0.5);
		diceAnimation.animation.addByPrefix('mid-air', 'dice drop no text0', 24, false);
		diceAnimation.animation.addByPrefix('drop', 'dice roll0', 24, false);
		diceAnimation.animation.addByPrefix('0', 'dice result 10', 24, false);
		diceAnimation.animation.addByPrefix('1', 'dice result 20', 24, false);
		diceAnimation.animation.addByPrefix('2', 'dice result 30', 24, false);
		diceAnimation.animation.addByPrefix('3', 'dice result 40', 24, false);
		diceAnimation.animation.addByPrefix('4', 'dice result 50', 24, false);
		diceAnimation.animation.addByPrefix('5', 'dice result 60', 24, false);
		diceAnimation.updateHitbox();
		diceAnimation.playAnim('mid-air');
		add(diceAnimation);

		bulletTimer = new towsterFlxUtil.Timer(400);
		playerBulletTimer = new towsterFlxUtil.Timer(200);

		// winScreen = new FlxSprite(0, -768).loadGraphic(Paths.getFilePath('images/winScreen/winscreen' + playerType, PNG));
		// winScreen.setGraphicSize(1024, 768);
		// add(winScreen);

		healthBar = new FlxSprite(0, 0).loadGraphic(Paths.getFilePath('hp_bar' + playerType, PNG));

		super.create();
	}

	override public function update(elapsed:Float)
	{
		movement();
		backgroundUpdate();

		trace(healthBar.x + ' ' + healthBar.y);

		if (FlxG.keys.justPressed.P)
			pause();

		isShooting = FlxG.keys.checkStatus(SPACE, PRESSED);

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

		if (bossMan.animation.finished)
		{
			bossMan.playAnim('idle');
		}

		bulletTimer.timer += elapsed;
		playerBulletTimer.timer += elapsed;

		bossBulletShit();
		playerBulletShit();

		if (bossHealth % Math.floor(200) == 0)
			spawnDice();

		if (dice.overlaps(mainChar) && dice.alpha == 1)
		{
			FlxTween.tween(dice, {alpha: 0}, 1, {ease: FlxEase.quadIn});
			diceRoll();
		}

		if (diceAnimation.animation.finished && diceAnimation.animation.curAnim.name == 'drop')
		{
			var avalableAttacks = [];
			for (i in 0...6)
			{
				if (!onAttacks[i])
					avalableAttacks.push(i);
			}
			var rand = avalableAttacks[Math.floor(Math.random() * avalableAttacks.length)];
			diceAnimation.playAnim('' + rand);
			onAttacks[rand] = true;
			playerBulletType = rand % 3;
		}

		if (FlxG.keys.justPressed.COMMA)
		{
			spawnDice();
		}
		if (FlxG.keys.justPressed.SEMICOLON)
		{
			gameOver();
		}
		if (FlxG.keys.justPressed.PERIOD)
		{
			winState();
		}

		super.update(elapsed);
	}

	function spawnDice()
	{
		playerBulletType = -1;
		bossHealth--;
		FlxTween.tween(dice, {alpha: 1}, 1);
	}

	function gameOver()
	{
		mainChar.playAnim('dead');
	}

	function winState() {}

	function damagePlayer(amount:Int)
	{
		playerHealth -= amount;
		mainChar.playAnim('hurt');
	}

	function damageBoss(amount:Int)
	{
		bossHealth -= amount;
		bossMan.playAnim('hurt');
	}

	function diceRoll()
	{
		FlxTween.tween(diceAnimation, {x: 975}, 0.5, {
			ease: FlxEase.quadIn,
			onComplete: (x) ->
			{
				diceAnimation.playAnim('drop');
				FlxTween.tween(diceAnimation, {x: 1250}, 0.5, {
					ease: FlxEase.quadOut,
					startDelay: 3,
					onComplete: (y) ->
					{
						diceAnimation.playAnim('mid-air');
					}
				});
			}
		});
	}

	var veloX:Float;
	var veloY:Float;

	function movement()
	{
		var walkSpeed:Float = 2;
		var maxWS:Float = 6;

		var friction:Float = 1.5;
		veloX /= friction;
		veloY /= friction;

		if ((FlxG.keys.anyPressed([W, UP])) && mainChar.y > -20)
			veloY -= walkSpeed;
		if ((FlxG.keys.anyPressed([D, RIGHT])) && mainChar.x < 1240)
			veloX += walkSpeed;

		if ((FlxG.keys.anyPressed([A, LEFT])) && mainChar.x > -20)
			veloX -= walkSpeed;
		if ((FlxG.keys.anyPressed([S, DOWN])) && mainChar.y < 680)
			veloY += walkSpeed;

		if (veloX > maxWS)
			veloX = maxWS;
		if (veloY > maxWS)
			veloY = maxWS;

		if (FlxG.keys.anyJustPressed([W, UP, S, DOWN]) && FlxG.keys.anyJustPressed([A, RIGHT, D, LEFT]))
		{
			mainChar.x += Math.sin(3.14 / 180 * 45) * veloX;
			mainChar.y += Math.sin(3.14 / 180 * 45) * veloY;
		}
		else
		{
			mainChar.x += veloX;
			mainChar.y += veloY;
		}

		mainChar.angle = veloX / maxWS * 25;
	}

	override function onFocusLost()
	{
		pause();
	}

	function loseBullets() {}

	function pause()
	{
		openSubState(pauseMenu);
	}

	function backgroundCreate()
	{
		BG1 = new FlxSprite(0, 0).loadGraphic(Paths.getFilePath('images/background/bg7', PNG));
		BG1.setGraphicSize(2000, 2000);
		BG1.screenCenter(XY);
		add(BG1);
		BG2 = new FlxSprite(0, 0).loadGraphic(Paths.getFilePath('images/background/bg2', PNG));
		add(BG2);
		BG22 = new FlxSprite(3200, 0).loadGraphic(Paths.getFilePath('images/background/bg2', PNG));
		add(BG22);
		BG3 = new FlxSprite(0, 120).loadGraphic(Paths.getFilePath('images/background/bg1', PNG));
		add(BG3);
		BG32 = new FlxSprite(3200, 0).loadGraphic(Paths.getFilePath('images/background/bg1', PNG));
		add(BG32);
		BG4 = new FlxSprite(0, 0).loadGraphic(Paths.getFilePath('images/background/bg6', PNG));
		add(BG4);
		BG42 = new FlxSprite(3200, 0).loadGraphic(Paths.getFilePath('images/background/bg6', PNG));
		add(BG42);
		BG5 = new FlxSprite(0, 120).loadGraphic(Paths.getFilePath('images/background/bg5', PNG));
		add(BG5);
		BG52 = new FlxSprite(3200, 0).loadGraphic(Paths.getFilePath('images/background/bg5', PNG));
		add(BG52);
		BG6 = new FlxSprite(0, 0).loadGraphic(Paths.getFilePath('images/background/bg4', PNG));
		add(BG6);
		BG62 = new FlxSprite(3200, 0).loadGraphic(Paths.getFilePath('images/background/bg4', PNG));
		add(BG62);
		BG7 = new FlxSprite(0, 0).loadGraphic(Paths.getFilePath('images/background/bg3', PNG));
		add(BG7);
		BG72 = new FlxSprite(3200, 0).loadGraphic(Paths.getFilePath('images/background/bg3', PNG));
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

	function playerBulletShit()
	{
		if (playerBulletTimer.justPassed() && isShooting)
		{
			switch (playerBulletType)
			{
				case 0:
					shootSound.play();
					playerBullets.add(new Bullet(mainChar.x + 17, mainChar.y + 17, 1001));
				case 1:
					shootSound.play();
					playerBullets.add(new Bullet(mainChar.x + 17, mainChar.y + 17, 1002, 1));
					playerBullets.add(new Bullet(mainChar.x + 17, mainChar.y + 17, 1002, 2));
					playerBullets.add(new Bullet(mainChar.x + 17, mainChar.y + 17, 1002, 3));
				case 2:
					bigShootSound.play();
					if (bulletOffset % 4 == 0)
						playerBullets.add(new Bullet(mainChar.x + 17, mainChar.y + 17, 1003, reverseCardDir));
					bulletOffset++;
			}
		}

		playerBullets.forEachAlive(function(bullet)
		{
			bullet.move();
			if (bullet.overlaps(bossMan))
			{
				reverseCardDir = Math.random() * 70 - 270 - 35;

				bullet.kill();
				damageBoss(1);
			}
		});

		playerBullets.forEachDead(function(bullet)
		{
			playerBullets.remove(bullet);
		});
	}

	function bossBulletShit()
	{
		if (bulletTimer.justPassed())
		{
			cashOffset += 10;
			for (atlen in 0...onAttacks.length)
			{
				if (onAttacks[atlen])
				{
					switch (atlen)
					{
						case 1:
							for (i in 0...6)
							{
								bullets.add(new Bullet(bossMan.x + 25, bossMan.y + 140, 0, i * 72 + cashOffset));
							}
						case 0:
							bullets.add(new Bullet(1400, Math.random() * 850 + 25, 1, Math.random() * 10 + 5));
						case 2:
							if (cashOffset % 100 == 0)
							{
								bullets.add(new Bullet(Math.random() * 1280, 900, 3));
							}
						case 3:
							if (cashOffset % 20 == 0)
							{
								bullets.add(new Bullet(bossMan.x + 25, bossMan.y + 140, 2,
									Math.atan2(mainChar.x - bossMan.x + 25.0, mainChar.y - bossMan.y + 140.0) - 0.32));
							}
						case 4:
							if (cashOffset % 40 == 0)
							{
								randomDiamondY = Math.random() * 900 + 30;
								for (i in 2...10)
								{
									bullets.add(new Bullet(i * 70 + 1280, randomDiamondY, 4));
								}
							}
					}
				}
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
	}
}
