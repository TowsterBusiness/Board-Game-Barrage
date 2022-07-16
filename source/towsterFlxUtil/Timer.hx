package towsterFlxUtil;

class Timer
{
	var startTime:Float = 0;
	var lastCheckedTime = 0;
	var betweenMs = 10;

	public function new(ms:Int)
	{
		this.betweenMs = ms;

		startTime = haxe.Timer.stamp() * 1000;
	}

	public function justPassed()
	{
		if ((lastCheckedTime + betweenMs) < haxe.Timer.stamp() * 1000 - startTime)
		{
			lastCheckedTime = Math.floor((haxe.Timer.stamp() * 1000 - startTime) + betweenMs);
			return true;
		}
		return false;
	}
}
