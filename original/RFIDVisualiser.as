package {	import flash.display.MovieClip;		import com.proalias.rfid.RFIDConnect;	import com.proalias.rfid.RFIDEvent;
	import com.proalias.animation.transitionitems.Transition;	import com.proalias.animation.easing.Quad;	import com.proalias.animation.TransitionManager;		import flash.geom.ColorTransform;	import flash.display.Stage;	import flash.display.StageScaleMode;
	/**
	 * @author Alias
	 */
	public class RFIDVisualiser extends MovieClip {
		private var reader : RFIDConnect;
		private var cardGraphic : MovieClip;		public function RFIDVisualiser() {
			reader = new RFIDConnect("127.0.0.1", 5335);
			reader.addEventListener(RFIDEvent.TAG_RESPONSE, tagResponse);			cardGraphic = new CardGraphic();			stage.scaleMode = StageScaleMode.NO_SCALE;			cardGraphic.x = stage.stageWidth / 2;			cardGraphic.y = stage.stageHeight / 2;			cardGraphic.scaleX = 0;			cardGraphic.scaleY = 0;			cardGraphic.alpha = 0;			addChild(cardGraphic);
		}
		private function tagResponse(e : RFIDEvent) : void {
			trace("RFIDVisualiser.tagResponse(" + e + ")");						switch(e.type){				case RFIDEvent.TAG_RESPONSE:												var tagInfo:Array = e.tag.split(" ");												var r:Number = parseInt(tagInfo[0]);												var g:Number = parseInt(tagInfo[1]);												var b:Number = parseInt(tagInfo[2]);												var rot:Number = parseInt(tagInfo[3]);												var ct:ColorTransform = new ColorTransform(r/255,g/255,b/255,1);												cardGraphic.transform.colorTransform  = ct;												var tIn:Transition = new Transition(cardGraphic,{rotation:rot,alpha:1,scaleX:1,scaleY:1},Quad.easeOut,24);												TransitionManager.instance.addItem(tIn,"card");				case RFIDEvent.NO_TAG:															var tOut:Transition = new Transition(cardGraphic,{rotation:0,alpha:0,scaleX:0,scaleY:0},Quad.easeOut,24);												//TransitionManager.instance.clearAllTweens();												TransitionManager.instance.addItem(tOut,"card");												
			}		}
	}
}
