//Created by Action Script Viewer - http://www.buraks.com/asv
package com.proalias.rfid
{
    import flash.events.EventDispatcher;
    import flash.net.Socket;
    import flash.events.IOErrorEvent;
    import flash.events.Event;
    import flash.utils.ByteArray;
    import flash.events.ProgressEvent;
    import flash.events.*;
    import flash.utils.*;
    import flash.net.*;

    public class RFIDConnect extends EventDispatcher 
    {

        private var $host:String;
        private var $socket:Socket;
        private var currentTagId:String;
        private var $seekTag:uint;
        private var _tagPresent:Boolean;
        private var $port:int;

        public function RFIDConnect(_arg1:String, _arg2:int)
        {
            $host = _arg1;
            $port = _arg2;
            trace("RFIDConnect.RFIDConnect()");
            currentTagId = new String();
            openSocket();
        }

        private function ioError(_arg1:IOErrorEvent):void
        {
            trace((("RFIDConnect.ioError(" + _arg1.type) + ")"));
        }

        private function socketClose(_arg1:Event):void
        {
            trace((("RFIDConnect.socketClose(" + _arg1.type) + ")"));
        }

        private function handleResponse(_arg1:ByteArray):void
        {
            var _local2:int;
            var _local3:int;
            var _local4:uint;
            var _local5:String;
            var _local6:int;
            var _local7:String;
            var _local8:String;
            var _local9:int;
            var _local10:String;
            var _local11:String;
            trace((("RFIDConnect.handleResponse(" + _arg1) + ")"));
            _local2 = _arg1[3];
            _local3 = _arg1[2];
            _local4 = 4;
            switch (_local2)
            {
                case Commands.READ_FIRMWARE_VERSION:
                    _local5 = "";
                    _local9 = 0;
                    while (_local9 < _local3)
                    {
                        _arg1[(_local9 + _local4)];
                        _local10 = String.fromCharCode(_arg1[(_local9 + _local4)]);
                        trace(("RFIDConnect.receiveData::" + _local10));
                        _local5 = (_local5 + _local10);
                        _local9++;
                    };
                    trace(("RFIDConnect.receiveData::output=" + _local5));
                    break;
                case Commands.SELECT_TAG:
                    trace((("RFIDConnect.receiveData::expected response is " + _local3) + " bytes."));
                    if (_local3 == 2)
                    {
                        trace("RFIDConnect.handleResponse::No tag is present");
                        _local11 = String.fromCharCode(_arg1[(_local9 + _local4)]);
                        if (_local11 == "N")
                        {
                            trace("RFIDConnect.handleResponse::The RF field is ON");
                        }
                        else
                        {
                            if (_local11 == "R")
                            {
                                trace("RFIDConnect.handleResponse::The RF field is OFF");
                            };
                        };
                        if (_tagPresent)
                        {
                            currentTagId = new String();
                            dispatchEvent(new RFIDEvent(RFIDEvent.NO_TAG, "", 0, ""));
                            _tagPresent = false;
                        };
                        break;
                    };
                    _local6 = _arg1[(_local9 + _local4)];
                    switch (_local6)
                    {
                        case 1:
                            _local7 = "Mifare Ultralight";
                            break;
                        case 2:
                            _local7 = "Mifare Standard 1K";
                            break;
                        case 3:
                            _local7 = "Mifare Classic 4K";
                            break;
                        case 0xFF:
                            _local7 = "Unknown Tag type";
                            break;
                    };
                    trace(("RFIDConnect.handleResponse::Tag type is:" + _local7));
                    _local8 = new String();
                    _local9 = 2;
                    while (_local9 < _local3)
                    {
                        trace(("RFIDConnect.receiveData::" + _local10));
                        _local8 = (_local8 + (_arg1[(_local9 + _local4)].toString() + " "));
                        _local9++;
                    };
                    trace(("RFIDConnect.handleResponse::Tag ID is " + _local8));
                    _tagPresent = true;
                    trace(("RFIDConnect.receiveData::output=" + _local5));
                    if (_local8 != currentTagId)
                    {
                        currentTagId = _local8;
                        dispatchEvent(new RFIDEvent(RFIDEvent.TAG_RESPONSE, _local8, _local6, _local7));
                    };
                    break;
            };
            clearInterval($seekTag);
            $seekTag = setInterval(requestTag, 500);
        }

        private function requestTag():void
        {
            trace("RFIDConnect.requestTag()");
            sendCommand(Commands.SELECT_TAG);
        }

        private function openSocket():void
        {
            trace("RFIDConnect.openSocket()");
            $socket = new Socket();
            $socket.addEventListener(Event.CONNECT, socketConnect);
            $socket.addEventListener(Event.CLOSE, socketClose);
            $socket.addEventListener(IOErrorEvent.IO_ERROR, ioError);
            $socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityError);
            $socket.addEventListener(ProgressEvent.SOCKET_DATA, receiveData);
            $socket.connect($host, $port);
            requestTag();
        }

        private function sendCommand(_arg1:int):void
        {
            var _local2:Array;
            var _local3:int;
            var _local4:int;
            trace("RFIDConnect.sendCommand(cmd)");
            _local2 = new Array();
            _local2.push(0xFF);
            _local2.push(0);
            _local3 = Commands.getCommandLength(_arg1);
            _local2.push(_local3);
            _local2.push(_arg1);
            _local2.push(checkSum(_local2));
            _local4 = 0;
            while (_local4 < _local2.length)
            {
                trace(("RFIDConnect.sendCommand::send\t:" + _local2[_local4].toString(16)));
                $socket.writeByte(_local2[_local4]);
                _local4++;
            };
            $socket.flush();
        }

        private function securityError(_arg1:SecurityError):void
        {
            trace((("RFIDConnect.securityError(" + _arg1.message) + ")"));
        }

        private function checkSum(_arg1:Array):int
        {
            var _local2:int;
            var _local3:int;
            _local2 = 0;
            _local3 = 2;
            while (_local3 < _arg1.length)
            {
                _local2 = (_local2 + _arg1[_local3]);
                _local3++;
            };
            return (_local2);
        }

        private function receiveData(_arg1:ProgressEvent):void
        {
            var _local2:ByteArray;
            var _local3:int;
            trace((("RFIDConnect.receiveData(" + _arg1) + ")"));
            _local2 = new ByteArray();
            $socket.readBytes(_local2);
            _local3 = 0;
            while (_local3 < _local2.bytesAvailable)
            {
                trace(("RFIDConnect.receiveData::" + _local2[_local3].toString(16)));
                _local3++;
            };
            clearInterval($seekTag);
            handleResponse(_local2);
        }

        private function socketConnect(_arg1:Event):void
        {
            trace((("RFIDConnect.socketConnect(" + _arg1.type) + ")"));
        }


    }
}//package com.proalias.rfid
