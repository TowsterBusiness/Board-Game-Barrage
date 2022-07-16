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
			case 1001:
				super(x, y, 'bullet/dollarBill');
				animation.addByPrefix('idle', 'dollar bill particle0', 24, true);
				playAnim('idle');
				setGraphicSize(25, 25);
		}
		updateHitbox();
	}

	public function move()
	{
		tick++;
		switch (bulletType)
		{
			case 0:
				var d = 5; // distance

				x += d * Math.sin(someInput);
				y += d * Math.cos(someInput);
				removeIfOffscreen();
			case 1:
				if (tick > 300)
					kill();
				x -= someInput;
			case 1001:
				x += 20;
				removeIfOffscreen();
		}
	}

	function removeIfOffscreen()
	{
		if (x > 1280 || x < -100 || y > 920 || y < -100)
		{
			kill();
			return;
		}
	}
}
