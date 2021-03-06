package aima.core.environment.jars;

import java.util.LinkedHashSet;
import java.util.Set;

import aima.core.agent.Action;
import aima.core.search.framework.ActionsFunction;
import aima.core.search.framework.ResultFunction;

public class JarsProblemFunctionFactory {
	private static ActionsFunction _actionsFunction = null;
	private static ResultFunction _resultFunction = null;

	public static ActionsFunction getActionsFuction() {
		if (null == _actionsFunction) {
			_actionsFunction = new EPActionsFunction();
		}
		return _actionsFunction;
	}
	
	public static ResultFunction getResultFunction() {
		if (null == _resultFunction) {
			_resultFunction = new EPResultFunction();
		}
		return _resultFunction;
	}
	
	private static class EPActionsFunction implements ActionsFunction {
		public Set<Action> actions(Object state) {
			JarsProblem problem = (JarsProblem) state;

			Set<Action> actions = new LinkedHashSet<Action>();
			
			if (problem.canJar(JarsProblem.POURLEFT)){
				actions.add(JarsProblem.POURLEFT);
			}
			if (problem.canJar(JarsProblem.POURRIGHT)){
				actions.add(JarsProblem.POURRIGHT);
			}			
			if (problem.canJar(JarsProblem.FILLLEFT)){
				actions.add(JarsProblem.FILLLEFT);
			}
			if (problem.canJar(JarsProblem.FILLRIGHT)){
				actions.add(JarsProblem.FILLRIGHT);
			}
			if (problem.canJar(JarsProblem.DUMPLEFT)){
				actions.add(JarsProblem.DUMPLEFT);
			}
			if (problem.canJar(JarsProblem.DUMPRIGHT)){
				actions.add(JarsProblem.DUMPRIGHT);
			}
			
			return actions;
		}
		
	}
	
	private static class EPResultFunction implements ResultFunction {
		public Object result(Object s, Action a) {
			JarsProblem board = (JarsProblem) s;
			
			if (JarsProblem.POURLEFT.equals(a)
					&& board.canJar(JarsProblem.POURLEFT)){
				JarsProblem newBoard = new JarsProblem(board);
				newBoard.pourLeft();
				return newBoard;
			}else if (JarsProblem.POURRIGHT.equals(a)
					&& board.canJar(JarsProblem.POURRIGHT)){
				JarsProblem newBoard = new JarsProblem(board);
				newBoard.pourRight();
				return newBoard;
			}else if (JarsProblem.DUMPLEFT.equals(a)
					&& board.canJar(JarsProblem.DUMPLEFT)){
				JarsProblem newBoard = new JarsProblem(board);
				newBoard.dumpLeft();
				return newBoard;
			}else if (JarsProblem.DUMPRIGHT.equals(a)
					&& board.canJar(JarsProblem.DUMPRIGHT)){
				JarsProblem newBoard = new JarsProblem(board);
				newBoard.dumpRight();
				return newBoard;
			}else if (JarsProblem.FILLLEFT.equals(a)
					&& board.canJar(JarsProblem.FILLLEFT)){
				JarsProblem newBoard = new JarsProblem(board);
				newBoard.fillLeft();
				return newBoard;
			}else if (JarsProblem.FILLRIGHT.equals(a)
					&& board.canJar(JarsProblem.FILLRIGHT)){
				JarsProblem newBoard = new JarsProblem(board);
				newBoard.fillRight();
				return newBoard;
			}
			return s;
		}

	}
}
