package;

import towsterFlxUtil.Paths;
import flixel.system.FlxSound;
import flixel.util.FlxTimer;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
#if windows
import Sys;
import sys.FileSystem;
#end
#if windowss
import Discord.DiscordClient;
#end

using StringTools;

class Credits extends FlxState
{
	var panelBottom:FlxSprite;
	var panelTop:FlxSprite;
	var panelMiddle:FlxSprite;
	var arrowLeft:FlxSprite;
	var arrowRight:FlxSprite;
	var creditsText:FlxSprite;

	var creditsPage1:FlxTypedGroup<CreditIcon>;
	var textPage1:FlxTypedGroup<FlxSprite>;

	var curPage:Int = 0;

	var canDoStuff:Bool = false;

	override function create()
	{
		super.create();
		FlxG.camera.zoom = 0.8;

		FlxG.mouse.visible = true;

		panelMiddle = new FlxSprite().loadGraphic(Paths.getFilePath("images/credits/panelMiddle.png"));
		panelMiddle.antialiasing = true;
		panelMiddle.alpha = 0;
		add(panelMiddle);

		panelBottom = new FlxSprite(0, 500).loadGraphic(Paths.getFilePath("images/credits/panelBottom.png"));
		panelBottom.antialiasing = true;
		add(panelBottom);

		panelTop = new FlxSprite(0, -500).loadGraphic(Paths.getFilePath("images/credits/panelTop.png"));
		panelTop.antialiasing = true;
		add(panelTop);

		creditsPage1 = new FlxTypedGroup<CreditIcon>();
		add(creditsPage1);

		textPage1 = new FlxTypedGroup<FlxSprite>();
		add(textPage1);

		creditsText = new FlxSprite(502, 1005).loadGraphic(Paths.getFilePath("images/credits/creditsText.png"));
		creditsText.antialiasing = true;
		add(creditsText);

		var twitterLinks = [
			'https://twitter.com/pieroshiki',
			'https://twitter.com/maku_dynamite13',
			'https://twitter.com/_maplerobin_',
			'https://twitter.com/lz_luaazs',
			'https://www.youtube.com/channel/UCgfJjMiNGlI7uZu1cVag5NA',
			'https://www.youtube.com/channel/UCeQWT9cATBr4ofogZODGmyw',
			'https://twitter.com/Towster_'
		];

		var creditNames = ['Pierogii', 'Nopieal', 'Maple', 'Lua', 'Nightmare', 'Jay', 'Towster'];

		for (i in 0...12)
		{
			var icon:CreditIcon = new CreditIcon(55 + (i % 3) * 400, 128 + (Math.floor(i / 3) * 122), creditNames[i], twitterLinks[i]);
			var text:FlxSprite = new FlxSprite(164 + (i % 3) * 400,
				141 + (Math.floor(i / 3) * 119)).loadGraphic(Paths.getFilePath('images/credits/text/credit' + creditNames[i], PNG));
			icon.x += FlxG.width * 2;
			text.x += FlxG.width * 2;
			icon.scale.set(0.8, 0.8);
			text.scale.set(0.8, 0.8);
			icon.antialiasing = true;
			text.antialiasing = true;
			creditsPage1.add(icon);
			textPage1.add(text);
		}

		FlxTween.tween(FlxG.camera, {zoom: 1.05}, 1.2, {
			ease: FlxEase.cubeOut,
			onComplete: function(twn:FlxTween)
			{
				FlxTween.tween(FlxG.camera, {zoom: 1}, 0.2, {
					ease: FlxEase.quadIn
				});
			}
		});

		FlxTween.tween(arrowLeft, {y: 593}, 1, {
			ease: FlxEase.quadOut,
			startDelay: 1.2,
		});

		FlxTween.tween(creditsText, {y: 605}, 1, {
			ease: FlxEase.quadOut,
			startDelay: 1.3,
		});

		FlxTween.tween(arrowRight, {y: 593}, 1, {
			ease: FlxEase.quadOut,
			startDelay: 1.4,
		});

		FlxTween.tween(panelTop, {y: 0}, 1, {
			ease: FlxEase.quadOut,
			// startDelay: 0.6,
		});

		FlxTween.tween(panelBottom, {y: 0}, 1, {
			ease: FlxEase.quadOut,
			// startDelay: 0.6,
		});

		FlxTween.tween(panelMiddle, {alpha: 1}, 1.4, {
			ease: FlxEase.cubeOut,
			// startDelay: 0.6,
		});

		for (i in creditsPage1)
		{
			FlxTween.tween(i, {x: i.x - FlxG.width}, 0.6, {
				ease: FlxEase.cubeOut,
			});
		}

		for (i in textPage1)
		{
			FlxTween.tween(i, {x: i.x - FlxG.width}, 0.6, {
				ease: FlxEase.cubeOut,
			});
		}
		new FlxTimer().start(0.6, function(tmr:FlxTimer)
		{
			for (i in 0...7)
			{
				FlxTween.tween(creditsPage1.members[i], {x: creditsPage1.members[i].x - FlxG.width}, 1.4, {
					ease: FlxEase.cubeOut,
					startDelay: 0.1,
				});

				FlxTween.tween(textPage1.members[i], {x: textPage1.members[i].x - FlxG.width}, 1.4, {
					ease: FlxEase.cubeOut,
					startDelay: 0.1,
					onComplete: function(twn:FlxTween)
					{
						canDoStuff = true;
					}
				});
			}
		});
	}

	override function update(elapsed:Float)
	{
		for (i in creditsPage1)
		{
			if (FlxG.mouse.overlaps(i))
			{
				i.scale.set(1.1, 1.1);
				if (FlxG.mouse.justPressed)
				{
					FlxG.openURL(i.link);
				}
			}
			else
			{
				i.scale.set(1, 1);
			}
		}
	}

	function changePage(change:Int = 0):Void
	{
		canDoStuff = false;
		var prevPage = curPage;
		curPage += change;
		if (curPage < 0)
		{
			curPage = 0;
			canDoStuff = true;
		}
		else if (curPage > 1)
		{
			curPage = 2;
			canDoStuff = true;
		}
		if (prevPage != curPage)
		{
			for (i in creditsPage1)
			{
				FlxTween.tween(i, {x: i.x + FlxG.width * -change}, 1, {
					ease: FlxEase.quadOut,
				});
			}
			for (i in textPage1)
			{
				FlxTween.tween(i, {x: i.x + FlxG.width * -change}, 1, {
					ease: FlxEase.quadOut,
					onComplete: function(twn:FlxTween)
					{
						canDoStuff = true;
					},
				});
			}
		}
	}

	function outTransition():Void
	{
		canDoStuff = false;
		FlxTween.tween(arrowLeft, {y: 973}, 1, {
			ease: FlxEase.quadOut,
		});

		FlxTween.tween(creditsText, {y: 1005}, 1, {
			ease: FlxEase.quadOut,
			startDelay: 0.1,
		});

		FlxTween.tween(arrowRight, {y: 973}, 1, {
			ease: FlxEase.quadOut,
			startDelay: 0.2,
		});

		FlxTween.tween(panelTop, {y: -500}, 1, {
			ease: FlxEase.quadOut,
		});

		FlxTween.tween(panelBottom, {y: 500}, 1, {
			ease: FlxEase.quadOut,
		});

		FlxTween.tween(panelMiddle, {alpha: 0}, 1, {
			ease: FlxEase.cubeOut,
			startDelay: 0.6,
			onComplete: function(twn:FlxTween)
			{
				// FlxG.switchState(new MainMenuState());
				trace('fix this');
			}
		});

		FlxTween.tween(FlxG.camera, {zoom: 0.8}, 0.6, {startDelay: 0.6});

		var imFuckingDumb:Int = 0;
		var dumb2:Int = 0;
		var dumb3:Int = 0;
		switch (curPage)
		{
			case 0:
				dumb3 = 24;
				imFuckingDumb = 12;
			case 1:
				dumb3 = 37;
				dumb2 = 12;
				imFuckingDumb = 24;
			case 2:
				dumb2 = 24;
				imFuckingDumb = 37;
		}
		// sorry :(
		for (i in creditsPage1)
			i.alpha = 0;
		for (i in textPage1)
			i.alpha = 0;
	}
}
