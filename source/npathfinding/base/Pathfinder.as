package npathfinding.base {
	import ncollections.Set;
	import ncollections.grid.Grid;
	
	
	public final class Pathfinder {
		private static const X:uint = 0;
		private static const Y:uint = 1;
		
		public var algorithm:Algorithm;
		
		private static var _allowInstance:Boolean;
		private static var _instance:Pathfinder;
		
		private var _pathgrid:Grid;
		
		private var _freeNodes:Set;
		private var _closedNodes:Set;
				
		public function Pathfinder() {
			if (!_allowInstance) {
				throw new Error("Pathfinder: class is singleton! " +
					"Use Pathfinder.getInstance() " +
					"instead of using 'new' keyword!");
			}
			
			_freeNodes   = Set.EMPTY;
			_closedNodes = Set.EMPTY;
		};
		
		public static function getInstance():Pathfinder {
			if (!_instance) {
				_allowInstance = true;
				_instance      = new Pathfinder();
				_allowInstance = false;
			}
			
			return _instance;
		};
		
		public function get freeNodes():Set {
			return _freeNodes;
		};
		
		public function get closedNodes():Set {
			return _closedNodes;
		};
		
		public function init(pX:uint, pY:uint):void {
			_pathgrid = new Grid();
			
			for (var i:uint = 0; i < pX; i++) {
				for (var j:uint = 0; j < pY; j++) {
					var node:Node     = new Node();
						node.walkable = true;
						
					_pathgrid.add(i, j, node);
					_freeNodes.add(node);
				}
			}
		};
		
		public function isWalkable(pIndexX:uint, pIndexY:uint):Boolean {
			var node:Node = _pathgrid.take(pIndexX, pIndexY) as Node;
			
			if (!node) {
				return false;
			}
			
			return node.walkable;
		};
		
		public function setWalkable(pIndexX:uint, pIndexY:uint):void {
			var node:Node     = _pathgrid.take(pIndexX, pIndexY) as Node;

            if (!node) {
                return;
            }

            node.walkable = true;
				
			_freeNodes.add(node);
			_closedNodes.remove(node);
		};
		
		public function setUnWalkable(pIndexX:uint, pIndexY:uint):void {
			var node:Node     = _pathgrid.take(pIndexX, pIndexY) as Node;

            if (!node) {
                return;
            }

            node.walkable = false;
				
			_freeNodes.remove(node);
			_closedNodes.add(node);
		};
		
		public function findPath(pStartX:uint, pStartY:uint, 
								 pEndX:uint, pEndY:uint, 
								 pHeuristic:Function = null):Vector.<Node> {
			if (algorithm.findPath(_pathgrid, pHeuristic,
								   _pathgrid.take(pStartX, pStartY) as Node,
								   _pathgrid.take(pEndX, pEndY) as Node)) {
                return algorithm.path;
            }

			return null;
		};
	};
}