package npathfinding.base {
	import flash.errors.IllegalOperationError;
	
	import ncollections.grid.Grid;
	
	
	public class Algorithm {
		public static const DEFAULT_STRAIGHT_COST:Number = 1.0;
		public static const DEFAULT_DIAGONAL_COST:Number = 1.0;//Math.SQRT2;
		
		public var straightCost:Number = DEFAULT_STRAIGHT_COST;
		public var diagonalCost:Number = DEFAULT_DIAGONAL_COST;
		
		public var isDiagonal:Boolean = true;
		
		protected var _path:Vector.<Node>;
		
		protected var _heuristic:Function;
		
		protected var _grid:Grid;
		
		protected var _start:Node;
		protected var _end:Node;
		
		public function Algorithm() {
			
		};
		
		public function get path():Vector.<Node> {
			return _path;
		};
		
		public function get reducedPath():Boolean {
			throw new IllegalOperationError(this + ".reducedPath: Must be overriden!");
			return false;
		};
		
		public function findPath(pPathGrid:Grid, pHeuristic:Function,
								 pStart:Node, pEnd:Node):Boolean {
			throw new IllegalOperationError(this + '.findPath: Must be overriden!');
			return false;
		};
		
		protected function buildPath():void {
			_path = new Vector.<Node>();
			
			var node:Node = _end;
			
			_path.push(node);
			
			while (node != _start) {
				node = node.parent;
				
				_path.unshift(node);
			}
		};
	};
}