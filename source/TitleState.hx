package;

import towsterFlxUtil.Paths;
import flixel.FlxState;
import flixel.FlxSprite;

class TitleState extends FlxState
{
	var BG1:FlxSprite;
	var BG2:FlxSprite;
	var BG3:FlxSprite;
	var BG4:FlxSprite;
	var BG5:FlxSprite;
	var BG6:FlxSprite;
	var BG7:FlxSprite;
	var BG22:FlxSprite;
	var BG32:FlxSprite;
	var BG42:FlxSprite;
	var BG52:FlxSprite;
	var BG62:FlxSprite;
	var BG72:FlxSprite;

	var playButton:BruhButton;
	var creditsButton:BruhButton;

	var maxPanning:Int = 20;

	public override function create()
	{
		super.create();
		backgroundCreate();

		playButton = new BruhButton(0, 200, Paths.getFilePath('images/titleScreen/playb2', PNG), Paths.getFilePath('images/titleScreen/playb1', PNG), 0.4);
		creditsButton = new BruhButton(300, 200, Paths.getFilePath('images/titleScreen/creditsb2', PNG),
			Paths.getFilePath('images/titleScreen/creditsb1', PNG), 0.4);

		playButton.screenCenter(X);
		creditsButton.screenCenter(X);

		add(playButton);
		add(creditsButton);
	}

	public override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (playButton.updateButton()) {}
		if (creditsButton.updateButton()) {}

		backgroundUpdate();
	}

	function backgroundCreate()
	{
		BG1 = new FlxSprite(0, 0).loadGraphic(Paths.getFilePath('images/background/bg7', PNG));
		BG1.setGraphicSize(2000, 1000);
		BG1.screenCenter(XY);
		add(BG1);
		BG2 = new FlxSprite(0, 0).loadGraphic(Paths.getFilePath('images/background/bg2', PNG));
		add(BG2);
		BG22 = new FlxSprite(3200, 0).loadGraphic(Paths.getFilePath('images/background/bg2', PNG));
		add(BG22);
		BG3 = new FlxSprite(0, 120).loadGraphic(Paths.getFilePath('images/background/bg1', PNG));
		add(BG3);
		BG32 = new FlxSprite(3200, 120).loadGraphic(Paths.getFilePath('images/background/bg1', PNG));
		add(BG32);
		BG4 = new FlxSprite(0, 120).loadGraphic(Paths.getFilePath('images/background/bg6', PNG));
		add(BG4);
		BG42 = new FlxSprite(3200, 120).loadGraphic(Paths.getFilePath('images/background/bg6', PNG));
		add(BG42);
		BG5 = new FlxSprite(0, 120).loadGraphic(Paths.getFilePath('images/background/bg5', PNG));
		add(BG5);
		BG52 = new FlxSprite(3200, 120).loadGraphic(Paths.getFilePath('images/background/bg5', PNG));
		add(BG52);
		BG6 = new FlxSprite(0, 120).loadGraphic(Paths.getFilePath('images/background/bg4', PNG));
		add(BG6);
		BG62 = new FlxSprite(3200, 120).loadGraphic(Paths.getFilePath('images/background/bg4', PNG));
		add(BG62);
		BG7 = new FlxSprite(0, 120).loadGraphic(Paths.getFilePath('images/background/bg3', PNG));
		add(BG7);
		BG72 = new FlxSprite(3200, 120).loadGraphic(Paths.getFilePath('images/background/bg3', PNG));
		add(BG72);
	}

	function backgroundUpdate()
	{
		BG2.x -= maxPanning / 32;
		BG3.x -= maxPanning / 16;
		BG4.x -= maxPanning / 8;
		BG5.x -= maxPanning / 4;
		BG6.x -= maxPanning / 2.5;
		BG7.x -= maxPanning / 1.5;
		BG22.x -= maxPanning / 32;
		BG32.x -= maxPanning / 16;
		BG42.x -= maxPanning / 8;
		BG52.x -= maxPanning / 4;
		BG62.x -= maxPanning / 2.5;
		BG72.x -= maxPanning / 1.5;

		if (BG2.x < -3200)
			BG2.x = BG22.x + 3200;
		if (BG22.x < -3200)
			BG22.x = BG2.x + 3200;
		if (BG3.x < -3200)
			BG3.x = BG32.x + 3200;
		if (BG32.x < -3200)
			BG32.x = BG3.x + 3200;
		if (BG4.x < -3200)
			BG4.x = BG42.x + 3200;
		if (BG42.x < -3200)
			BG42.x = BG4.x + 3200;
		if (BG5.x < -3200)
			BG5.x = BG52.x + 3200;
		if (BG52.x < -3200)
			BG52.x = BG5.x + 3200;
		if (BG6.x < -3200)
			BG6.x = BG62.x + 3200;
		if (BG62.x < -3200)
			BG62.x = BG6.x + 3200;
		if (BG7.x < -3200)
			BG7.x = BG72.x + 3200;
		if (BG72.x < -3200)
			BG72.x = BG7.x + 3200;
	}
}