package
{
	import flash.display.Sprite;
	
	import la.diversion.AssetViewComponent;
	import la.diversion.LevelViewComponent;
	import la.diversion.PropertyViewComponent;
	
	public class Main extends Sprite
	{
		public function Main()
		{
			super();
			
			var levelComponent:LevelViewComponent = new LevelViewComponent();
			levelComponent.x = 5;
			levelComponent.y = 5;
			this.addChild(levelComponent);
			
			var assetViewComponent:AssetViewComponent = new AssetViewComponent();
			assetViewComponent.x = 770;
			this.addChild(assetViewComponent);
			
			var propertyViewComponent:PropertyViewComponent = new PropertyViewComponent();
			propertyViewComponent.x = 770;
			propertyViewComponent.y = 405;
			this.addChild(propertyViewComponent);
		}
	}
}