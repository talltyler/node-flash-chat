package
{

import flash.events.Event;
import flash.display.Sprite;
import flash.events.DataEvent;
import flash.text.TextField;
import flash.net.XMLSocket;
import flash.events.MouseEvent;

public class node extends Sprite
{
	private var socket:XMLSocket;
	private var input:TextField;
	private var output:TextField;
	
	public function node()
	{
		super();
		stage.addEventListener( Event.ENTER_FRAME, initialize );
		stage.addEventListener( MouseEvent.CLICK, submit );
	}

	private function initialize(event:Event):void
	{
		stage.removeEventListener( Event.ENTER_FRAME, initialize );
		stage.align = "TL";
		stage.scaleMode = "noScale";
		
		input = makeField();
		input.type = "input";
		addChild(input);
		
		output = makeField();
		output.x = stage.stageWidth/2;
		addChild(output);
		
		socket = new XMLSocket();
		socket.addEventListener(DataEvent.DATA, onData);
		socket.connect("127.0.0.1", 3000);
	}
	
	public function send(data:String):void
	{
		if( data != "" && socket != null && socket.connected) {
			socket.send(data);
		}
	}

	public function close():void
	{
		if( socket != null && socket.connected) {
	    	socket.close();
		}
	}
	
	private function onData(event:DataEvent):void
	{
	    output.appendText(event.data + "\n");
	    output.scrollV = output.maxScrollV;
	}
	
	private function makeField():TextField
	{
		var field:TextField = new TextField();
		field.multiline = true;
		field.wordWrap = true;
		field.border = true;
		field.width = stage.stageWidth/2;
		field.height = stage.stageHeight;
		field.htmlText = "<font face='_typewriter'>";
		return field;
	}
	
	private function submit(event:Event):void
	{
		send( input.text );
		input.text = "";
	}
}

}