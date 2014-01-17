package npathfinding.algos {
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import ncollections.grid.Grid;
	
	import npathfinding.base.Algorithm;
	import npathfinding.base.Heuristic;
	import npathfinding.base.Node;
	
	public final class JumpPointSearch extends Algorithm {
		private var _open:Array;
		
		public function JumpPointSearch() {
			super();
			
			_open = [];
		};
		
		override public function get reducedPath():Boolean {
			return true;
		};
		
		override public function findPath(pPathGrid:Grid, pHeuristic:Function, 
										  pStart:Node, pEnd:Node):Boolean {
			var node:Node;
			
			_start = pStart;
			_end   = pEnd;
			
			_grid = pPathGrid;
			
			_heuristic = pHeuristic;
			
			_open.length = 0;
			
			for each (node in _grid.items.list) {
				node.closed = false;
				node.opened = false;
			}
			
			_start.g = 0;
			_start.f = 0;
			
			_open.push(_start);
			_start.opened = true;
			
			while (_open.length) {				
				node = _open.pop();
				
				_start.closed = true;
				
				if (node == _end) {
					buildPath();
					return true;
				}
				
				search(node);
			}
			
			return false;
		};
		
		private function search(pNode:Node):void {
			_path = null;
			
			var neighbors:Array = findNeighbors(pNode);
			
			for (var i:int = 0; i < neighbors.length; i++) {	
				var neighbor:Node = neighbors[i] as Node;
				var jumpNode:Node = jump(neighbor, pNode);
				
				if (!jumpNode || jumpNode.closed) {
					continue;
				}
				
				var d:Number     = Heuristic.euclidean(pNode, 
													   _grid.take(jumpNode.indexX,
													              jumpNode.indexY) as Node, 
													   straightCost, diagonalCost);
				var nextG:Number = pNode.g + d;
				
				
				if (!jumpNode.opened || nextG < jumpNode.g) {
					jumpNode.g = nextG;
					jumpNode.h = jumpNode.h || _heuristic( _grid.take(jumpNode.indexX,
														              jumpNode.indexY) as Node, 
														 _end,
														  straightCost, diagonalCost);
					jumpNode.f = jumpNode.g + jumpNode.h;
					
					jumpNode.parent = pNode;
					
					if (!jumpNode.opened) {
						_open.push(jumpNode);
						
						jumpNode.opened = true;
					}
				}
			}
			
			_open.sortOn('f', Array.NUMERIC | Array.DESCENDING);
		};
		
		private function findNeighbors(pNode:Node):Array {
			var result:Array = [];
			
			var validate:Function = function(pIndexX:int, pIndexY:int):Boolean {
				var temp:Node = _grid.take(pIndexX, pIndexY) as Node;
				
				if (!temp || !temp.walkable) {
					return false;
				}
				
				return true;
			};
			
			var validateAndAdd:Function = function(pNodeA:Node):void {
				if (!pNodeA || !pNodeA.walkable) {
					return;
				}	
				
				result.push(pNodeA);
			}
			
			if (pNode.parent) {
				var dx:int = (pNode.indexX - pNode.parent.indexX) / 
							 Math.max(Math.abs(pNode.indexX - pNode.parent.indexX), 1);
				var dy:int = (pNode.indexY - pNode.parent.indexY) / 
							 Math.max(Math.abs(pNode.indexY - pNode.parent.indexY), 1);
				
				if (dx != 0 && dy != 0) {
					validateAndAdd(_grid.take(pNode.indexX, pNode.indexY + dy) as Node);
					validateAndAdd(_grid.take(pNode.indexX + dx, pNode.indexY) as Node);
					
					if (validate(pNode.indexX, pNode.indexY + dy) || 
						validate(pNode.indexX + dx, pNode.indexY)) {
						result.push(_grid.take(pNode.indexX + dx, pNode.indexY + dy) as Node);
					}
					
					if (!validate(pNode.indexX - dx, pNode.indexY) && 
						validate(pNode.indexX, pNode.indexY + dy)) {
						result.push(_grid.take(pNode.indexX - dx, pNode.indexY + dy) as Node);
					}						
					
					if (!validate(pNode.indexX, pNode.indexY - dy) && 
						validate(pNode.indexX + dx, pNode.indexY)) {
						result.push(_grid.take(pNode.indexX + dx, pNode.indexY - dy) as Node);
					}						
				} else {
					if (dx == 0) {
						if (validate(pNode.indexX, pNode.indexY + dy)) {
							validateAndAdd(_grid.take(pNode.indexX, pNode.indexY + dy) as Node);
							
							if (!validate(pNode.indexX + 1, pNode.indexY)) {
								result.push(_grid.take(pNode.indexX + 1, pNode.indexY + dy));
							}
							
							if (!validate(pNode.indexX - 1, pNode.indexY)) {
								result.push(_grid.take(pNode.indexX - 1, pNode.indexY + dy));
							}
						}
					} else {
						if (validate(pNode.indexX + dx, pNode.indexY)) {
							validateAndAdd(_grid.take(pNode.indexX + dx, pNode.indexY) as Node);
							
							if (!validate(pNode.indexX, pNode.indexY + 1)) {
								result.push(_grid.take(pNode.indexX + dx, pNode.indexY + 1));
							}
							
							if (!validate(pNode.indexX, pNode.indexY - 1)) {
								result.push(_grid.take(pNode.indexX + dx, pNode.indexY - 1));
							}
						}
					}
				}
			} else {
				validateAndAdd(_grid.take(pNode.indexX + 1, pNode.indexY) as Node);
				validateAndAdd(_grid.take(pNode.indexX - 1, pNode.indexY) as Node);
				validateAndAdd(_grid.take(pNode.indexX, pNode.indexY + 1) as Node);
				validateAndAdd(_grid.take(pNode.indexX, pNode.indexY - 1) as Node);
				
				validateAndAdd(_grid.take(pNode.indexX + 1, pNode.indexY + 1) as Node);
				validateAndAdd(_grid.take(pNode.indexX - 1, pNode.indexY - 1) as Node);
				validateAndAdd(_grid.take(pNode.indexX + 1, pNode.indexY - 1) as Node);
				validateAndAdd(_grid.take(pNode.indexX - 1, pNode.indexY + 1) as Node);
			}
			
			return result;
		};
		
		private function jump(pNode:Node, pParent:Node):Node {
			var validate:Function = function(pIndexX:int, pIndexY:int):Boolean {
				var temp:Node = _grid.take(pIndexX, pIndexY) as Node;
				
				if (!temp || !temp.walkable) {
					return false;
				}
				
				return true;
			};
			
			if (!pNode || !pNode.walkable) {
				return null;
			}
			
			if (pNode == _end) {
				return pNode;
			}
			
			var dx:int = pNode.indexX - pParent.indexX;
			var dy:int = pNode.indexY - pParent.indexY;
			
			if (dx != 0 && dy != 0) {
				if ((validate(pNode.indexX - dx, pNode.indexY + dy) &&
				    !validate(pNode.indexX - dx, pNode.indexY)) ||
				    (validate(pNode.indexX + dx, pNode.indexY - dy) && 
					!validate(pNode.indexX, pNode.indexY - dy))) {
					return pNode; 
				}
			} else {
				if (dx != 0) {
					if ((validate(pNode.indexX + dx, pNode.indexY + 1) && 
						!validate(pNode.indexX, pNode.indexY + 1)) || 
						(validate(pNode.indexX + dx, pNode.indexY - 1) && 
						!validate(pNode.indexX, pNode.indexY - 1))) {
						return pNode;
					}
				} else {
					if ((validate(pNode.indexX + 1, pNode.indexY + dy) && 
						!validate(pNode.indexX + 1, pNode.indexY)) || 
						(validate(pNode.indexX - 1, pNode.indexY + dy) && 
						!validate(pNode.indexX - 1, pNode.indexY))) {
						return pNode;
					}
				}
			}
			
			if (dx != 0 && dy != 0) {
				var jx:Node = jump(_grid.take(pNode.indexX + dx, 
											  pNode.indexY) as Node, 
								   pNode); 
				var jy:Node = jump(_grid.take(pNode.indexX, 
											  pNode.indexY + dy) as Node, 
								   pNode);
				
				if (jx || jy) {
					return pNode;
				}
			}
			
			if (validate(pNode.indexX + dx, pNode.indexY) || 
				validate(pNode.indexX, pNode.indexY + dy)) {
				return jump(_grid.take(pNode.indexX + dx, 
									   pNode.indexY + dy) as Node, 
						    pNode);
			} else {
				return null;
			}
		};
	};
}