
	import com.proalias.animation.transitionitems.Transition;

	 * @author Alias
	 */
	public class RFIDVisualiser extends MovieClip {
		private var reader : RFIDConnect;
		private var cardGraphic : MovieClip;
			reader = new RFIDConnect("127.0.0.1", 5335);
			reader.addEventListener(RFIDEvent.TAG_RESPONSE, tagResponse);
		}

			trace("RFIDVisualiser.tagResponse(" + e + ")");
			}
	}
}