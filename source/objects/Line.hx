package objects;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

using flixel.util.FlxSpriteUtil;

class Line extends FlxSprite
{
	private var x1:Float;
	private var y1:Float;
	private var x2:Float;
	private var y2:Float;

	var lineStyle:LineStyle = {color: FlxColor.WHITE, thickness: 5};
	var drawStyle:DrawStyle = {smoothing: true};

	public function new()
	{
		super(0, 0, null);

		var color:FlxColor = FlxColor.TRANSPARENT;
		makeGraphic(FlxG.width, FlxG.height, color, true);
	}

	public function drawIt(_x1, _y1, _x2, _y2)
	{
		x1 = _x1;
		y1 = _y1;
		x2 = _x2;
		y2 = _y2;
		this.fill(FlxColor.TRANSPARENT);

		this.drawLine(x1, y1, x2, y2, lineStyle, drawStyle);
	}
}
