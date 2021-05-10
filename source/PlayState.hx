package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.math.FlxAngle;
import objects.Line;

class PlayState extends FlxState
{
	var x1:Float = FlxG.width / 2;
	var y1:Float = FlxG.height / 2;
	var line:Line = new Line();
	var line2:Line = new Line();

	override public function create()
	{
		super.create();
		add(line);
		add(line2);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		arm();
	}

	function arm()
	{
		// *-----l1----*-----l2-----* <-- lenght of bone1 (l1) and bone2 (l2)
		//    p1 -----  p2 --- p3
		// shoulder - elbow - arm ---> target

		// bones length
		var l1 = 150;
		var l2 = l1;
		// the anchor point
		var p1x = x1;
		var p1y = y1;
		// the mouse point
		var targetx = FlxG.mouse.screenX;
		var targety = FlxG.mouse.screenY;

		// get the distance betwwen p1 - target, constrain base on limb length
		var p1TargetDist = Math.min(Math.round(pointDistance(p1x, p1y, targetx, targety) + (l1 / 12)), l1 + l2);

		// get the angle betwwen p1 - target
		var p1TargetDir = Math.round(pointDirection(targetx, targety, p1x, p1y));

		// get the hand joint point
		var p3x = p1x - p1TargetDist * Math.cos(FlxAngle.asRadians(p1TargetDir - 90));
		var p3y = p1y + p1TargetDist * Math.sin(FlxAngle.asRadians(p1TargetDir - 90));

		// get the distance betwwen p1 - p3
		var p1p3Dist = Math.round(pointDistance(p3x, p3y, p1x, p1y));
		var phi = Math.acos((p1p3Dist * p1p3Dist - l1 * l1 - l2 * l2) / -(2 * l1 * l2));
		var omega = Math.asin(l2 * Math.sin(phi) / p1p3Dist);

		// get the angle betwwen p1 - p3
		var p1p3Dir = Math.round(pointDirection(p3x, p3y, p1x, p1y));
		// get the angle betwwen p1 - p2
		var p1p2Dir = p1p3Dir - FlxAngle.asDegrees(omega);

		// get the elbow joint point
		var p2x = p1x - l1 * Math.cos(FlxAngle.asRadians(p1p2Dir - 90));
		var p2y = p1y + l1 * Math.sin(FlxAngle.asRadians(p1p2Dir - 90));

		// draw it!
		line.drawIt(p1x, p1y, p2x, p2y);
		line2.drawIt(p2x, p2y, p3x, p3y);

		// extra angles for later use
		// shouler angle
		var p1p3Dir = p1p3Dist - FlxAngle.asDegrees(omega);
		// elbow angle
		var p2p3Dir = p1p3Dir + FlxAngle.asDegrees(phi);
		var theta = Math.PI - phi;
	}

	// extra math

	/**
	 * Calculate the distance between point [x1][y1] and [x2][y2]
	 * @param x1 
	 * @param y1 
	 * @param x2 
	 * @param y2 
	 * @return Float
	 */
	function pointDistance(x1:Float, y1:Float, x2:Float, y2:Float):Float
	{
		return Math.sqrt(Math.pow(y2 - y1, 2) + Math.pow(x2 - x1, 2));
	}

	/**Calculate the angle of the line that contains the points [x1][y1] and [x2][y2]
	 * [Description]
	 * @param x1 
	 * @param y1 
	 * @param x2 
	 * @param y2 
	 * @return Float
	 */
	function pointDirection(x1:Float, y1:Float, x2:Float, y2:Float):Float
	{
		return FlxAngle.asDegrees(Math.atan2(x2 - x1, y2 - y1));
	}
}
