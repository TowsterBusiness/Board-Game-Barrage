package;

import towsterFlxUtil.*;

class TitleCharacters extends Sprite
{
	var speed:Int;
	// right = true
	// left = false
	var direction:Bool = true;

	/***
	 * Character Id's
	 * lolli, wilson, cat&terry
	**/
	public function new(characterId:String)
	{
		super(0, 0);
		switch (characterId)
		{
			case 'lolli':
				frames = Paths.getAnimation('characters/cat_and_terry');
				animation.addByPrefix('idle', 'cat and terry idle0', 24);
				addOffset('idle', 130, 65);
			case 'cat&terry':
				frames = Paths.getAnimation('characters/lolli');
				animation.addByPrefix('idle', 'lolli idle0', 24);
				addOffset('idle', 80, 65);
			case 'wilson':
				frames = Paths.getAnimation('characters/wilson_wildcard');
				animation.addByPrefix('idle', 'wilson idle0', 24);
				addOffset('idle', 80, 65);
		}
		playAnim('idle');
		scale.set(0.5, 0.5);
		angle = 20;

		y = Math.random() * 600 + 60;
		x = -1000;
		speed = Math.floor(Math.random() * 10 + 5);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		x += speed;

		if (x > 2000 && direction)
		{
			direction = !direction;
			flipX = true;
			y = Math.random() * 600 + 60;
			speed = -Math.floor(Math.random() * 10 + 5);
			angle = speed * 1.5;
		}
		else if (x < -700 && !direction)
		{
			direction = !direction;
			flipX = false;
			y = Math.random() * 600 + 60;
			speed = Math.floor(Math.random() * 10 + 5);
			angle = speed * 1.5;
		}
	}
}
