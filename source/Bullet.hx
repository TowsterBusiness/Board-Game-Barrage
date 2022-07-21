package;

import flixel.FlxSprite;
import towsterFlxUtil.Paths;
import towsterFlxUtil.Sprite;

class Bullet extends Sprite
{
	var tick = 0;

	public var bulletType:String = 'dollarBill';
	public var someInput:Dynamic;

	public var damage:Int = 1;

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
				setGraphicSize(25, 25);
			case 'skipCard':
				super(x, y, 'bullet/skip_card_particle');
				animation.addByPrefix('idle', 'skip card particle0', 24, true);
				playAnim('idle');
				setGraphicSize(25, 25);
			case 'plus2Card':
				super(x, y, 'bullet/plus_2_card_particle');
				animation.addByPrefix('idle', 'plus 2 card particle0', 24, true);
				playAnim('idle');
				setGraphicSize(75, 75);
				damage = 2;
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
				if (tick > 300)
				{
					y -= (tick - 300) * 2;
					damage = 2;
				}
				else
				{
					damage = 0;
					y = 720 - tick / 4;
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
				moveAtAngle(10, someInput);
				angle = someInput;
				if (alpha <= 0)
					kill();
				alpha = 1 - ((tick - 20) / 10);
				removeIfOffscreen();
			case 'plus2Card':
				moveAtAngle(10, someInput);
				angle = someInput;
				removeIfOffscreen();
		}
		tick++;
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
