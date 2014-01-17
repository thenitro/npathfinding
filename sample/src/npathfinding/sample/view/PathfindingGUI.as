package npathfinding.sample.view {
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.ScrollContainer;
	import feathers.layout.VerticalLayout;
	import feathers.themes.MinimalMobileTheme;
	
	import flashx.textLayout.container.ScrollPolicy;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public final class PathfindingGUI extends Sprite {
		public static const RANDOM_PATH:String = 'random_path';
		public static const RECALC_PATH:String = 'recalc_path';
		
		private static const GUI_WIDTH:Number     = 125;
		
		private static const BUTTON_WIDTH:Number  = GUI_WIDTH - 10; 
		private static const BUTTON_HEIGHT:Number = 20; 
		
		private var _jpsLabel:Label;
		private var _aLabel:Label;
		
		public function PathfindingGUI() {
			super();
			addEventListener(Event.ADDED_TO_STAGE, addedToStageEventHandler);
		};
		
		public function jpsFinded(pTime:int):void {
			_jpsLabel.text = "JPS: " + pTime;
		};
		
		public function aFinded(pTime:int):void {
			_aLabel.text = "A*: " + pTime;
		};
		
		private function addedToStageEventHandler(pEvent:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageEventHandler);
			
			new MinimalMobileTheme();
			
			var container:ScrollContainer = new ScrollContainer();
				container.x = stage.stageWidth - GUI_WIDTH;
				
				container.width  = GUI_WIDTH;
				container.height = stage.stageHeight;
				
				container.layout = new VerticalLayout();
				
				container.horizontalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
				
			addChild(container);
			
			var randomPath:Button = new Button();
				
				randomPath.width  = BUTTON_WIDTH;
				randomPath.height = BUTTON_HEIGHT;
			
				randomPath.label  = 'Random path';
				randomPath.addEventListener(Event.TRIGGERED, 
										newPathTriggeredEventHandler);
				
			container.addChild(randomPath);
			
			var label:Label = new Label();
				label.width  = BUTTON_WIDTH;
				label.height = BUTTON_HEIGHT;
				
				label.text = "Working speed";
				
			container.addChild(label);
			
			_jpsLabel = new Label();
			_jpsLabel.width  = BUTTON_WIDTH;
			_jpsLabel.height = BUTTON_HEIGHT;
			container.addChild(_jpsLabel);
			
			_aLabel = new Label();
			_aLabel.width  = BUTTON_WIDTH;
			_aLabel.height = BUTTON_HEIGHT;
			container.addChild(_aLabel);
			
			var button:Button = new Button();
				
				button.width  = BUTTON_WIDTH;
				button.height = BUTTON_HEIGHT;
			
				button.label  = 'Recalc Path';
				button.addEventListener(Event.TRIGGERED, 
										recalcTriggeredEventHandler);
				
			container.addChild(button);
		};
		
		private function newPathTriggeredEventHandler(pEvent:Event):void {
			dispatchEventWith(RANDOM_PATH);
		};
		
		private function recalcTriggeredEventHandler(pEvent:Event):void {
			dispatchEventWith(RECALC_PATH);
		};
	};
}