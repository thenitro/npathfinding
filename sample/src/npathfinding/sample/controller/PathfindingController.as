package npathfinding.sample.controller {
	import flash.utils.getTimer;
	
	import ngine.display.gridcontainer.GridContainer;
	import ngine.math.Random;
	
	import npathfinding.Pathfinder;
	import npathfinding.algos.AStar;
	import npathfinding.base.Heuristic;
	import npathfinding.base.Node;
	import npathfinding.sample.view.VisualNode;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.events.EventDispatcher;
	import starling.events.Touch;
	
	public final class PathfindingController extends EventDispatcher {
		private static var _pathfinder:Pathfinder = Pathfinder.getInstance();
		
		private var _container:GridContainer;
		private var _prevNode:VisualNode;
		
		private var _start:Node;
		private var _end:Node;
		
		public function PathfindingController() {
			super();
		};
		
		public function init(pContainer:GridContainer):void {
			_container = pContainer;
			
			generateStart();
			generateEnd();
			
			findPath();
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
			_start = Random.arrayElement(_pathfinder.freeNodes.list) as Node; 
			
			var node:VisualNode = _container.take(_start.indexX, _start.indexY) as VisualNode;
				node.color      = VisualNode.START_COLOR;
		};
		
		private function generateEnd():void {
			_end = Random.arrayElement(_pathfinder.freeNodes.list) as Node;
			
			var node:VisualNode = _container.take(_end.indexX, _end.indexY) as VisualNode;
				node.color      = VisualNode.END_COLOR;
		};
		
		private function findPath():void {
			trace("PathfindingController.findPath()", _start);
			
			var start:uint = getTimer();
			
			var path:Vector.<Node> = _pathfinder.findPath(_start.indexX, _start.indexY,
														  _end.indexX, _end.indexY, 
														  Heuristic.diagonal);
				//path = _pathfinder.expandPath(path);
			
			trace("PathfindingController.findPath() elapsed JPS: " + (getTimer() - start));
			
			start = getTimer();
			
			_pathfinder.algorithm = new AStar();
			
			var path2:Vector.<Node> = _pathfinder.findPath(_start.indexX, _start.indexY,
														  _end.indexX, _end.indexY, 
														  Heuristic.diagonal);
			
			trace("PathfindingController.findPath() elapsed A*: " + (getTimer() - start));
			
			if (!path) {
				trace("PathfindingController.findPath() elapsed: NO PATH");
				return;
			}
			
			for (var i:int = 0; i < path.length; i++) {
				var node:Node = path[i];
				
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
			
			trace("PathfindingController.findPath()", path);
			trace("PathfindingController.findPath()", _end);
		};
	};
}