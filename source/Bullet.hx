package;

import flixel.FlxSprite;
import towsterFlxUtil.Paths;
import towsterFlxUtil.Sprite;

class Bullet extends Sprite
{
	var tick:Float = 0;

	public var bulletType:String = 'dollar';
	public var someInput:Dynamic;

	public var damage:Float = 1;

	public function new(x:Float, y:Float, bulletType:String, ?someInput:Dynamic = 0)
	{
		this.bulletType = bulletType;
		this.someInput = someInput;

		switch (bulletType)
		{
			case 'dollar':
				super(x, y, 'bullet/dollarBill');
				animation.addByPrefix('idle', 'dollar bill particle0', 24, true);
				playAnim('idle');
				angle = someInput;
				setGraphicSize(50, 50);
				damage = 10;
			case 'moneyBag':
				super(x, y, 'bullet/moneyBag');
				animation.addByPrefix('idle', 'money bag particle0', 24, true);
				playAnim('idle');
				setGraphicSize(100, 100);
				damage = 10;
			case 'coin':
				super(x, y, 'bullet/coin');
				animation.addByPrefix('idle', 'coin particle0', 24, true);
				playAnim('idle');
				setGraphicSize(30, 30);
				damage = 10;
			case 'houseMissile':
				super(x, y);
				loadGraphic(Paths.filePath('bullet/houseMissile', PNG));
				damage = 3;
			case 'diamond':
				super(x, y);
				loadGraphic(Paths.filePath('bullet/diamond', PNG));
				setGraphicSize(60, 60);
				angle = 94;
				damage = 2;
			case 'reverseCard':
				super(x, y, 'bullet/reverse_card_particle');
				animation.addByPrefix('idle', 'reverse card particle0', 24, true);
				playAnim('idle');
				setGraphicSize(35, 35);
			case 'skipCard':
				super(x, y, 'bullet/skip_card_particle');
				animation.addByPrefix('idle', 'skip card particle0', 24, true);
				playAnim('idle');
				setGraphicSize(35, 35);
			case 'plus2Card':
				super(x, y, 'bullet/plus_2_card_particle');
				animation.addByPrefix('idle', 'plus 2 card particle0', 24, true);
				playAnim('idle');
				setGraphicSize(75, 75);
				damage = 2;
			case 'lilLazer':
				super(x, y, 'bullet/red_lazer_particle');
				animation.addByPrefix('idle', 'red lazer particle0', 24, true);
				playAnim('idle');
				damage = 2;
				scale.set(0.5, 0.5);
			case 'longLazer':
				super(x, y, 'bullet/blue_lazer_particle');
				animation.addByPrefix('idle', 'blue lazer particle0', 24, true);
				playAnim('idle');
				scale.set(0.5, 0.5);
			case 'bigLazer':
				super(x, y, 'bullet/green_lazer_particle');
				animation.addByPrefix('idle', 'green lazer particle0', 24, true);
				playAnim('idle');
				scale.set(0.8, 0.8);
			case 'candy':
				super(x, y, 'bullet/candy_particle');
				animation.addByPrefix('idle', 'candy particle0', 24, true);
				playAnim('idle');
				angle = someInput + 180;
				scale.set(0.4, 0.4);
				damage = 0.5;
			case 'spearmint':
				super(x, y, 'bullet/peppermint_particle');
				animation.addByPrefix('idle', 'peppermint particle0', 24, true);
				playAnim('idle');
				scale.set(0.5, 0.5);
				damage = 2;
			case 'gummi':
				super(x, y, 'bullet/gummy_particle');
				animation.addByPrefix('idle', 'gummy particle0', 24, true);
				playAnim('idle');
				scale.set(0.5, 0.5);
				damage = 1;

			default:
				trace("doesn't work with: " + bulletType);
		}
		updateHitbox();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		switch (bulletType)
		{
			case 'dollar':
				moveAtAngle(5, someInput);
				removeIfOffscreen();
			case 'moneyBag':
				if (x > 1650)
					x -= 0;
				else
					x -= someInput;

				if (y < -500)
					kill();
			case 'coin':
				moveAtAngle(12, someInput * 57.3);
				removeIfOffscreen();
			case 'houseMissile':
				damage = 3;
				if (tick > 100)
				{
					y -= (tick - 100) * 2;
				}
				else
				{
					y = 700 - tick / 4;
					damage = 0;
				}
				removeIfOffscreen();
			case 'diamond':
				x -= 13;
				if (x < -300)
					kill();
			case 'reverseCard':
				x += 20;
				removeIfOffscreen();
			case 'skipCard':
				x += 10;
				removeIfOffscreen();
			case 'plus2Card':
				moveAtAngle(10, someInput);
				angle = someInput - 90;
				removeIfOffscreen();
			case 'lilLazer':
				var d = 5;
				switch (someInput)
				{
					case 0:
						y += d;
						angle = 90;
					case 1:
						y -= d;
						angle = -90;
				}
				removeIfOffscreen();
			case 'longLazer':
				x += 10;
				removeIfOffscreen();
			case 'bigLazer':
				x += 5;
				if (tick < 10 || tick > 20)
				{
					alpha = 0.5;
					damage = 0;
				}
				else
				{
					alpha = 1;
					damage = 1;
				}
				removeIfOffscreen();
			case 'candy':
				moveAtAngle(10, someInput);
				if (alpha <= 0)
					kill();
				alpha = 1 - ((tick - 20) / 3);
				removeIfOffscreen();
			case 'gummi':
				var d = 10;
				x += d;
				y += someInput;
				someInput -= 1;
				if (y < -200)
					kill();
			case 'spearmint':
				var d = 10;
				x += d;
				y += someInput;
				someInput += 1;
				if (y > 1000)
					kill();
		}
		tick += elapsed * 10;
	}

	function removeIfOffscreen(?x1 = -20, ?x2 = 1500, ?y1 = -200, ?y2 = 1000)
	{
		if (x > x2 || x < -x1 || y > y2 || y < y1)
		{
			kill();
			return;
		}
	}

	function moveAtAngle(magnitude:Float, angle:Float)
	{
		x += magnitude * Math.sin(angle / 180 * 3.14);
		y += magnitude * Math.cos(angle / 180 * 3.14);
	}
}
