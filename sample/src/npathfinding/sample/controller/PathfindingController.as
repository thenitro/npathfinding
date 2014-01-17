package npathfinding.sample.controller {
	import flash.utils.getTimer;
	
	import ngine.display.gridcontainer.GridContainer;
	import ngine.math.Random;
	
	import npathfinding.algos.AStar;
	import npathfinding.algos.JumpPointSearch;
	import npathfinding.base.Heuristic;
	import npathfinding.base.Node;
	import npathfinding.base.Pathfinder;
	import npathfinding.sample.view.VisualNode;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.events.EventDispatcher;
	import starling.events.Touch;
	
	public final class PathfindingController extends EventDispatcher {
		public static const JPS_FINDED:String = 'jps_finded';
		public static const A_FINDED:String   = 'a_finded';
		
		private static var _pathfinder:Pathfinder = Pathfinder.getInstance();
		
		private static var _jps:JumpPointSearch = new JumpPointSearch();
		private static var _a:AStar             = new AStar();
		
		private var _container:GridContainer;
		private var _prevNode:VisualNode;
		
		private var _start:Node;
		private var _end:Node;
		
		private var _path:Vector.<Node>;
		
		public function PathfindingController() {
			super();
		};
		
		public function init(pContainer:GridContainer):void {
			_container = pContainer;
			
			generateStart();
			generateEnd();
		};
		
		public function track(pTouch:Touch):void {
			var indexX:int = (pTouch.globalX / _container.cellWidth);
			var indexY:int = (pTouch.globalY / _container.cellHeight);
			
			if (_prevNode) {
				restoreNode();
			}
			
			var node:VisualNode = _container.take(indexX, indexY) as VisualNode;
			
			if (!node) {
				return;
			}
				node.color = VisualNode.SELECT_COLOR;
			
			_prevNode = node;
		};
		
		public function generateRandomPath():void {
			generateStart();
			generateEnd();
			
			findPath();
		};
		
		public function findPath():void {
			stopPathAnimation();
			
			findA();
			findJPS();
			
			if (!_path) {
				trace("PathfindingController.findPath() elapsed: NO PATH");
				return;
			}
			
			for (var i:int = 0; i < _path.length; i++) {
				var node:Node = _path[i];
				
				if (node == _start || node == _end) {
					continue;
				}
				
				var visual:VisualNode = _container.take(node.indexX, node.indexY) as VisualNode;
					visual.color = 0x0000FF;
					visual.alpha = 0.0;
					
					
				var tween:Tween = new Tween(visual, 1.0);
					tween.delay = i;
					tween.fadeTo(1.0);
					
				Starling.juggler.add(tween);
			}
		};
		
		private function stopPathAnimation():void {
			Starling.juggler.purge();
			
			for each (var node:Node in _path) {
				if (node == _start || node == _end) {
					continue;
				}
				
				var visual:VisualNode = _container.take(node.indexX, node.indexY) as VisualNode;
					visual.alpha = 1.0;
					visual.color = VisualNode.OPEN_COLOR;
			}
			
			_path = null;
		};
		
		private function findJPS():void {
			_pathfinder.algorithm = _jps;
			
			var start:uint = getTimer();
			
			for (var i:int = 0; i < 10; i++) {
				_path = _pathfinder.findPath(_start.indexX, _start.indexY,
															  _end.indexX, _end.indexY, 
															  Heuristic.manhattan);
			}
			
			
			var elapsed:int = (getTimer() - start);
			
			_path = _pathfinder.expandPath(_path);
			
			dispatchEventWith(JPS_FINDED, false, elapsed);
		};
		
		private function findA():void {
			_pathfinder.algorithm = _a;
			
			var start:uint = getTimer();
			for (var i:int = 0; i < 10; i++) {
				var path:Vector.<Node> = _pathfinder.findPath(_start.indexX, _start.indexY,
															  _end.indexX, _end.indexY, 
															  Heuristic.manhattan);
			}
			
			dispatchEventWith(A_FINDED, false, (getTimer() - start));
		};
		
		private function restoreNode():void {
			if (_prevNode.indexX == _start.indexX && 
				_prevNode.indexY == _start.indexY) {
				_prevNode.color = VisualNode.START_COLOR;
				
				return;
			}
			
			if (_prevNode.indexX == _end.indexX && 
				_prevNode.indexY == _end.indexY) {
				_prevNode.color = VisualNode.END_COLOR;
				
				return;
			}
			
			_prevNode.color = _pathfinder.isWalkable(_prevNode.indexX, 
				_prevNode.indexY) ? VisualNode.OPEN_COLOR : VisualNode.CLOSED_COLOR;
			
		};
		
		private function generateStart():void {
			var node:VisualNode;
			
			if (_start) {
				node = _container.take(_start.indexX, _start.indexY) as VisualNode;
				node.color = VisualNode.OPEN_COLOR;
			}
			
			_start = Random.arrayElement(_pathfinder.freeNodes.list) as Node; 
			
			node = _container.take(_start.indexX, _start.indexY) as VisualNode;
			node.color = VisualNode.START_COLOR;
		};
		
		private function generateEnd():void {
			var node:VisualNode;
			
			if (_end) {
				node = _container.take(_end.indexX, _end.indexY) as VisualNode;
				node.color = VisualNode.OPEN_COLOR;
			}
			
			_end = Random.arrayElement(_pathfinder.freeNodes.list) as Node;
			
			node = _container.take(_end.indexX, _end.indexY) as VisualNode;
			node.color = VisualNode.END_COLOR;
		};
	};
}