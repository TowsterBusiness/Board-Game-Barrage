package;

import towsterFlxUtil.Paths;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

class MtnBGLayer extends FlxTypedSpriteGroup<FlxSprite>
{
	var speed:Float;

	public function new(layerNum:Int, speed:Float)
	{
		super(0, 0, 2);
		this.speed = speed;
		add(new FlxSprite(0, 0).loadGraphic(Paths.filePath('background/bg' + layerNum, PNG)));
		add(new FlxSprite(3200, 0).loadGraphic(Paths.filePath('background/bg' + layerNum, PNG)));
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		forEachAlive((mt) ->
		{
			mt.x -= speed;
			if (mt.x < -3200)
				mt.x += 6400;
		});
	}
}
