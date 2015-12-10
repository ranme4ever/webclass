package com.vo
{
	import com.protocol.NetProtocol;
	
	import flash.utils.ByteArray;

	public class MsgPacket
	{
		public function MsgPacket()
		{
		}
		public static const HEADER_TAG:String = "TAG";
		public static const HEADER_TAG_CHARSET:String = "ascii";
		public static const HEADER_VERSION:uint = 0x01;
		public static const HEADER_LENGTH:uint = 12;//包头长度 TAG+VERSION+CMD+BODY_LENGTH
		
		private var _buffer:ByteArray = new ByteArray();
		private var _cmd:uint = 0;
		private var _body:ByteArray=new ByteArray();
		
		private var entry:Object;

		public function get buffer():ByteArray
		{
			return _buffer;
		}

		public function get cmd():uint
		{
			return _cmd;
		}
		private function cleanPacket():void
		{
			buffer.clear();
			_cmd = 0;
			_body.clear();
			entry = null;
		}
		public function writePacket(cmd:uint,body:ByteArray):void
		{
			cleanPacket();
			buffer.writeMultiByte("TAG", HEADER_TAG_CHARSET);//包头标示
			buffer.writeByte(HEADER_VERSION)
			buffer.writeUnsignedInt(cmd);//包 指令
			_cmd = cmd;
			buffer.writeUnsignedInt(body.length);//body长度
			buffer.writeBytes(body);
			_body = body;
		}
		/**
		 * 将entry 反序列化成bytearray
		 * @param cmd
		 * @param entry
		 * @return 
		 * 
		 */
		public function writeEntry(cmd:uint,entry:Object):void
		{
			_cmd = cmd;
			entry = entry;
			var ba:ByteArray = new ByteArray();
			var pos:uint = 0;
			var schema:Object = NetProtocol.getSchema(cmd);
			for each(var field:Object in schema.fields)
			{
				switch(field.type)
				{
					case "String":
						var len:uint = 0;
						if(field.length == "x")
						{
							len = entry[field.name].length;
							ba.writeUnsignedInt(len);
						}else
							len = field.length;
						ba.writeMultiByte(entry[field.name],"utf-8");
						pos+=len+4;
						break;
					case "uint":
						ba.writeUnsignedInt(entry[field.name]);
						pos+=field.length;
						break;
					case "ByteArray":
						var buf:ByteArray = entry[field.name] as ByteArray;
						if (field.length == "x"){
							pos += buf.readUnsignedInt();						
							ba.writeBytes(buf,4);
						}else{
							pos += field.length;
							ba.writeBytes(buf);
						}
						
						break;
					default:
						break;
				}
				if(ba.position < pos)ba.position = pos;
			}
			writePacket(_cmd,ba);
		}
		/**
		 * 将packet序列化成对象 
		 * @return 
		 */		
		public function getEntry():Object
		{
			if(!entry)
			{
				var obj:Object = {};
				obj.cmd = cmd;
				var schema:Object = NetProtocol.getSchema(cmd);
				_body.position = 0;
				var pos:uint = 0;
				for each(var field:Object in schema.fields)
				{
					var len:uint = 0;
					switch(field.type){
						case "String":
							if(field.length == "x")
								len = _body.readUnsignedInt();
							else
								len = field.length
							obj[field.name] = _body.readMultiByte(len,"utf-8");
							len+=4;
							break;
						case "uint":
							obj[field.name] = _body.readUnsignedInt();
							len = field.length 
							break;
						case "ByteArray":
							len = field.length ;
							var ba:ByteArray = new ByteArray();
							_body.readBytes(ba,0,field.length)
							obj[field.name]  = ba;
							break;
						default:
							break
							
					}
					pos+=len;
					if(_body.position < pos) _body.position = len;
				}
				entry = obj;
			}
			return entry;
		}
	}
}