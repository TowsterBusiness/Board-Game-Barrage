package;

import flixel.FlxSprite;
import towsterFlxUtil.Paths;
import towsterFlxUtil.Sprite;

class Bullet extends Sprite
{
	var tick = 0;

	public var bulletType = 0;
	public var someInput:Dynamic;

	public var damage:Int = 1;

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
				damage = 10;
			case 1:
				super(x, y, 'bullet/moneyBag');
				animation.addByPrefix('idle', 'money bag particle0', 24, true);
				playAnim('idle');
				setGraphicSize(100, 100);
				damage = 10;
			case 2:
				super(x, y, 'bullet/coin');
				animation.addByPrefix('idle', 'coin particle0', 24, true);
				playAnim('idle');
				setGraphicSize(30, 30);
				damage = 10;
			case 3:
				super(x, y);
				loadGraphic(Paths.filePath('bullet/houseMissile', PNG));
				damage = 3;
			case 4:
				super(x, y);
				loadGraphic(Paths.filePath('bullet/diamond', PNG));
				setGraphicSize(60, 60);
				angle = 94;
				damage = 2;
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
				damage = 2;
		}
		updateHitbox();
	}

	var reverseCardDir:Float = 25;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		switch (bulletType)
		{
			case 0:
				moveAtAngle(5, someInput);
				removeIfOffscreen();
			case 1:
				if (tick > 300)
					kill();

				if (x > 1800)
					x -= 0;
				else
					x -= someInput;
			case 2:
				moveAtAngle(12, someInput);
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
				moveAtAngle(10, someInput);
				if (alpha <= 0)
					kill();
				alpha = 1 - ((tick - 100) / 10);
				removeIfOffscreen();
			case 1003:
				moveAtAngle(10, someInput);
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
