package towsterFlxUtil;

class Timer
{
	public var timer:Float = 0;

	var startTime:Float = 0;
	var lastCheckedTime = 0;
	var betweenMs = 10;

	public function new(ms:Int, ?startTime:Float)
	{
		this.betweenMs = ms;

		timer -= startTime / 1000;

		startTime = timer * 1000;
	}

	public function justPassed()
	{
		if ((lastCheckedTime + betweenMs) < timer * 1000 - startTime)
		{
			lastCheckedTime = Math.floor((timer * 1000 - startTime) + betweenMs);
			return true;
		}
		return false;
	}
}
