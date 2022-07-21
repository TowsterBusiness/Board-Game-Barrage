package;

import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

class MtnBGManager extends FlxTypedSpriteGroup<MtnBGLayer>
{
	var layerNum:Int = 7;

	public function new(maxSpeed:Float)
	{
		super(0, 0);
		for (index in 0...layerNum)
			add(new MtnBGLayer(layerNum - index, maxSpeed / Math.pow(2, index)));
	}
}
