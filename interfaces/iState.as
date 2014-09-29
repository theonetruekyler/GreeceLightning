package interfaces{
	public interface iState {
		// updates visuals, called every frame
		function update():void;
		// cleans previous state, prevents memory leaks
		function destroy():void;
	}
}