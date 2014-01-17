package npathfinding.algos {
	import flash.utils.Dictionary;
	
	import ncollections.grid.Grid;
	
	import npathfinding.base.Algorithm;
	import npathfinding.base.Node;
	
	public final class AStar extends Algorithm {
		private var _open:Array;
		
		public function AStar() {
			_open = [];
		};
		
		override public function get reducedPath():Boolean {
			return false;
		};
		
		override public function findPath(pPathGrid:Grid, pHeuristic:Function,
								          pStart:Node, pEnd:Node):Boolean {
			if (!pStart || !pEnd) return false;
			
			_grid      = pPathGrid;
			_heuristic = pHeuristic;
			
			_open.length   = 0;
			
			var id:Object;
			
			_start = pStart;
			_end   = pEnd;
			
			_start.g = 0;
			_start.h = _heuristic(_start, _end, straightCost, diagonalCost);
			_start.f = _start.g + _start.h;  
			
			return search();
		};
		
		private function search():Boolean {
			var node:Node = _start;
			
			var startX:uint;
			var startY:uint;
			
			var endX:uint;
			var endY:uint;
			
			var i:uint;
			var j:uint;
			
			var test:Node;
			
			var cost:Number;
			
			var g:Number;
			var h:Number;
			var f:Number;
			
			var min:Function = Math.min;
			var max:Function = Math.max;
			
			var iterations:uint = 0;
			
			while (node != _end) {
				startX = max(0, node.indexX - 1);
				startY = max(0, node.indexY - 1);
				
				endX = min(_grid.sizeX - 1, node.indexX + 1);
				endY = min(_grid.sizeY - 1, node.indexY + 1);
				
				for (i = startX; i <= endX; ++i) {
					for (j = startY; j <= endY; ++j) {
						test = _grid.take(i, j) as Node;
						
						iterations++;
						
						if (test == node || !test.walkable ||
							!Node(_grid.take(node.indexX, test.indexY)).walkable ||
							!Node(_grid.take(test.indexX, node.indexY)).walkable) {
								continue;
						}
						
						cost = straightCost;
						
						if (!((node.indexX == test.indexX) || 
							  (node.indexY == test.indexY))) {
							if (!isDiagonal) {
								continue;
							}
							
							cost = diagonalCost;
						}
							
						g = node.g + cost;
						h = _heuristic(test, _end, straightCost, diagonalCost);
						f = g + h;
						
						if (test.opened || test.closed) {
							if (test.f > f) {
								test.g = g;
								test.h = h;
								test.f = f;
								
								test.parent = node;
							}
						} else {
							test.g = g;
							test.h = h;
							test.f = f;
							
							test.parent = node;
							
							_open.push(test);
							test.opened = true;
						}
					}
				}
				
				node.closed = true;
				
				if (_open.length == 0) {
					trace('AStart.search: Cannot find path!');
					return false;
				}
				
				_open.sortOn('f', Array.NUMERIC);
				
				node = _open.shift() as Node;
			}
			
			buildPath();
			
			trace("AStar.search:", 'FINDED in', iterations, 'iterations');
			
			return true;
		};
	};
}