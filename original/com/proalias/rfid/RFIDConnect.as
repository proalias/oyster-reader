package com.proalias.rfid {
	import flash.net.Socket;
	import flash.events.ProgressEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.utils.ByteArray;
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	import flash.events.EventDispatcher;

	/**
	 * @author Alias Cummins
	 */
	public class RFIDConnect extends EventDispatcher {
		private var $socket : Socket;
		private var $port : int;
		private var $host : String;
		private var $seekTag : uint;		private var _tagPresent : Boolean;
		private var currentTagId : String;
		public function RFIDConnect(host:String,port:int) {
			$host = host;
			$port = port;
			trace("RFIDConnect.RFIDConnect()");
			currentTagId = new String();
			openSocket();
		}
		
		private function openSocket() : void {
			trace("RFIDConnect.openSocket()");
			$socket = new Socket();
			$socket.addEventListener(Event.CONNECT, socketConnect);
			$socket.addEventListener(Event.CLOSE, socketClose);
			$socket.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			$socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityError);
			$socket.addEventListener(ProgressEvent.SOCKET_DATA, receiveData);
			$socket.connect($host, $port);
			//$seekTag = setInterval(requestTag,500);
			requestTag();
		}
		

		private function securityError(e:SecurityError) : void {
			trace("RFIDConnect.securityError("+e.message+")");
		}

		private function ioError(e:IOErrorEvent) : void {
			trace("RFIDConnect.ioError("+e.type+")");
		}

		private function socketClose(e:Event) : void {
			trace("RFIDConnect.socketClose("+e.type+")");
		}

		private function socketConnect(e:Event) : void {
			trace("RFIDConnect.socketConnect("+e.type+")");
		}
		
		private function receiveData(e:ProgressEvent) : void {
			trace("RFIDConnect.receiveData(" + e +")" );
			var response:ByteArray = new ByteArray();
			var i:int;
			$socket.readBytes(response);
			for (i = 0;i<response.bytesAvailable;i++){
				
				trace("RFIDConnect.receiveData::"+response[i].toString(16));	
			}
			clearInterval($seekTag);
			handleResponse(response);
		}
		
		private function handleResponse(response:ByteArray) : void {
			trace("RFIDConnect.handleResponse("+response+")");
			var commandType:int = response[3];//the command code we are responding to - corresponds to the constants in Commands class
			var dataLen:int 	= response[2];//the length of the expected response is held in the second byte
			
			var responseOffset:uint = 4;//the reader echoes back the command it has been sent, so ignore the first 4 bytes
								
			switch(commandType){
				case Commands.READ_FIRMWARE_VERSION:
								
								var responseStr:String = "";
								for (var i:int = 0;i<dataLen;i++){
									response[i+responseOffset];
									var o:String = String.fromCharCode(response[i+responseOffset]);
									trace("RFIDConnect.receiveData::"+o);
									responseStr+=o;
									
								}
								trace("RFIDConnect.receiveData::output="+responseStr);
								break;
								
				case Commands.SELECT_TAG:
								
								trace("RFIDConnect.receiveData::expected response is "+dataLen+" bytes.");
								
								//is a tag present?
								if (dataLen == 2){
									trace("RFIDConnect.handleResponse::No tag is present");
									var errorCode:String = String.fromCharCode(response[i+responseOffset]);
									if (errorCode == "N"){
										trace("RFIDConnect.handleResponse::The RF field is ON");	
									}else if (errorCode == "R"){
										trace("RFIDConnect.handleResponse::The RF field is OFF");
									}
									
									if (_tagPresent){
										currentTagId = new String();
										dispatchEvent(new RFIDEvent(RFIDEvent.NO_TAG,"",0,""));
										_tagPresent = false;
									}
									break;
								}
								
								//a tag is present - how much do we know about it?
								
								/*From Datasheet:
								 * 
								 	0x01 – Mifare Ultralight
									0x02 – Mifare Standard 1K
									0x03 – Mifare Classic 4K
									0xFF – Unknown Tag type
								 * 
								 */
								
								var tagType:int = response[i+responseOffset];
								var tagTypeStr:String;
								switch(tagType){
									case 0x01:			tagTypeStr = "Mifare Ultralight";
														break;
									case 0x02:			tagTypeStr = "Mifare Standard 1K";
														break;									
									case 0x03:			tagTypeStr = "Mifare Classic 4K";
														break;
									case 0xFF:			tagTypeStr = "Unknown Tag type";
														break;							
								}						
								
								trace("RFIDConnect.handleResponse::Tag type is:"+tagTypeStr);
								
								var tagId:String = new String();
								
								for (i = 2;i<dataLen;i++){
									//var o:String = response[i+responseOffset].toString() + "		" + String.fromCharCode(response[i+responseOffset]);
									trace("RFIDConnect.receiveData::"+o);
									tagId+=response[i+responseOffset].toString() + " ";
								}
								
								trace("RFIDConnect.handleResponse::Tag ID is "+tagId);
								
								_tagPresent = true;
								
								trace("RFIDConnect.receiveData::output="+responseStr);
								if (tagId != currentTagId){
									currentTagId = tagId;
									dispatchEvent(new RFIDEvent(RFIDEvent.TAG_RESPONSE, tagId, tagType,tagTypeStr));
								}
								break;			
			} 
			
			//wait 2 seconds than start seeking again
			clearInterval($seekTag);
			$seekTag = setInterval(requestTag,500);
		}

		
		private function requestTag() : void {
			trace("RFIDConnect.requestTag()");
			sendCommand(Commands.SELECT_TAG);
		}
		
		/*
		 * Build a command sequence for the reader
		 */
		private function sendCommand(cmd:int):void{
			trace("RFIDConnect.sendCommand(cmd)");
			var cmdSeq:Array = new Array();
			//terminator sequence
			cmdSeq.push(0xFF);
			cmdSeq.push(0x00);
			
			//write command sequence
			var len:int = Commands.getCommandLength(cmd);
			cmdSeq.push(len);
			cmdSeq.push(cmd);
			cmdSeq.push(checkSum(cmdSeq));
			for(var i:int = 0;i<cmdSeq.length;i++){
				trace("RFIDConnect.sendCommand::send	:"+cmdSeq[i].toString(16));
				$socket.writeByte(cmdSeq[i]);	
			}
			$socket.flush();
		}
		
		/*
		 * Get the checksum for whatever command you've sent
		 */
		private function checkSum(cmdSequence : Array) : int {
			
			var checkSum:int = 0;
			for (var i:int = 2;i<cmdSequence.length;i++){
				checkSum += cmdSequence[i];
			}
			return checkSum;
		}
	}
}
