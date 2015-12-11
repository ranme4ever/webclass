package com.vo
{
	import com.protocol.NetProtocol;
	import com.protocol.ProtocolFieldType;
	import com.protocol.ProtocolSchema;
	
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
		private var _body:ByteArray=new ByteArray();
		public var command:uint = 0;
		
		private var entry:Object;


		public function get buffer():ByteArray
		{
			return _buffer;
		}

		private function cleanPacket():void
		{
			buffer.clear();
			command = 0;
			_body.clear();
			entry = null;
		}
		public function writePacket(c:uint,body:ByteArray):void
		{
			command = c;
			_body = body;
			buffer.writeMultiByte("TAG", HEADER_TAG_CHARSET);//包头标示
			buffer.writeByte(HEADER_VERSION)
			buffer.writeUnsignedInt(command);//包 指令
			buffer.writeUnsignedInt(body.length);//body长度
			buffer.writeBytes(body);
		}
		/**
		 * 将entry 反序列化成bytearray
		 * @param cmd
		 * @param entry
		 * @return 
		 * 
		 */
		public function writeEntry(c:uint,entry:Object):void
		{
			command = c;
			entry = entry;
		
			var schema:Object = NetProtocol.getSchema(command);
			var ba:ByteArray = serializeObject(schema.fields,entry);
			writePacket(command,ba);
		}
		private function serializeObject(schemas:Array,object:Object):ByteArray
		{
			var cpos:Number = 0;
			var ba:ByteArray = new ByteArray();
			for each(var field:ProtocolSchema in schemas){
				switch(field.type)
				{
					case ProtocolFieldType.STRING:
						var len:uint = 0;
						if(field.length == "x")
						{
							len = object[field.name].length;
							ba.writeUnsignedInt(len);
						}else
							len = field.length as uint;
						ba.writeMultiByte(object[field.name],"utf-8");
						if(field.length == "x")len+=4;
						cpos+=len;
						break;
					case ProtocolFieldType.UINT:
						ba.writeUnsignedInt(object[field.name]);
						cpos+=field.length;
						break;
					case ProtocolFieldType.BYTE_ARRAY:
						var buf:ByteArray = object[field.name] as ByteArray;
						if (field.length == "x"){
							cpos += buf.readUnsignedInt();						
							ba.writeBytes(buf,4);
						}else{
							cpos += field.length;
							ba.writeBytes(buf);
						}
						break;
					case ProtocolFieldType.LIST:
						var list:Array = object[field.name];
						var lst_buf:ByteArray = new ByteArray();
						for each(var item:Object in list){
							var item_buf:ByteArray = serializeObject(field.itemSchema,item);
							lst_buf.writeBytes(item_buf);
						}
						var lst_len:uint = lst_buf.length;
						ba.writeUnsignedInt(lst_len);
						ba.writeBytes(lst_buf);
						cpos+=(4+lst_len);
						break;
					default:
						break;
				}
				if(ba.position < cpos)ba.position = cpos;
			}
			ba.length = ba.position;
			ba.position = 0;
			return ba;
		}
		/**
		 * 将packet序列化成对象 
		 * @return 
		 */		
		public function getEntry():Object
		{
			if(!entry)
			{
				entry ={};
				var schema:Object = NetProtocol.getSchema(command);
				_body.position = 0;
				entry = deSerializeBinary( schema.fields,_body)
				entry.cmd = command;
			}
			return entry;
		}
		
		private function deSerializeBinary(schemas:Array,bytes:ByteArray,curpos:uint = 0):Object
		{
			var obj:Object = {};
			var pos:Number = 0;
			for each(var field:ProtocolSchema in schemas)
			{
				var len:uint = 0;
				switch(field.type){
					case ProtocolFieldType.STRING:
						if(field.length == "x")
							len = bytes.readUnsignedInt();
						else
							len = field.length as uint;
						obj[field.name] = bytes.readMultiByte(len,"utf-8");
						if(field.length == "x")len+=4;
						break;
					case ProtocolFieldType.UINT:
						obj[field.name] = bytes.readUnsignedInt();
						len = field.length as uint;
						break;
					case ProtocolFieldType.BYTE_ARRAY:
						len = field.length as uint;
						var ba:ByteArray = new ByteArray();
						bytes.readBytes(ba,0,len)
						obj[field.name]  = ba;
						break;
					case ProtocolFieldType.LIST:
						var lst_len:uint = bytes.readUnsignedInt();
						var lst_buf:ByteArray = new ByteArray();
						bytes.readBytes(lst_buf,0,lst_len);
						lst_buf.position = 0;
						var lst:Array = [];
						while(lst_buf.bytesAvailable){
							lst.push(deSerializeBinary(field.itemSchema,lst_buf,lst_buf.position));
						}
						obj[field.name] = lst;
						len+=(lst_len+4)
						break;
					default:
						break
					
				}
				pos+=len;
				if(bytes.position < (curpos+ pos)) bytes.position = (curpos+ pos);
			}
			return obj;
		}
	}
}