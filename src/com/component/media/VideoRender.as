package com.component.media {

/**
 *  create time : 2012-11-01
 *  author        : Liu Xiaochun
 *  version        : 1.0
 *  flash player: 9.0 or later
 * */

import com.utils.Logger;

import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.events.NetStatusEvent;
import flash.events.SecurityErrorEvent;
import flash.media.Video;
import flash.net.NetConnection;
import flash.net.NetStream;
import flash.utils.ByteArray;

import mx.core.UIComponent;
import mx.events.ResizeEvent;

public class VideoRender {
    public var initOK:Boolean = false;
    public var fillParent:Boolean = false;
    public var hostComponent:UIComponent;
    private var connection:NetConnection;
    private var stream:NetStream;
    //
    private var width_:uint = 0;
    private var height_:uint = 0;
    private var timeStamp:uint = 0;
    private var frameRate:uint = 5;
    private var baData:ByteArray = new ByteArray();
    private var video_:Video;
    //
    public function unintVideo():void {
        hostComponent.removeEventListener(ResizeEvent.RESIZE, onVideoSize);
        hostComponent = null;
        connection.close();
        stream.close();
        stream = null;
        connection = null;
        baData = null;
        video_ = null;
    }

    //
    public function VideoRender(w:uint, h:uint, f:uint) {
        width_ = w;
        height_ = h;
        frameRate = f;
        hostComponent = new UIComponent();
        hostComponent.horizontalCenter = 0;
        hostComponent.verticalCenter = 0;
        hostComponent.percentHeight = 100;
        hostComponent.percentWidth = 100;
        connection = new NetConnection();
        connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
        connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
        connection.connect(null);
        hostComponent.addEventListener(ResizeEvent.RESIZE, onVideoSize);
    }

    public function onVideoSize(e:ResizeEvent):void {
        if (fillParent) {
            video_.x = video_.y = 0;
            video_.width = e.target.width;
            video_.height = e.target.height;
        }
        else {
            scaleVideo(video_, hostComponent);
        }
        drawBackground();
    }
	private  function scaleVideo(video:Video, parent:DisplayObject):void {
		var ratio:Number = video.videoWidth / video.videoHeight;
		var parentRatio:Number = parent.width / parent.height;
		if (ratio > parentRatio) {
			video.width = parent.width;
			video.height = video.width / ratio;
			video.x = 0;
			video.y = (parent.height - video.height) / 2;
		} else {
			video.height = parent.height;
			video.width = video.height * ratio;
			video.y = 0;
			video.x = (parent.width - video.width) / 2;
		}
	}

    private var videoAdded:Boolean = false;

    private function drawBackground():void {
        if(!hostComponent)
            return;
        var g:Graphics = hostComponent.graphics;
        g.clear();
        if(hostComponent.parent) {
            g.clear();
            g.beginFill(0);
            g.drawRect(0, 0, hostComponent.parent.width, hostComponent.parent.height);
        }
    }

    public function onFlvData(data:ByteArray, keyframe:Boolean):void {
        makeFlvTag(baData, data, keyframe);
        stream.appendBytes(baData);
    }

    public function onFlvAvccData(data:ByteArray):void {
        makeAVCCHeader(baData, data);
        stream.appendBytes(baData);
    }
//
//    public function stopVideo():void {
//        hostComponent.visible = false;
//        initOK = false;
//    }

    private function connectStream():void {
        stream = new NetStream(connection);
        stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
        stream.client = new CustomClient();
        video_ = new Video(width_, height_);
        video_.smoothing = true;
        video_.attachNetStream(stream);
        stream.bufferTime = 0;
        stream.play(null);
        stream.receiveAudio(false);
        hostComponent.addChild(video_);
        //
        makeFlvHeader(width_, height_, baData, frameRate);
        stream.appendBytes(baData);
    }

    private static function makeFlvHeader(w:int, h:int, ba:ByteArray, framerate:int = 5):void {
        //header
        ba.length = 0;
        ba.writeMultiByte("FLV", "ascii");//flv
        ba.writeByte(1);		// Version
        ba.writeByte(1); 		// Video & Audio
        ba.writeInt(9);    		// DataOffset
        ba.writeInt(0);	    	// PreviousTagSize0
        //meta-data
        ba.writeByte(0x12);    //FLV_TAG_TYPE_META
        var start:int = ba.position;
        ba.writeByte(0);
        ba.writeShort(0); // data length
        ba.writeByte(0);
        ba.writeShort(0); // timestamp
        ba.writeInt(0);					   // reserved
        //
        ba.writeByte(2);		 //AMF_DATA_TYPE_STRING
        var str:String = "onMetaData";
        ba.writeShort(str.length);
        ba.writeMultiByte(str, "ascii");
        ba.writeByte(0x8);//AMF_DATA_TYPE_MIXEDARRAY
        ba.writeInt(4); //
        str = "width";
        ba.writeShort(str.length);
        ba.writeMultiByte(str, "ascii");
        var n:Number = w;
        ba.writeByte(0);//AMF_DATA_TYPE_NUMBER
        ba.writeDouble(n);
        str = "height";
        ba.writeShort(str.length);
        ba.writeMultiByte(str, "ascii");
        n = h;
        ba.writeByte(0);//AMF_DATA_TYPE_NUMBER
        ba.writeDouble(n);
        str = "framerate";
        ba.writeShort(str.length);
        ba.writeMultiByte(str, "ascii");
        n = framerate;
        ba.writeByte(0);//AMF_DATA_TYPE_NUMBER
        ba.writeDouble(n);
        str = "videocodecid";
        ba.writeShort(str.length);
        ba.writeMultiByte(str, "ascii");
        ba.writeByte(0);
        ba.writeDouble(7.0);

        str = "";
        ba.writeShort(str.length);
        ba.writeMultiByte(str, "ascii");
        ba.writeByte(0x9);//AMF_END_OF_OBJECT
        var len:int = ba.length - start;
        ba.position = start;
        ba.writeByte(0);
        ba.writeShort(len - 10);
        ba.position = ba.length;
        ba.writeInt(len + 1);
    }

    //
    private function makeAVCCHeader(ba:ByteArray, avc:ByteArray):void {
        ba.length = 0;
        ba.writeByte(0x9);    //FLV_TAG_TYPE_VIDEO
        ba.writeByte(0);
        ba.writeShort(0); // data length
        ba.writeByte(0);
        ba.writeShort(0); // timestamp
        ba.writeByte(0);				   // timestamp extended
        ba.writeByte(0);
        ba.writeShort(0); // StreamID - Always 0
        //
        var start:int = ba.position;	   // needed for overwriting length
        ba.writeByte(0x17);  	   // Frametype and CodecID . keyframe?
        ba.writeByte(0); 				   // AVC sequence header
        ba.writeByte(0);
        ba.writeShort(0); // composition time
        //write sps pps
        avc.position = 0;
        avc.readBytes(ba, ba.position, avc.length);
        //
        var len:int = ba.length - start;
        ba.position = start - 10;
        ba.writeByte(len >>> 16);
        ba.writeShort(len);
        ba.position = ba.length;
        ba.writeInt(len + 11);				//tag length
        initOK = true;
    }

    public function makeFlvTag(ba:ByteArray, data:ByteArray, keyframe:Boolean):void {
        ba.length = 0;
        ba.writeByte(0x9);    //FLV_TAG_TYPE_VIDEO
        ba.writeByte(0);
        ba.writeShort(0); // data length
        ba.writeByte(timeStamp >>> 16);
        ba.writeShort(timeStamp); 		   // timestamp
        ba.writeByte(timeStamp >>> 24);	   // timestamp extended
        ba.writeByte(0);
        ba.writeShort(0); // StreamID - Always 0
        //
        var start:int = ba.position;	   // needed for overwriting length
        ba.writeByte(keyframe ? 0x17 : 0x27);   // Frametype and CodecID . keyframe?
        ba.writeByte(1); 				   // AVC NALU
        var offset:int = 1000 / frameRate;// duration(ms)
        ba.writeByte(offset >>> 16);
        ba.writeShort(offset); // duration time
        //write data
        data.position = 0;
        data.readBytes(ba, ba.length, data.length);
        //
        var len:uint = ba.length - start;
        ba.position = start - 10;
        ba.writeByte(len >>> 16);
        ba.writeShort(len);
        ba.position = ba.length;
        ba.writeInt(len + 11);				//tag length
        //
        timeStamp += 1000 / frameRate;
    }

    //
    private function netStatusHandler(event:NetStatusEvent):void {
        switch (event.info.code) {
            case "NetConnection.Connect.Success":
                connectStream();
                break;
            case "NetStream.Play.StreamNotFound":
                Logger.e("Stream not found: ");
                break;
            case 'NetStream.Buffer.Full':
                if(!videoAdded) {
                    videoAdded = true;
                    drawBackground();
                }
                break;
        }
//        trace('Net stream status: ' + event.info.code);
    }

    private static function securityErrorHandler(event:SecurityErrorEvent):void {
        trace("securityErrorHandler: " + event);
    }
}
}

class CustomClient {
    public function onMetaData(info:Object):void {
        trace("metadata: duration=" + info.duration + " width=" + info.width + " height=" + info.height + " framerate=" + info.framerate);
    }

    public function onCuePoint(info:Object):void {
        trace("cuepoint: time=" + info.time + " name=" + info.name + " type=" + info.type);
    }

    public function onState(info:Object):void {

    }
}
 
