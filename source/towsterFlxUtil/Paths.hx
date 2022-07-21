package towsterFlxUtil;

import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.system.FlxAssets.FlxGraphicAsset;
import haxe.Json;
import openfl.utils.Assets as FileSystem;

enum FileTypes
{
	PNG;
	JSON;
	MP4;
	MP3;
	OGG;
	TXT;
	XML;
}

class Paths
{
	/**
	 * This is for spritesheet animations
	 * @param path 
	 * @return FlxAtlasFrames
	 */
	static public function getAnimation(path:String):FlxAtlasFrames
	{
		return FlxAtlasFrames.fromSparrow(filePath(path, PNG), filePath(path, XML));
	}

	/** 
	 * @param path don't add assets/
	 * @param fileType
	 * @return Dynamic Path:String, text:String, json:Json, sounds:Sound, xml:Xml
	 */
	static public function getFile(_filePath:String, fileType:FileTypes):Dynamic
	{
		var path = filePath(_filePath, fileType);
		switch (fileType)
		{
			case JSON:
				return Json.parse(FileSystem.getText(path));
			case MP3:
				return FileSystem.getSound(path);
			case OGG:
				return FileSystem.getSound(path);
			case TXT:
				return FileSystem.getText(path);
			case XML:
				return Xml.parse(FileSystem.getText(path));
			default:
				trace("Yeah no I'm not doing " + fileTypeToString(fileType) + ' rn.');
		}
		trace('Oh No! Something Went Wrong! - Trying to get a file');
		return '';
	}

	/**
	 * ex. input as:
	 * `filePath('data/dog-picture', PNG);`
	 * @param filePath don't add assets/
	 * @param fileType 
	 * @return String
	 */
	static public function filePath(filePath:String, ?fileType:FileTypes):String
	{
		if (fileType == null)
		{
			return 'assets/' + filePath;
		}

		var prefix:String = '';
		switch (fileType)
		{
			case PNG:
				prefix = 'images';
			case XML:
				prefix = 'images';
			case JSON:
				prefix = 'data';
			case TXT:
				prefix = 'data';
			case OGG:
			case MP4:
			case MP3:
		}

		return 'assets/' + prefix + '/' + filePath + '.' + fileTypeToString(fileType);
	}

	private static function fileTypeToString(fileType:FileTypes):String
	{
		switch (fileType)
		{
			case PNG:
				return 'png';
			case JSON:
				return 'json';
			case MP4:
				return 'mp4';
			case MP3:
				return 'mp3';
			case OGG:
				return 'ogg';
			case TXT:
				return 'txt';
			case XML:
				return 'xml';
		}
		trace('Oh No! Something Went Wrong! - Getting a fileTypes to a string');
		return '';
	}
}
