//Created by Action Script Viewer - http://www.buraks.com/asv
package 
{
    import flash.display.MovieClip;
    import com.proalias.rfid.RFIDConnect;
    import flash.geom.ColorTransform;
    import com.proalias.animation.transitionitems.Transition;
    import com.proalias.rfid.RFIDEvent;
    import com.proalias.rfid.*;
    import com.proalias.animation.*;
    import com.proalias.animation.transitionitems.*;
    import com.proalias.animation.easing.*;
    import flash.display.*;
    import flash.geom.*;

    public class RFIDVisualiser extends MovieClip 
    {

        private var reader:RFIDConnect;
        private var cardGraphic:MovieClip;

        public function RFIDVisualiser()
        {
            reader = new RFIDConnect("127.0.0.1", 5335);
            reader.addEventListener(RFIDEvent.TAG_RESPONSE, tagResponse);
            cardGraphic = new CardGraphic();
            stage.scaleMode = StageScaleMode.NO_SCALE;
            cardGraphic.x = (stage.stageWidth / 2);
            cardGraphic.y = (stage.stageHeight / 2);
            cardGraphic.scaleX = 0;
            cardGraphic.scaleY = 0;
            cardGraphic.alpha = 0;
            addChild(cardGraphic);
        }

        private function tagResponse(_arg1:RFIDEvent):void
        {
            var _local2:Array;
            var _local3:Number;
            var _local4:Number;
            var _local5:Number;
            var _local6:Number;
            var _local7:ColorTransform;
            var _local8:Transition;
            var _local9:Transition;
            trace((("RFIDVisualiser.tagResponse(" + _arg1) + ")"));
            switch (_arg1.type)
            {
                case RFIDEvent.TAG_RESPONSE:
                    _local2 = _arg1.tag.split(" ");
                    _local3 = parseInt(_local2[0]);
                    _local4 = parseInt(_local2[1]);
                    _local5 = parseInt(_local2[2]);
                    _local6 = parseInt(_local2[3]);
                    _local7 = new ColorTransform((_local3 / 0xFF), (_local4 / 0xFF), (_local5 / 0xFF), 1);
                    cardGraphic.transform.colorTransform = _local7;
                    _local8 = new Transition(cardGraphic, {
                        rotation:_local6,
                        alpha:1,
                        scaleX:1,
                        scaleY:1
                    }, Quad.easeOut, 24);
                    TransitionManager.instance.addItem(_local8, "card");
                case RFIDEvent.NO_TAG:
                    _local9 = new Transition(cardGraphic, {
                        rotation:0,
                        alpha:0,
                        scaleX:0,
                        scaleY:0
                    }, Quad.easeOut, 24);
                    TransitionManager.instance.addItem(_local9, "card");
            };
        }


    }
}//package 
