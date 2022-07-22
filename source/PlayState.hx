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
	var mtnManager:MtnBGManager;

	var hardMode:Bool = false;
	var isShooting:Bool = false;

	var pauseMenu:PauseSubState;

	var mainChar:Sprite;

	var bossMan:Sprite;
	var bossMaxHealth:Int = 200;
	var nextDiceHealth:Int = 0;
	var bossHealth:Float = 200;
	var bulletTimer:towsterFlxUtil.Timer;
	var bullets:FlxTypedSpriteGroup<Bullet>;

	var dice:Sprite;
	var diceAnimation:Sprite;
	var lilDiceSprite:Sprite;

	var onAttacks:Array<Bool> = [false, false, false, false, false];
	// 0 = cat & terry
	var playerType:Int = 2;
	var reverseCardDir:Float = 25;

	// 1001 = basic Bullet
	// 1001 = reverse Bullet
	var playerBulletType:Int = -1;
	var playerBulletTimer:Float;
	var playerBullets:FlxTypedSpriteGroup<Bullet>;
	var playerHealth:Float = 99;

	var cashOffset:Int = 0;
	var bulletOffset:Int = 0;
	var randomDiamondY:Float = 0;

	var winScreen:FlxSprite;

	var shootSound:FlxSound;
	var bigShootSound:FlxSound;
	var diceRollSound:FlxSound;

	var healthBar:FlxSprite;

	var hitbox:FlxSprite;

	override public function create()
	{
		FlxG.sound.playMusic('assets/music/BOARD_BLASTIN_-_BATTLE.ogg', 0.5, true);

		shootSound = FlxG.sound.load('assets/music/Basic_Shooter.ogg', 0.3, false);
		bigShootSound = FlxG.sound.load('assets/music/Power_Shooter.ogg', 0.3, false);
		diceRollSound = FlxG.sound.load('assets/music/dice_roll_sfx.ogg', 0.3, false);

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

		mtnManager = new MtnBGManager(30);
		add(mtnManager);

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

		hitbox = new FlxSprite(mainChar.x, mainChar.y).loadGraphic(Paths.filePath('hitbox', PNG));
		hitbox.setGraphicSize(40, 40);
		hitbox.updateHitbox();
		hitbox.x = mainChar.x + mainChar.width / 2 - hitbox.width / 2;
		hitbox.y = mainChar.y + mainChar.height / 2 - hitbox.height / 2;
		add(hitbox);
		FlxTween.tween(hitbox, {alpha: 0}, 1, {ease: FlxEase.cubeOut, startDelay: 2});

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
		add(bulletTimer);

		healthBar = new FlxSprite(-76, 19);
		healthBar.frames = Paths.getAnimation('healthBar/hp_bar' + playerType);
		healthBar.scale.set(0.8, 0.8);
		for (i in 0...101)
		{
			healthBar.animation.addByIndices(i + '', 'healthBar0', [99 - i], '', 24, true);
		}
		healthBar.animation.play('100');
		add(healthBar);

		winScreen = new FlxSprite(-200, -1400).loadGraphic(Paths.filePath('winScreen/win' + playerType, PNG));
		winScreen.scale.set(0.5, 0.5);
		add(winScreen);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		movement();

		playerBulletTimer += elapsed * 1000;

		if (bossHealth < 0 && (FlxG.mouse.justPressed || FlxG.keys.justPressed.ENTER))
		{
			FlxTween.tween(FlxG.camera, {alpha: 0}, 1.5, {
				ease: FlxEase.sineIn,
				onComplete: (x) ->
				{
					FlxG.switchState(new TitleState());
				}
			});
		}

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

		bossBulletShit();
		playerBulletShit();

		if (bossHealth <= bossMaxHealth - nextDiceHealth)
			spawnDice();

		if (dice.overlaps(mainChar) && dice.alpha == 1)
		{
			FlxTween.tween(dice, {alpha: 0}, 1, {ease: FlxEase.quadIn});
			diceRoll();
		}

		if (diceAnimation.animation.finished && diceAnimation.animation.curAnim.name == 'drop')
		{
			var avalableAttacks = [];
			for (i in 0...5)
			{
				if (!onAttacks[i])
					avalableAttacks.push(i);
			}
			var rand = avalableAttacks[Math.floor(Math.random() * avalableAttacks.length)];
			diceAnimation.playAnim('' + rand);
			onAttacks[rand] = true;
			playerBulletType = (rand) % 3;
			if (rand == 2)
			{
				bullets.add(new Bullet(Math.random() * 1280, 900, 'houseMissile'));
			}
			diceRollSound.stop();
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

		// ;

		super.update(elapsed);
	}

	function spawnDice()
	{
		playerBulletType = -1;
		nextDiceHealth += 40;
		FlxTween.tween(dice, {alpha: 1}, 1);
	}

	function diceRoll()
	{
		diceRollSound.play();
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

	function gameOver()
	{
		if (bossMan.animation.curAnim.name == 'dead')
			return;
		mainChar.playAnim('dead');
		var GO:GameOverSubState = new GameOverSubState();
		openSubState(GO);
	}

	function winState()
	{
		bossMan.playAnim('dead');
		FlxTween.tween(bullets, {y: -720}, 3, {ease: FlxEase.quartOut});
		FlxTween.tween(winScreen, {y: -380}, 1.5, {ease: FlxEase.backOut});
		FlxTween.tween(FlxG.sound, {volume: 0}, 1, {
			onComplete: (x) ->
			{
				FlxG.sound.playMusic('assets/music/BOARD_BLASTIN_-_VICTORY.ogg', 0.5, true);
				FlxTween.tween(FlxG.sound, {volume: 1}, 1);
			}
		});
		bossHealth = -1;
	}

	function damagePlayer(amount:Float)
	{
		playerHealth -= amount;
		if (playerHealth >= 0)
		{
			healthBar.animation.play(playerHealth + '');
			mainChar.playAnim('hurt');
		}
		else
		{
			gameOver();
		}
	}

	function damageBoss(amount:Float)
	{
		if (amount == 0)
			return;
		bossHealth -= amount;
		bossMan.playAnim('hurt');
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
			hitbox.x += veloX;
			hitbox.y += veloY;
			mainChar.x += veloX;
			mainChar.y += veloY;
		}

		mainChar.angle = veloX / maxWS * 25;
	}

	override function onFocusLost()
	{
		pause();
	}

	function pause()
	{
		openSubState(pauseMenu);
	}

	function playerBulletShit()
	{
		if (isShooting)
		{
			bulletOffset++;
			switch (playerType)
			{
				case 0:
					switch (playerBulletType)
					{
						case 0:
							if (playerBulletTimer < 500)
								return;
							playerBullets.add(new Bullet(mainChar.x + mainChar.width / 2, mainChar.y + mainChar.height / 2, 'longLazer'));
							playerBulletTimer = 0;
						case 1:
							if (playerBulletTimer < 1000)
								return;
							playerBullets.add(new Bullet(mainChar.x, mainChar.y, 'bigLazer'));
							playerBulletTimer = 0;
						case 2:
							if (playerBulletTimer < 3000)
								return;
							FlxTween.tween(mainChar, {alpha: 0.5}, 1, {
								onComplete: (x) ->
								{
									shootSound.play();
									playerBullets.add(new Bullet(mainChar.x + mainChar.width / 2, mainChar.y + mainChar.height / 2, 'lilLazer', 0));
									playerBullets.add(new Bullet(mainChar.x + mainChar.width / 2, mainChar.y + mainChar.height / 2, 'lilLazer', 1));
									FlxTween.tween(mainChar, {alpha: 1}, 1);
								}
							});
							playerBulletTimer = 0;
					}
				case 1:
					switch (playerBulletType)
					{
						case 0:
							if (playerBulletTimer < 500)
								return;
							shootSound.play();
							playerBullets.add(new Bullet(mainChar.x + mainChar.width / 2, mainChar.y + mainChar.height / 2, 'reverseCard'));

							playerBulletTimer = 0;
						case 1:
							if (playerBulletTimer < 1000)
								return;
							shootSound.play();
							playerBullets.add(new Bullet(mainChar.x + mainChar.width / 2, mainChar.y + mainChar.height / 2, 'skipCard', reverseCardDir));
							mainChar.x = Math.random() * 900;
							mainChar.y = Math.random() * 650;
							mainChar.alpha = 0.5;
							FlxTween.tween(mainChar, {alpha: 1}, 1);
							playerBulletTimer = 0;
						case 2:
							if (playerBulletTimer < 1000)
								return;
							bigShootSound.play();
							playerBullets.add(new Bullet(mainChar.x + mainChar.width / 2, mainChar.y + mainChar.height / 2, 'plus2Card', reverseCardDir));
							playerBulletTimer = 0;
					}
				case 2:
					switch (playerBulletType)
					{
						case 0:
							if (playerBulletTimer < 500)
								return;
							shootSound.play();
							playerBullets.add(new Bullet(mainChar.x + mainChar.width / 2, mainChar.y + mainChar.height / 2, 'candy', 110));
							playerBullets.add(new Bullet(mainChar.x + mainChar.width / 2, mainChar.y + mainChar.height / 2, 'candy', 70));
							playerBulletTimer = 0;
						case 1:
							if (playerBulletTimer < 2000)
								return;
							playerBullets.add(new Bullet(mainChar.x + mainChar.width / 2, mainChar.y + mainChar.height / 2, 'spearmint', -10));
							hitbox.alpha = 1;
							hitbox.setGraphicSize(80, 80);
							playerBulletTimer = 0;
						case 2:
							if (playerBulletTimer < 1000)
								return;
							playerBullets.add(new Bullet(mainChar.x + mainChar.width / 2, mainChar.y + mainChar.height / 2, 'gummi', Math.random() * 20 + 5));
							playerBulletTimer = 0;
					}
			}
		}

		playerBullets.forEachAlive(function(bullet)
		{
			if (bullet.overlaps(bossMan))
			{
				reverseCardDir = Math.random() * 70 - 270 - 35;

				if (bullet.bulletType == 'reverseCard')
				{
					for (i in 0...6)
					{
						bullets.add(new Bullet(bossMan.x + 25, bossMan.y + 140, 'dollar', i * 72 + Math.random() * 100));
					}
				}

				if (bullet.bulletType == 'spearmint')
				{
					hitbox.alpha = 0;
					hitbox.setGraphicSize(40, 40);
				}

				bullet.kill();
				damageBoss(bullet.damage);
			}
		});

		playerBullets.forEachDead(function(bullet)
		{
			playerBullets.remove(bullet);
		});
	}

	function bossBulletShit()
	{
		bullets.forEachAlive(function(bullet)
		{
			if (bullet.overlaps(hitbox) && mainChar.alpha == 1)
			{
				if (bullet.bulletType != 'houseMissile')
					bullet.kill();
				damagePlayer(bullet.damage);
			}
		});

		bullets.forEachDead(function(bullet)
		{
			bullets.remove(bullet);
		});
		if (!bulletTimer.justPassed())
			return;
		cashOffset += 5;
		for (atlen in 0...onAttacks.length)
		{
			if (onAttacks[atlen])
			{
				switch (atlen)
				{
					case 0:
						if (cashOffset % 10 == 0)
						{
							bullets.add(new Bullet(1400, Math.random() * 850 + 25, 'moneyBag', Math.random() * 10 + 5));
						}
					case 1:
						if (cashOffset % 10 == 0)
						{
							for (i in 0...5)
							{
								bullets.add(new Bullet(bossMan.x + 25, bossMan.y + 140, 'dollar', i * 72 + cashOffset));
							}
						}
					case 2:
						if (cashOffset % 50 == 0)
						{
							bullets.add(new Bullet(Math.random() * 1100, 900, 'houseMissile'));
						}
					case 3:
						if (cashOffset % 10 == 0)
						{
							bullets.add(new Bullet(bossMan.x + 25, bossMan.y + 140, 'coin',
								Math.atan2(hitbox.x - bossMan.x + 25.0, hitbox.y - bossMan.y + 140.0) - 0.35));
						}
					case 4:
						if (cashOffset % 20 == 0)
						{
							randomDiamondY = Math.random() * 900 + 30;
							for (i in 2...10)
							{
								bullets.add(new Bullet(i * 70 + 1280, randomDiamondY, 'diamond'));
							}
						}
				}
			}
		}
	}
}
