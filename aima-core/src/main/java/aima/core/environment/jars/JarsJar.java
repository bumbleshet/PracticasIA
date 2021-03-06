package aima.core.environment.jars;

public class JarsJar {
	
	private int _vol;
	private final int _maxVol;
	
	/** Default constructor of Jar
	 * @param maxVolume How much the Jar can hold
	 */
	public JarsJar(int maxVolume){
		_maxVol = maxVolume;
		_vol = 0; // The jar starts empty.
	}
	
	/** Volume constructor of Jar
	 * @param maxVolume How much the Jar can hold
	 * @param volume How much is in the Jar
	 */
	public JarsJar(int maxVolume, int volume){
		_maxVol = maxVolume;
		_vol = volume;
	}
	
	/** Fuction fills v litters into the jar, up to _maxVol
	 * @param v
	 * @return How much volume overflowed.
	 */
	public int fill(int v){
		_vol = _vol+v;
		if (_vol > _maxVol){
			int overflow = _vol - _maxVol; //Overflow calculation
			_vol = _maxVol;
			return overflow; 
		}else if (_vol<0){ //We can't have a bottle with a negative volume, can we?
			_vol = 0;
		}
		return 0;
	}
	
	public int getVolume(){
		return _vol;
	}
	
	public int getMax(){
		return _maxVol;
	}
	
	public String toString(){
		return _maxVol + " " + _vol;
	}
	

}
