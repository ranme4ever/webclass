package com.proxy
{
	import com.commands.HandleSocketCommand;
	import com.constants.NotificationType;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.patterns.facade.Facade;

	public class SocketService
	{
		private var socket:Socket;
		private var _responder:IResponder;
		private var _ip:String;
		private var _ports:Array;
		
		private var portIndex:int = 0;
		private var timerHandle
		private static var CONNECT_TIMEOUT:Number = 60*1000;
		private static var SOCKET_TIMEOUT:Number = 30*1000;
			
		
		public function SocketService()
		{
			initSocketService();
		}
		private function initSocketService():void
		{
			if(!socket){
				socket = new Socket();
				socket.addEventListener(Event.CONNECT, connectOKHandle);
				socket.addEventListener(ProgressEvent.SOCKET_DATA, handleSocketData);
				socket.addEventListener(Event.CLOSE, socket_closeHandler);
				socket.addEventListener(IOErrorEvent.IO_ERROR, connectErrorHandle);
				socket.addEventListener(IOErrorEvent.NETWORK_ERROR, connectErrorHandle);
				socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, connectErrorHandle);
				socket.timeout = SOCKET_TIMEOUT;
			}
		}
		
		public function connectSocket(ip:String,ports:Array,responder:IResponder):void
		{
			_responder = responder;
			_ip = ip;
			_ports = ports;
			connectSocketServer();
		}
	
		private function connectSocketServer():void
		{
			if (portIndex >= _ports.length) {
				this._responder.fault({error: 'socketConnectTimeOut'});
				destorySocket();
				return;
			}
			if (socket.connected) {
				socket.close();
			}
			
			var port:uint = _ports[portIndex % _ports.length];
			socket.connect(_ip, port);
			portIndex++;
			if(timerHandle)
				clearTimeout(timerHandle);
			timerHandle = setTimeout(connectSocketServer, CONNECT_TIMEOUT);
		}
		public function sendData(data:Object):void
		{
			//send data
		}
		private function connectOKHandle(event:Event):void {
			this._responder.result({type:"socketConnectSuccess",message: "socketConnectSuccess"});
		}
		
		private function handleSocketData(event:Event = null):void {
			if(!socket.connected){
				return;
			}
			//parse & serialize socket data to object
			var data:ByteArray = new ByteArray
			socket.readBytes(data,data.position,socket.bytesAvailable);
			var result:Object = serializeBytearray(data)
				
			protocolHandel(result)
		
			
		}
		private function protocolHandel(data:Object):void {
			Facade.getInstance().sendNotification(HandleSocketCommand.SOCKET_DATA_COMMOND, data);
		}
		
		private function serializeBytearray(data:ByteArray):Object{
			return {cmd:'',data:''}
		}
		
		private function destorySocket():void {
			portIndex = 0;
			if (socket.connected)
				socket.close();
		}
		private function socket_closeHandler(event:Event):void {
			Facade.getInstance().sendNotification(NotificationType.SERVER_CONNECTION_CLOSED);
			connectErrorHandle(event);
		}
		private function connectErrorHandle(event:Event):void
		{
			connectSocketServer();
		}

	}
}