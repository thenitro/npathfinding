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
				node.walkable = true;
				
			_freeNodes.add(node);
			_closedNodes.remove(node);
		};
		
		public function setUnWalkable(pIndexX:uint, pIndexY:uint):void {
			var node:Node     = _pathgrid.take(pIndexX, pIndexY) as Node;
				node.walkable = false;
				
			_freeNodes.remove(node);
			_closedNodes.add(node);
		};
		
		public function findPath(pStartX:uint, pStartY:uint, 
								 pEndX:uint, pEndY:uint, 
								 pHeuristic:Function = null):Vector.<Node> {
			algorithm.findPath(_pathgrid, pHeuristic, 
								 _pathgrid.take(pStartX, pStartY) as Node, 
								 _pathgrid.take(pEndX, pEndY) as Node);
			return algorithm.path;
		};
		
		public function expandPath(pPath:Vector.<Node>):Vector.<Node> {
			if (!pPath) {
				return null;
			}
			
			var result:Vector.<Node> = new Vector.<Node>();
			
			if (pPath.length < 2) {
				return pPath;
			}
			
			for (var i:int = 0; i < pPath.length - 1; i++) {
				var nodeA:Node = pPath[i];
				var nodeB:Node = pPath[i + 1];
				
				var interpolated:Vector.<Node> = interpolate(nodeA, nodeB);
				
				for (var j:int = 0; j < interpolated.length - 1; j++) {
					result.push(interpolated[j]);
				}
			}
			
			result.push(pPath[pPath.length - 1]);
			
			return result;
		};
		
		private function interpolate(pA:Node, pB:Node):Vector.<Node> {
			var result:Vector.<Node> = new Vector.<Node>();
			
			var dx:int = Math.abs(pB.indexX - pA.indexX);
			var dy:int = Math.abs(pB.indexY - pA.indexY);
			
			var sx:int = (pA.indexX < pB.indexX) ? 1 : -1; 
			var sy:int = (pA.indexY < pB.indexY) ? 1 : -1;
			
			var err:int = dx - dy;
			
			var newX:int = pA.indexX;
			var newY:int = pA.indexY;
			
			while(true) {
				result.push(_pathgrid.take(newX, newY));
				
				if (newX == pB.indexX && newY == pB.indexY) {
					break;
				}
				
				var e2:Number = 2 * err;
				
				if (e2 > -dy) {
					err  = err  - dy;
					newX = newX + sx;
				}
				
				if (e2 < dx) {
					err  = err  + dx;
					newY = newY + sy;
				}
			}
			
			return result;
		};
	};
}