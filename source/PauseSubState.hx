package;

import flixel.FlxG;
import flixel.FlxSubState;

class PauseSubState extends FlxSubState
{
	override public function create():Void
	{
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.P)
			close();
	}
}
