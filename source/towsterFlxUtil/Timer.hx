package towsterFlxUtil;

import flixel.FlxBasic;

class Timer extends FlxBasic
{
	public var time:Float = 0;

	var startTime:Float = 0;
	var nextHurdle = 0;
	var betweenMs = 10;

	public function new(ms:Int, ?startTime:Float = 0)
	{
		super();
		this.betweenMs = ms;

		time -= startTime / 1000;

		nextHurdle = ms;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		time += elapsed * 1000;
	}

	public function justPassed()
	{
		if (nextHurdle < time)
		{
			nextHurdle += betweenMs;
			return true;
		}
		return false;
	}
}
