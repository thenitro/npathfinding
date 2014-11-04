package npathfinding.base {
	import ncollections.Set;
	import ncollections.grid.Grid;
	
	
	public final class Pathfinder {
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

        public function get minX():int {
            return _pathgrid.minX;
        };

        public function get minY():int {
            return _pathgrid.minY;
        };

        public function get maxX():int {
            return _pathgrid.maxX;
        };

        public function get maxY():int {
            return _pathgrid.maxY;
        };

		public function init(pX:int, pY:int):void {
			_pathgrid = new Grid();
			
			for (var i:int = 0; i < pX; i++) {
				for (var j:int = 0; j < pY; j++) {
					var node:Node     = new Node();
						node.walkable = true;
						
					_pathgrid.add(i, j, node);
					_freeNodes.add(node);
				}
			}
		};

        public function takeNode(pX:int, pY:int):Node {
            return _pathgrid.take(pX, pY) as Node;
        };
		
		public function isWalkable(pIndexX:int, pIndexY:int):Boolean {
			var node:Node = _pathgrid.take(pIndexX, pIndexY) as Node;
			
			if (!node) {
				return false;
			}
			
			return node.walkable;
		};
		
		public function setWalkable(pIndexX:int, pIndexY:int):void {
			var node:Node = _pathgrid.take(pIndexX, pIndexY) as Node;

            if (!node) {
                node = _pathgrid.add(pIndexX, pIndexY, new Node(true)) as Node;
                return;
            }

            node.walkable = true;
				
			_freeNodes.add(node);
			_closedNodes.remove(node);
		};
		
		public function setUnWalkable(pIndexX:int, pIndexY:int):void {
			var node:Node = _pathgrid.take(pIndexX, pIndexY) as Node;

            if (!node) {
                node = _pathgrid.add(pIndexX, pIndexY, new Node()) as Node;
                return;
            }

            node.walkable = false;
				
			_freeNodes.remove(node);
			_closedNodes.add(node);
		};
		
		public function findPath(pStartX:int, pStartY:int, 
								 pEndX:int, pEndY:int, 
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