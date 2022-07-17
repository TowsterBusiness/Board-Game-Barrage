package;

import flixel.FlxSprite;
import towsterFlxUtil.Paths;
import towsterFlxUtil.Sprite;

class Bullet extends Sprite
{
	var tick = 0;

	public var bulletType = 0;
	public var someInput:Dynamic;

	public function new(x:Float, y:Float, bulletType:Int, ?someInput:Dynamic = 0)
	{
		this.bulletType = bulletType;
		this.someInput = someInput;

		switch (bulletType)
		{
			case 0:
				super(x, y, 'bullet/dollarBill');
				animation.addByPrefix('idle', 'dollar bill particle0', 24, true);
				playAnim('idle');
				angle = someInput;
				setGraphicSize(50, 50);
			case 1:
				super(x, y, 'bullet/moneyBag');
				animation.addByPrefix('idle', 'money bag particle0', 24, true);
				playAnim('idle');
				setGraphicSize(100, 100);
			case 2:
				super(x, y, 'bullet/coin');
				animation.addByPrefix('idle', 'coin particle0', 24, true);
				playAnim('idle');
				setGraphicSize(30, 30);
			case 3:
				super(x, y);
				loadGraphic(Paths.getFilePath('images/bullet/houseMissile.png'));

			case 4:
				super(x, y);
				loadGraphic(Paths.getFilePath('images/bullet/diamond.png'));
				setGraphicSize(60, 60);
				angle = 94;
			case 1001:
				super(x, y, 'bullet/plus_2_card_particle');
				animation.addByPrefix('idle', 'plus 2 card particle0', 24, true);
				playAnim('idle');
				setGraphicSize(25, 25);
			case 1002:
				super(x, y, 'bullet/skip_card_particle');
				animation.addByPrefix('idle', 'skip card particle0', 24, true);
				playAnim('idle');
				setGraphicSize(25, 25);
			case 1003:
				super(x, y, 'bullet/reverse_card_particle');
				animation.addByPrefix('idle', 'reverse card particle0', 24, true);
				playAnim('idle');
				setGraphicSize(75, 75);
		}
		updateHitbox();
	}

	var reverseCardDir:Float = 25;

	public function move(?moveInput:Dynamic)
	{
		tick++;
		switch (bulletType)
		{
			case 0:
				var d = 5; // distance

				x += d * Math.sin(someInput / 180 * 3.14);
				y += d * Math.cos(someInput / 180 * 3.14);
				removeIfOffscreen();
			case 1:
				if (tick > 300)
					kill();

				if (x > 1800)
					x -= 0;
				else
					x -= someInput;
			case 2:
				var d = 12; // distance
				x += d * Math.sin(someInput);
				y += d * Math.cos(someInput);
				if (y < -500)
					kill();
			case 3:
				if (tick > 300)
					y -= (tick - 300) * 2;
				else
					y = 720 - tick / 4;
				removeIfOffscreen();
			case 4:
				x -= 13;
				if (x < -300)
					kill();
			case 1001:
				x += 20;
				removeIfOffscreen();
			case 1002:
				x -= 10;

				if (alpha <= 0)
					kill();
				if (tick > 20)
					alpha = 1 - (tick / 30) + 0.2;
				if (x < 0)
					x = 1280;
			case 1003:
				var d = 10; // distance

				x += d * Math.sin(someInput / 180 * 3.14);
				y += d * Math.cos(someInput / 180 * 3.14);
		}
	}

	function removeIfOffscreen()
	{
		if (x > 1500 || x < -200 || y > 1000 || y < -200)
		{
			kill();
			return;
		}
	}
}
