package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.math.FlxAngle;
import flixel.math.FlxMath;
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
		//		A
		//		|\
		//		| \ b
		//		|  \
		//		|   \
		//	   c|   / C
		//		|  /
		//		| / a
		//		|/
		//		B

		// A-----b----C-----a-----B <-- lenght of bone1 (b) and bone2 (a)
		// a: the distance between C and B
		// b: the distance between A and C
		// c: the distance between A and B

		// bones length
		var b = 120;
		var a = 120;
		// the anchor point
		var Ax = x1;
		var Ay = y1;
		// the mouse point
		var targetx = FlxG.mouse.screenX;
		var targety = FlxG.mouse.screenY;

		// the distance between point A and B
		var c = Math.min(Math.round(FlxMath.vectorLength(Ax - targetx, Ay - targety) + (b / 12)), a + b);

		// The angle of A
		var alpha = Math.round(FlxAngle.asDegrees(Math.atan2(targety - Ay, targetx - Ax)));

		// The position of point B
		var Bx = Ax + c * Math.cos(FlxAngle.asRadians(alpha));
		var By = Ay + c * Math.sin(FlxAngle.asRadians(alpha));

		// The angle of point C
		var beta = FlxAngle.asDegrees(Math.acos(Math.min(1, Math.max(-1, b * b + c * c - a * a) / (2 * b * c))));
		var gama = alpha - beta;

		// The position of point C
		var Cx = Ax + b * Math.cos(FlxAngle.asRadians(gama));
		var Cy = Ay + b * Math.sin(FlxAngle.asRadians(gama));

		// draw it!
		line.drawIt(Ax, Ay, Cx, Cy);
		line2.drawIt(Cx, Cy, Bx, By);
	}
}
