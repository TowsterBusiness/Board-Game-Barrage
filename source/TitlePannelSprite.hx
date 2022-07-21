package;

import flixel.FlxSprite;

class TitlePannelSprite extends FlxSprite
{
	public function new(id:String)
	{
		super(0, 0);
		switch (id)
		{
			case 'credits':
			case 'tutorial':
		}
	}
}
