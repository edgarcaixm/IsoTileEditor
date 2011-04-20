package la.diversion
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class AssetViewComponent extends Sprite
	{
		public function AssetViewComponent()
		{
			super();
			
			this.graphics.lineStyle(3,0x00ff00);
			this.graphics.beginFill(0x0000FF);
			this.graphics.drawRect(0,0,430,400);
			this.graphics.endFill();
			
			var txt:TextField = new TextField();
			txt.width = 400;
			txt.x = 10;
			txt.y = 10;
			txt.defaultTextFormat = new TextFormat(null, 24, 0xFFFFFF, true);
			txt.text = "Yarrr! Asset View Goes Here";
			this.addChild(txt);
		}
	}
}