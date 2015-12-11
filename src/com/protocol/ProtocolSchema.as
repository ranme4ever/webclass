package com.protocol
{
	public class ProtocolSchema
	{
		public function ProtocolSchema(name:String,type:String,length:Object,itemSchema:Array=null)
		{
			_name = name;
			_type = type;
			_length = length;
			if(type == ProtocolFieldType.LIST)
			{
				_itemSchema = itemSchema
			}
		}
		private var _type:String;
		private var _length:Object;
		private var _name:String;
		private var _itemSchema:Array;

		public function get itemSchema():Array
		{
			return _itemSchema;
		}

		public function get name():String
		{
			return _name;
		}

		public function get length():Object
		{
			return _length;
		}

		public function get type():String
		{
			return _type;
		}

	}
}