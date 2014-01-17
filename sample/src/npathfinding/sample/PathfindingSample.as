package npathfinding.sample {
	import ngine.core.collider.GridCollider;
	import ngine.display.gridcontainer.GridContainer;
	import ngine.math.Random;
	
	import npathfinding.base.Pathfinder;
	import npathfinding.algos.AStar;
	import npathfinding.algos.JumpPointSearch;
	import npathfinding.base.Node;
	import npathfinding.sample.controller.PathfindingController;
	import npathfinding.sample.view.PathfindingGUI;
	import npathfinding.sample.view.VisualNode;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	
	public final class PathfindingSample extends Sprite {
		private static const NUM_X:int = 20;
		private static const NUM_Y:int = 20;
		
		private static const UNWALKABLES_PERCENT:int = 30;
		
		private static var _pathfinder:Pathfinder = Pathfinder.getInstance();
		
		private var _gui:PathfindingGUI;
		private var _container:GridContainer;
		
		private var _controller:PathfindingController;
		
		public function PathfindingSample() {
			super();
			addEventListener(Event.ADDED_TO_STAGE, addedToStageEventHandler);
		};
		
		private function addedToStageEventHandler(pEvent:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageEventHandler);
			
			createGrid();
			
			createPathfinder();
			generateUnwalkables();
			
			createController();
			
			createGUI();
			
			addEventListener(TouchEvent.TOUCH, touchEventHandler);
		};
		
		private function createGUI():void {
			_gui = new PathfindingGUI();
			_gui.addEventListener(PathfindingGUI.RANDOM_PATH, 
								  randomPathEventHandler);
			_gui.addEventListener(PathfindingGUI.RECALC_PATH, 
								  recalcPathEventHandler);
			
			addChild(_gui);
		};
		
		private function createGrid():void {
			_container = new GridContainer(stage.stageWidth / NUM_X, stage.stageHeight / NUM_Y);
			addChild(_container.canvas);
			
			for (var i:int = 0; i < NUM_X; i++) {
				for (var j:int = 0; j < NUM_Y; j++) {
					var node:VisualNode = new VisualNode(_container.cellWidth, 
														 _container.cellHeight);
						node.color = VisualNode.OPEN_COLOR;
					
					_container.add(i, j, node);
					_container.addVisual(node);
				}
			}
		};
		
		private function createPathfinder():void {
			_pathfinder.init(NUM_X, NUM_Y);
		};
		
		private function generateUnwalkables():void {
			for (var i:int = 0; i < NUM_X; i++) {
				for (var j:int = 0; j < NUM_Y; j++) {
					if (Random.probability(UNWALKABLES_PERCENT)) {
						_pathfinder.setUnWalkable(i, j);
						
						var node:VisualNode = _container.take(i, j) as VisualNode;
							node.color = VisualNode.CLOSED_COLOR;
					}					
				}
			}
		};
		
		private function createController():void {
			_controller = new PathfindingController();
			_controller.init(_container);
			_controller.addEventListener(PathfindingController.JPS_FINDED, 
										 jpsFindedEventHandler);
			_controller.addEventListener(PathfindingController.A_FINDED, 
										 aFindedEventHandler);
		};
		
		private function touchEventHandler(pEvent:TouchEvent):void {
			_controller.track(pEvent.touches[0]);
		};
		
		private function randomPathEventHandler(pEvent:Event):void {
			_controller.generateRandomPath();
		};
		
		private function recalcPathEventHandler(pEvent:Event):void {
			_controller.findPath();
		};
		
		private function jpsFindedEventHandler(pEvent:Event):void {
			_gui.jpsFinded(pEvent.data as int);
		};
		
		private function aFindedEventHandler(pEvent:Event):void {
			_gui.aFinded(pEvent.data as int);
		};
	};
}