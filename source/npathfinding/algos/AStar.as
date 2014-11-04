package npathfinding.algos {
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
			
			_open.length = 0;
			
			for each (var node:Node in _grid.items.list) {
                node.g = 0;
                node.h = 0;
                node.f = 0;

				node.closed = false;
				node.opened = false;
			}
			
			_start = pStart;
			_end   = pEnd;
			
			_start.g = 0;
			_start.h = _heuristic(_start, _end, straightCost, diagonalCost);
			_start.f = _start.g + _start.h;  
			
			return search();
		};
		
		private function search():Boolean {
			var node:Node = _start;
			
			var startX:int;
			var startY:int;
			
			var endX:int;
			var endY:int;
			
			var i:int;
			var j:int;
			
			var test:Node;
			
			var cost:Number;
			
			var g:Number;
			var h:Number;
			var f:Number;
			
			var min:Function = Math.min;
			var max:Function = Math.max;

			while (node != _end) {
				startX = max(_grid.minX, node.indexX - 1);
				startY = max(_grid.minY, node.indexY - 1);
				
				endX = min(_grid.maxX - 1, node.indexX + 1);
				endY = min(_grid.maxY - 1, node.indexY + 1);
				
				for (i = startX; i <= endX; ++i) {
					for (j = startY; j <= endY; ++j) {
						test = _grid.take(i, j) as Node;
						
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
					return false;
				}
				
				_open.sortOn('f', Array.NUMERIC);
				
				node = _open.shift() as Node;
			}
			
			buildPath();
			
			return true;
		};
	};
}